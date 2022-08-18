library ride;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers/serializers.dart';

part 'ride.g.dart';

abstract class Ride implements Built<Ride, RideBuilder> {
  // fields go here

  Ride._();

  String? get id;

  String? get riderId;

  String? get driverId;

  String? get status;

  double? get pickUpLatitude;

  double? get pickUpLongitude;

  double? get destinationLatitude;

  double? get destinationLongitude;

  double? get price;

  String? get paymentMethod;

  String? get createdAt;

  factory Ride([Function(RideBuilder b) updates]) = _$Ride;

  String toJson() {
    return json.encode(serializers.serializeWith(Ride.serializer, this));
  }

  static Ride? fromJson(String jsonString) {
    return serializers.deserializeWith(
        Ride.serializer, json.decode(jsonString));
  }

  static Serializer<Ride> get serializer => _$rideSerializer;
}
