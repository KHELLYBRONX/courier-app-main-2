import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreService {
  late final FirebaseFirestore _firestore;

  static CloudFirestoreService instance = CloudFirestoreService._();

  CloudFirestoreService._() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> saveUsersPhoneNumber(String uid, String phoneNumber) async {
    try {
      return _firestore
          .collection('UserData')
          .doc(uid)
          .set({'phoneNumber': phoneNumber});
    } catch (_) {}
  }

  Future<String?> getNumber(String uid) async {
    try {
      var doc = await _firestore
          .collection('UserData')
          .doc(uid)
          .withConverter<String>(
              fromFirestore: ((snapshot, options) =>
                  snapshot.data()?['phoneNumber']),
              toFirestore: (val, _) => {'phoneNumber': val})
          .get();
      return doc.data();
    } catch (_) {}
  }
}
