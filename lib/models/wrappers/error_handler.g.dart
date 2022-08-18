// GENERATED CODE - DO NOT MODIFY BY HAND

part of error_handler;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ErrorHandler> _$errorHandlerSerializer =
    new _$ErrorHandlerSerializer();

class _$ErrorHandlerSerializer implements StructuredSerializer<ErrorHandler> {
  @override
  final Iterable<Type> types = const [ErrorHandler, _$ErrorHandler];
  @override
  final String wireName = 'ErrorHandler';

  @override
  Iterable<Object?> serialize(Serializers serializers, ErrorHandler object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.error;
    if (value != null) {
      result
        ..add('error')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.message;
    if (value != null) {
      result
        ..add('message')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  ErrorHandler deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ErrorHandlerBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'error':
          result.error = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$ErrorHandler extends ErrorHandler {
  @override
  final bool? error;
  @override
  final String? message;

  factory _$ErrorHandler([void Function(ErrorHandlerBuilder)? updates]) =>
      (new ErrorHandlerBuilder()..update(updates)).build();

  _$ErrorHandler._({this.error, this.message}) : super._();

  @override
  ErrorHandler rebuild(void Function(ErrorHandlerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ErrorHandlerBuilder toBuilder() => new ErrorHandlerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ErrorHandler &&
        error == other.error &&
        message == other.message;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, error.hashCode), message.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ErrorHandler')
          ..add('error', error)
          ..add('message', message))
        .toString();
  }
}

class ErrorHandlerBuilder
    implements Builder<ErrorHandler, ErrorHandlerBuilder> {
  _$ErrorHandler? _$v;

  bool? _error;
  bool? get error => _$this._error;
  set error(bool? error) => _$this._error = error;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ErrorHandlerBuilder();

  ErrorHandlerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _error = $v.error;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ErrorHandler other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ErrorHandler;
  }

  @override
  void update(void Function(ErrorHandlerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ErrorHandler build() {
    final _$result =
        _$v ?? new _$ErrorHandler._(error: error, message: message);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
