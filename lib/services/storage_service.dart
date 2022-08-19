import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  SharedPreferences? _prefs;

  static StorageService instance = StorageService._();

  StorageService._() {
    init();
  }

  void init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<String?> getNumber() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs?.getString('phoneNumber');
  }

  Future<bool?> saveNumber(String phoneNumber) async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs?.setString('phoneNumber', phoneNumber);
  }

  Future<bool?> deleteNumber() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs?.clear();
  }
}
