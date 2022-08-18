import 'dart:async';
import 'package:truckngo/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final StreamController<User> _streamController = StreamController<User>();
  Stream<User> get apiUser => _streamController.stream;

  // Future<dynamic> requestRide({
  //   required String userId,
  // }) {
  //   CollectionReference rides = FirebaseFirestore.instance.collection('Rides');
  //   rides.add({});
  // }
}
