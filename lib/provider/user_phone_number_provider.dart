import 'package:flutter/material.dart';

class PhoneNumberProvider extends ChangeNotifier {
  String? _phoneNumber;

  PhoneNumberProvider(String? phoneNumber) {
    _phoneNumber = phoneNumber;
  }

  set setNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  String? get getPhoneNumber => _phoneNumber;
}
