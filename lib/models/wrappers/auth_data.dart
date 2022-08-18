library auth_data;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:truckngo/models/models.dart';
import 'package:truckngo/models/serializers/serializers.dart';

part 'auth_data.g.dart';

abstract class AuthData implements Built<AuthData, AuthDataBuilder> {
  // fields go here
  User? get user;

  String? get accessToken;

  String? get expiresIn;

  AuthData._();

  factory AuthData([
    Function(AuthDataBuilder b) updates,
  ]) = _$AuthData;

  String toJson() {
    return json.encode(serializers.serializeWith(AuthData.serializer, this));
  }

  static AuthData? fromJson(String jsonString) {
    return serializers.deserializeWith(
        AuthData.serializer, json.decode(jsonString));
  }

  static Serializer<AuthData> get serializer => _$authDataSerializer;
}
