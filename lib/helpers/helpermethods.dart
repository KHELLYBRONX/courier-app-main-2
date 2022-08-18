import 'dart:convert';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:truckngo/globalvariables.dart';
import 'package:truckngo/helpers/requesthelper.dart';
import 'package:truckngo/models/address.dart';
import 'package:truckngo/models/directiondetails.dart';

import '../Screens/maps/bloc/maps_bloc.dart';

//UserCL = "user" from course but existing User class now already exists (formerly FirebaseUser)

class HelperMethods {
  static String? getCurrentUserInfo()
  // async
  {
    User currentFirebaseUser =
        //await
        FirebaseAuth.instance.currentUser!;
    String userid = currentFirebaseUser.uid;

    DatabaseReference userRef = FirebaseDatabase.instance.ref('users/$userid');
    userRef.once().then((snapshot) {
      print(snapshot);
    });
    return null;
  }

  static Future<String> findCoordinateAddress(
    Position position,
    context,
  ) async {
    String placeAddress = '';
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
    var response = await RequestHelper.getRequest(url);

    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];

      Address pickupAddress = Address();
      pickupAddress.longitude = position.longitude;
      pickupAddress.latitude = position.latitude;
      pickupAddress.placeName = placeAddress;
      if (pickupAddress.placeName == null) {}

      print(placeAddress);
      print(pickupAddress.placeName);
       BlocProvider.of<MapsBloc>(context).add(UpdatePickUpAddressEvent(pickupAddress));
    } else {}
    return placeAddress;
  }

  static Future<DirectionDetails?> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey';
    var response = await RequestHelper.getRequest(url);
    if (response == 'failed') {
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.durationText =
        response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue =
        response['routes'][0]['legs'][0]['duration']['value'];

    directionDetails.distanceText =
        response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue =
        response['routes'][0]['legs'][0]['distance']['value'];
//  routes[0].overview_polyline.points
    directionDetails.encodedPoints =
        response['routes'][0]['overview_polyline']['points'];
    return directionDetails;
  }

  static int estimateFares(DirectionDetails details) {
//per km = 0.7,
    //per minute = 0.5,
    // base fare = $3 ,
    double baseFare = 3;
    double distanceFare = (details.distanceValue! / 1000) * 0.3;
    double timeFare = (details.durationValue! / 60) * 0.2;

    double totalFare = baseFare + distanceFare + timeFare;
    return totalFare.truncate();
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int radInt = randomGenerator.nextInt(max);
    return radInt.toDouble();
  }

  static sendNotifications(String token, context, String rideId) async {
    var destination =
        context.select((MapsBloc bloc) => bloc.state.destinationAddress);
    Map<String, String> headerMap = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': serverKeyOauth,
    };

    Map notificationMap = {
      'title': 'NEW TRIP REQUEST',
      'body': 'Destination, ${destination.placeName}'
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_id': rideId,
    };

    Map bodyMap = {
      'message': {
        'token': token,
        'data': dataMap,
        'notification': notificationMap
      }
    };

    var response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/geetaxi-24ea3/messages:send'),
        headers: headerMap,
        body: jsonEncode(bodyMap));

    print(response.body);
  }
}
