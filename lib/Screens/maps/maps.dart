import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:truckngo/models/directiondetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:truckngo/models/userCL.dart';
import 'package:truckngo/globalvariables.dart';
import 'package:truckngo/helpers/helpermethods.dart';
import 'package:truckngo/models/ride.dart';
import 'package:truckngo/rideVariables.dart';
import 'package:truckngo/Screens/searchpage.dart';
import 'package:truckngo/Screens/styles/styles.dart';
import 'package:truckngo/Screens/widgets/BrandDivider.dart';
import 'package:truckngo/brand_colors.dart';
import 'package:truckngo/Screens/widgets/ProgressDialog.dart';
import 'package:truckngo/Screens/widgets/TaxiButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/address.dart';
import '../../models/driver.dart';
import '../../services/auth_service.dart';
import '../../services/ride_service.dart';
import '../login/login.dart';
import '../widgets/NoDriverDialog.dart';
import 'bloc/maps_bloc.dart';

class MainPage extends StatefulWidget {
  static const String id = 'mainpage';
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  double searchSheetHeight = Platform.isIOS ? 300 : 275;
  double rideDetailsSheetHeight = 0; //(Platform.isAndroid) ? 235 : 260
  double requestingSheetHeight = 0; // (Platform.isAndroid) ? 195 :220
  double tripSheetHeight = 0; // (Platform.isAndroid) ? 275 :300

  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  double mapBottomPadding = 0;

  List<LatLng> polylineCoordinates = [];
  final Set<Polyline> _polylines = {};
  Set<Marker> _Markers = {};
  final Set<Circle> _Circles = {};

  BitmapDescriptor? nearbyIcon;

  var geoLocator = Geolocator();
  Position? currentPosition;
  DirectionDetails? tripDirectionDetails;

  String appState = 'NORMAL';

  Address? destinationAddress;

  bool drawerCanOpen = true;

  DatabaseReference? rideRef;

  List<Driver> availableDrivers = [];

  bool nearbyDriversKeysLoaded = false;

  bool isRequestingLocationDetails = false;

