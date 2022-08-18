library error_handler;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:truckngo/models/serializers/serializers.dart';

part 'error_handler.g.dart';

abstract class ErrorHandler
    implements Built<ErrorHandler, ErrorHandlerBuilder> {
  // fields go here
  bool? get error;

  String? get message;

  ErrorHandler._();

  factory ErrorHandler([Function(ErrorHandlerBuilder b) updates]) =
      _$ErrorHandler;

  String toJson() {
    return json
        .encode(serializers.serializeWith(ErrorHandler.serializer, this));
  }

  static ErrorHandler? fromJson(String jsonString) {
    return serializers.deserializeWith(
        ErrorHandler.serializer, json.decode(jsonString));
  }

  static Serializer<ErrorHandler> get serializer => _$errorHandlerSerializer;
}