  void setupPositionLocator() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = CameraPosition(target: pos, zoom: 25);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
//
    String address =
        await HelperMethods.findCoordinateAddress(position, context);
// print(address);
    Future<Stream<Driver?>> driverStream = findDriversAvailble(
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude);
    driverStream.asStream().listen((event) {
      event.listen((event) {
        setState(() {
          availableDrivers.add(event!);
          updateDriversOnMap();
        });
      });
    });
  }

  void showDetailSheet({
    required BuildContext context,
    Address? pickUpAddress,
    Address? destinationAddress,
  }) async {
    await getDirection(
      context: context,
      pickUpAddress: pickUpAddress,
      destinationAddress: destinationAddress,
    );
    setState(() {
      searchSheetHeight = 0;
      rideDetailsSheetHeight = (Platform.isAndroid) ? 235 : 260;
      mapBottomPadding = (Platform.isAndroid) ? 240 : 230;
      drawerCanOpen = false;
    });
  }

  void showRequestingSheet({Address? pickUpAddress, String? driverId}) {
    setState(() {
      rideDetailsSheetHeight = 0;
      requestingSheetHeight = (Platform.isAndroid) ? 195 : 220;
      mapBottomPadding = (Platform.isAndroid) ? 200 : 190;
      drawerCanOpen = true;
    });
    Ride ride = Ride((b) => b
      ..riderId = AuthService.instance.currentUser?.uid
      ..driverId = availableDrivers[0].id
      ..pickUpLatitude = pickUpAddress?.latitude
      ..pickUpLongitude = pickUpAddress?.longitude
      ..destinationLatitude = destinationAddress?.latitude
      ..status = "waiting"
      ..price = HelperMethods.estimateFares(tripDirectionDetails!) * 6.5
      ..destinationLongitude = destinationAddress?.longitude);
    createRide(ride);
  }

  showTripSheet() {
    setState(() {
      requestingSheetHeight = 0;
      tripSheetHeight = (Platform.isAndroid) ? 275 : 300;
      mapBottomPadding = (Platform.isAndroid) ? 280 : 270;
    });
  }

  void createMarker() {
    if (nearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration,
              (Platform.isIOS)
                  ? 'images/car_ios.png'
                  : 'images/car_android.png')
          .then((icon) {
        nearbyIcon = icon;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    HelperMethods.getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    createMarker();
    Address? pickUpAddress =
        context.select((MapsBloc bloc) => bloc.state.pickUpAddress);
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawer: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            color: Colors.white,
            child: Drawer(
                child: ListView(
                    padding: const EdgeInsets.all(0),
                    children: <Widget>[
                  Container(
                    color: Colors.white,
                    height: 160,
                    child: DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'images/user_icon.png',
                            height: 60,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${FirebaseAuth.instance.currentUser?.displayName ?? FirebaseAuth.instance.currentUser?.email}',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'View Profile',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  BrandDivider(),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(Icons.card_giftcard),
                    title: Text(
                      'Free Rides',
                      style: kDrawerItemStyle,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.credit_card),
                    title: Text(
                      'Payments',
                      style: kDrawerItemStyle,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(
                      'Ride History',
                      style: kDrawerItemStyle,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.support_agent),
                    title: Text(
                      'Support',
                      style: kDrawerItemStyle,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: Text(
                      'About',
                      style: kDrawerItemStyle,
                    ),
                  ),
                  ListTile(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const LoginScreen()
                          ),
                          (route) => false,
                        );
                      },
                      leading: const Icon(Icons.logout),
                      title: Text('Logout', style: kDrawerItemStyle))
                ]))),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              padding: EdgeInsets.only(bottom: mapBottomPadding),
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: googlePlex,
              myLocationButtonEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              polylines: _polylines,
              markers: _Markers,
              circles: _Circles,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapController = controller;
                setState(() {
                  mapBottomPadding = (Platform.isAndroid) ? 280 : 270;
                });
                setupPositionLocator();
              },
            ),

            ///Menu button
            Positioned(
              top: 44,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  if (drawerCanOpen) {
                    scaffoldKey.currentState?.openDrawer();
                  } else {
                    resetApp();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: 0.5,
                        offset: Offset(.7, 0.7),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(
                      (drawerCanOpen) ? Icons.menu : Icons.arrow_back,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),

            ///searchSheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                vsync: this,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeIn,
                child: Container(
                  height: searchSheetHeight,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 18.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            'Nice to see you',
                            style: TextStyle(fontSize: 10),
                          ),
                          const Text(
                            'Where are you going?',
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'Brand-Bold'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              destinationAddress = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchPage(),
                                  ));
                              if (destinationAddress?.latitude != null) {
                                showDetailSheet(
                                    context: context,
                                    pickUpAddress:
                                        BlocProvider.of<MapsBloc>(context)
                                            .state
                                            .pickUpAddress!,
                                    destinationAddress: destinationAddress);
                              } else {
                                print('faileddd');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5.0,
                                      spreadRadius: 0.5,
                                      offset: Offset(
                                        0.7,
                                        0.7,
                                      ),
                                    )
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: const <Widget>[
                                    Icon(
                                      Icons.search,
                                      color: Colors.blueAccent,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Search Destination'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.home,
                                color: BrandColors.colorDimText,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text(
                                      // (Provider.of<AppData>(context)
                                      //             .pickupAddress !=
                                      //         null)
                                      //     ? Provider.of<AppData>(context)
                                      //         .pickupAddress
                                      //         .placeName
                                      //     :
                                      'Add Home'
                                      //  Provider.of<AppData>(context).pickupAddress.placeName
                                      ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text('Your residential address',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: BrandColors.colorDimText)),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          BrandDivider(),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.work_outline,
                                color: BrandColors.colorDimText,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text('Add work'),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text('Your office address',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: BrandColors.colorDimText)),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            ///RideDetails Sheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                vsync: this,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7))
                      ]),
                  height: rideDetailsSheetHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          color: BrandColors.colorAccent1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  'images/truckimg.png',
                                  height: 70,
                                  width: 70,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text('Truck',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Brand-Bold')),
                                    Text(
                                      (tripDirectionDetails != null)
                                          ? tripDirectionDetails!.distanceText!
                                          : '',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: BrandColors.colorTextLight),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                    (tripDirectionDetails != null)
                                        ? '¢${HelperMethods.estimateFares(tripDirectionDetails!) * 6.5.ceil()}'
                                        : '',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Brand-Bold')),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: const <Widget>[
                              Icon(
                                FontAwesomeIcons.moneyBillAlt,
                                size: 18,
                                color: BrandColors.colorTextLight,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text('Cash'),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: BrandColors.colorTextLight,
                                size: 16,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TaxiButton(
                            title: 'REQUEST TRUCK',
                            color: BrandColors.colorGreen,
                            onPressed: () {
                              setState(() {
                                appState = 'REQUESTING';
                              });
                              showRequestingSheet(pickUpAddress: pickUpAddress);

                              // availableDrivers = FireHelper.nearbyDriverList;

                              // findDriver();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            ///Request Sheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                vsync: this,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeIn,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15.0,
                        spreadRadius: 0.5,
                        offset: Offset(
                          0.7,
                          0.7,
                        ),
                      ),
                    ],
                  ),
                  height: requestingSheetHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextLiquidFill(
                            text: 'Requesting a Ride...',
                            waveColor: BrandColors.colorTextSemiLight,
                            boxBackgroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 22.0,
                              fontFamily: 'Brand-Bold',
                              fontWeight: FontWeight.bold,
                            ),
                            boxHeight: 40.0,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            cancelRequest();
                            resetApp();
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  width: 1.0,
                                  color: BrandColors.colorLightGrayFair),
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 25,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Cancel Ride',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),

            ///Trip Sheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                vsync: this,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeIn,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15.0,
                        spreadRadius: 0.5,
                        offset: Offset(
                          0.7,
                          0.7,
                        ),
                      ),
                    ],
                  ),
                  height: tripSheetHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tripStatusDisplay,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'Brand-Bold'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BrandDivider(),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          driverCarDetails,
                          style: const TextStyle(
                              color: BrandColors.colorTextLight),
                        ),
                        Text(
                          driverFullName,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BrandDivider(),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular((25))),
                                    border: Border.all(
                                        width: 1.0,
                                        color: BrandColors.colorTextLight),
                                  ),
                                  child: const Icon(Icons.call),
                                ),
                                const SizedBox(height: 10),
                                const Text('Call'),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular((25))),
                                    border: Border.all(
                                        width: 1.0,
                                        color: BrandColors.colorTextLight),
                                  ),
                                  child: const Icon(Icons.list),
                                ),
                                const SizedBox(height: 10),
                                const Text('Details'),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular((25))),
                                    border: Border.all(
                                        width: 1.0,
                                        color: BrandColors.colorTextLight),
                                  ),
                                  child: const Icon(Icons.clear),
                                ),
                                const SizedBox(height: 10),
                                const Text('Cancel'),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getDirection({
    required BuildContext context,
    Address? pickUpAddress,
    Address? destinationAddress,
  }) async {
    var pickup = pickUpAddress;
    var destination = destinationAddress;
    var pickLatLng = LatLng(pickup!.latitude!, pickup.longitude!);
    var destinationLatLng =
        LatLng(destination!.latitude!, destination.longitude!);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const ProgressDialog(
              status: 'Please wait....',
            ));
    var thisDetails =
        await HelperMethods.getDirectionDetails(pickLatLng, destinationLatLng);

    setState(() {
      tripDirectionDetails = thisDetails!;
    });
    Navigator.pop(context);
    PolylinePoints polylinePoints = PolylinePoints();

    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails!.encodedPoints!);
    polylineCoordinates.clear();
    if (results.isNotEmpty) {
      //loop thru all PointLatLng points and convert them
      // to a  list of LatLng, required by the polyline
      // print(
      //     'result is not empty oooooooooooooooooooooooooooooooooooooooooooooooooo');
      for (var point in results) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _polylines.clear();
    setState(() {
      Polyline polyline = Polyline(
          polylineId: const PolylineId('polyid'),
          color: const Color.fromARGB(255, 95, 109, 237),
          points: polylineCoordinates,
          jointType: JointType.round,
          width: 4,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);
      _polylines.add(polyline);
    });

    //make poly line fit into map
    LatLngBounds bounds;
    if (pickLatLng.latitude > destinationLatLng.latitude &&
        pickLatLng.longitude > destinationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickLatLng);
    } else if (pickLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, pickLatLng.longitude));
    } else if (pickLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, pickLatLng.longitude),
          northeast: LatLng(pickLatLng.latitude, destinationLatLng.longitude));
    } else {
      bounds =
          LatLngBounds(southwest: pickLatLng, northeast: destinationLatLng);
    }
    //to make use of the bounds
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
    Marker pickupMarker = Marker(
      markerId: const MarkerId('pickup'),
      position: pickLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: pickup.placeName, snippet: 'My Location'),
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: destination.placeName, snippet: 'Destination'),
    );
    setState(() {
      _Markers.add(pickupMarker);
      _Markers.add(destinationMarker);
    });
    Circle pickupCircle = Circle(
      circleId: const CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickLatLng,
      fillColor: BrandColors.colorGreen,
    );
    Circle destinationCircle = Circle(
      circleId: const CircleId('destination'),
      strokeColor: BrandColors.colorAccentPurple,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: BrandColors.colorAccentPurple,
    );
    setState(() {
      _Circles.add(pickupCircle);
      _Circles.add(destinationCircle);
    });
  }

  void updateDriversOnMap() {
    setState(() {
      _Markers.clear();
    });
    Set<Marker> tempMarkers = <Marker>{};
    for (Driver driver in availableDrivers) {
      LatLng driverPosition = LatLng(driver.latitude!, driver.longitude!);
      Marker thisMarker = Marker(
        markerId: MarkerId('driver${driver.id}'),
        position: driverPosition,
        icon: nearbyIcon!,
        rotation: HelperMethods.generateRandomNumber(360),
      );
      tempMarkers.add(thisMarker);
    }
    setState(() {
      _Markers = tempMarkers;
    });
  }

  //   void createRideRequest() {
  //     rideRef = FirebaseDatabase.instance.reference().child('rideRequest').push();

  //     // rideRef;
  //     var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
  //     var destination =
  //         Provider.of<AppData>(context, listen: false).destinationAddress;

  //     Map pickupMap = {
  //       'latitude': pickup.latitude.toString(),
  //       'longitude': pickup.longitude.toString(),
  //     };

  //     Map destinationMap = {
  //       'latitude': destination.latitude.toString(),
  //       'longitude': destination.longitude.toString(),
  //     };

  //     Map rideMap = <String, Object>{
  //       'created_at': DateTime.now().toString(),
  //       'rider_name': currentUserInfo.fullName!,
  //       'rider_phone': currentUserInfo.phone!,
  //       'pickup_address': pickup.placeName!,
  //       'destination_address': destination.placeName!,
  //       'location': pickupMap,
  //       'destination': destinationMap,
  //       'payment_method': 'card',
  //       'driver_id': 'waiting',
  //     };

  //     rideRef?.set(rideMap);

  //     rideSubscription = rideRef!.onValue.listen((event) async {
  //       //check for null snapshot

  //       if (event.snapshot.value == null) {
  //         return;
  //       }
  // //get car details
  //       if (event.snapshot.value['car_details'] != null) {
  //         setState(() {
  //           driverCarDetails = event.snapshot.value['car_details'].toString();
  //         });
  //       }

  //       //get driver name
  //       if (event.snapshot.value['driver_name'] != null) {
  //         setState(() {
  //           driverFullName = event.snapshot.value['driver_name'].toString();
  //         });
  //       }

  //       //get driver phone no
  //       if (event.snapshot.value['driver_phone'] != null) {
  //         setState(() {
  //           driverPhoneNumber = event.snapshot.value['driver_phone'].toString();
  //         });
  //       }

  //       // get and use driver location updates
  //       if (event.snapshot.value['driver_location'] != null) {
  //         double driverLat = double.parse(
  //             event.snapshot.value['driver_location']['latitude'].toString());
  //         double driverLng = double.parse(
  //             event.snapshot.value['driver_location']['longitude'].toString());

  //         LatLng driverLocation = LatLng(driverLat, driverLng);

  //         if (status == 'accepted') {
  //           updateToPickup(driverLocation);
  //         } else if (status == 'ontrip') {
  //           updateToDestination(driverLocation);
  //         } else if (status == 'arrived') {
  //           setState(() {
  //             tripStatusDisplay = 'Driver has arrived';
  //           });
  //         }
  //       }

  //       if (event.snapshot.value['status'] != null) {
  //         status = event.snapshot.value['status'].toString();
  //       }
  //       if (status == 'accepted') {
  //         showTripSheet();
  //         Geofire.stopListener();
  //         removeGeofireMarkers();
  //       }

  //       if (status == 'ended') {
  //         if (event.snapshot.value['fares'] != null) {
  //           int fares = int.parse(event.snapshot.value['fares'].toString());

  //           var response = await showDialog(
  //             context: context,
  //             barrierDismissible: false,
  //             builder: (BuildContext context) => CollectPayment(
  //               paymentMethod: 'cash',
  //               fares: fares,
  //             ),
  //           );
  //           if (response == 'close') {
  //             rideRef?.onDisconnect();
  //             rideRef = null;
  //             rideSubscription?.cancel();
  //             rideSubscription = null;
  //             resetApp();
  //           }
  //         }
  //       }
  //     });
  //   }

  void removeGeofireMarkers() {
    setState(() {
      _Markers.removeWhere((m) => m.markerId.value.contains('driver'));
    });
  }

  void updateToPickup(LatLng driverLocation) async {
    if (!isRequestingLocationDetails) {
      isRequestingLocationDetails = true;
      var positionLatLng =
          LatLng(currentPosition!.latitude, currentPosition!.longitude);

      var thisDetails = await HelperMethods.getDirectionDetails(
          driverLocation, positionLatLng);

      if (thisDetails == null) {
        return;
      }

      setState(() {
        tripStatusDisplay = 'Driver is Arriving ~ ${thisDetails.durationText}';
      });

      isRequestingLocationDetails = false;
    }
  }

  void updateToDestination(LatLng driverLocation) async {
    if (!isRequestingLocationDetails) {
      isRequestingLocationDetails = true;

      var destination =
          BlocProvider.of<MapsBloc>(context).state.destinationAddress;

      var destinationLatLng =
          LatLng(destination!.latitude!, destination.longitude!);

      var thisDetails = await HelperMethods.getDirectionDetails(
          driverLocation, destinationLatLng);

      if (thisDetails == null) {
        return;
      }

      setState(() {
        tripStatusDisplay =
            'Driving to Destination ~ ${thisDetails.durationText}';
      });

      isRequestingLocationDetails = false;
    }
  }

  void cancelRequest() {
    rideRef?.remove();

    setState(() {
      appState = 'NORMAL';
    });
  }

  resetApp() {
    setState(() {
      polylineCoordinates.clear();
      _polylines.clear();
      _Markers.clear();
      _Circles.clear();
      rideDetailsSheetHeight = 0;
      requestingSheetHeight = 0;
      tripSheetHeight = 0;
      searchSheetHeight = (Platform.isAndroid) ? 275 : 300;
      mapBottomPadding = (Platform.isAndroid) ? 280 : 270;
      drawerCanOpen = true;

      status = '';
      driverFullName = '';
      driverPhoneNumber = '';
      driverCarDetails = '';
      tripStatusDisplay = 'Driver is Arriving';
    });
    setupPositionLocator();
  }

  void noDriverFound() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => NoDriverDialog());
  }

  void findDriver() {
    if (availableDrivers.isEmpty) {
      cancelRequest();
      resetApp();
      noDriverFound();
      return;
    }
    var driver = availableDrivers[0];

    // notifyDriver(driver);

    availableDrivers.removeAt(0);
    // print(driver.key);
  }

//   void notifyDriver(NearbyDriver driver) {
//     DatabaseReference driverTripRef = FirebaseDatabase.instance
//         .reference()
//         .child('drivers/${driver.key}/newtrip');

//     driverTripRef.set(rideRef!.key);

// //get and notify driver using token

//     DatabaseReference tokenRef =
//         FirebaseDatabase.instance.ref('drivers/${driver.key}/token');
//     tokenRef.once().then((snapshot) {
//       if (snapshot.value != null) {
//         String token = snapshot.value.toString();
//         //send notifications to driver

//         HelperMethods.sendNotifications(token, context, rideRef!.key);
//       } else {
//         return;
//       }
//       const oneSecTick = Duration(seconds: 1);
//       var timer = Timer.periodic(oneSecTick, (timer) {
//         //stop timer when ride request is cancelled
//         if (appState != 'REQUESTING') {
//           driverTripRef.set('cancelled');
//           driverTripRef.onDisconnect();
//           timer.cancel();
//           driverRequestTimeout = 30;
//         }
//         driverRequestTimeout--;

//         //a value event listener for driver accepting trip request
//         driverTripRef.onValue.listen((event) {
//           //confirms that driver has clicked accepted for the new trip request
//           if (event.snapshot.value.toString() == 'accepted') {
//             driverTripRef.onDisconnect();
//             timer.cancel();
//             driverRequestTimeout = 30;
//           }
//         });

//         if (driverRequestTimeout == 0) {
//           // informs driver that ride has timed out
//           driverTripRef.set('timeout');
//           driverTripRef.onDisconnect();
//           driverRequestTimeout = 30;
//           timer.cancel();

//           //select the next closest driver
//           findDriver();
//         }
//       });
//     });
//   }
}
