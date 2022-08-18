// GENERATED CODE - DO NOT MODIFY BY HAND

part of auth_data;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AuthData> _$authDataSerializer = new _$AuthDataSerializer();

class _$AuthDataSerializer implements StructuredSerializer<AuthData> {
  @override
  final Iterable<Type> types = const [AuthData, _$AuthData];
  @override
  final String wireName = 'AuthData';

  @override
  Iterable<Object?> serialize(Serializers serializers, AuthData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.user;
    if (value != null) {
      result
        ..add('user')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(User)));
    }
    value = object.accessToken;
    if (value != null) {
      result
        ..add('accessToken')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.expiresIn;
    if (value != null) {
      result
        ..add('expiresIn')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  AuthData deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AuthDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'user':
          result.user.replace(serializers.deserialize(value,
              specifiedType: const FullType(User))! as User);
          break;
        case 'accessToken':
          result.accessToken = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'expiresIn':
          result.expiresIn = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$AuthData extends AuthData {
  @override
  final User? user;
  @override
  final String? accessToken;
  @override
  final String? expiresIn;

  factory _$AuthData([void Function(AuthDataBuilder)? updates]) =>
      (new AuthDataBuilder()..update(updates)).build();

  _$AuthData._({this.user, this.accessToken, this.expiresIn}) : super._();

  @override
  AuthData rebuild(void Function(AuthDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthDataBuilder toBuilder() => new AuthDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthData &&
        user == other.user &&
        accessToken == other.accessToken &&
        expiresIn == other.expiresIn;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc(0, user.hashCode), accessToken.hashCode), expiresIn.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AuthData')
          ..add('user', user)
          ..add('accessToken', accessToken)
          ..add('expiresIn', expiresIn))
        .toString();
  }
}

class AuthDataBuilder implements Builder<AuthData, AuthDataBuilder> {
  _$AuthData? _$v;

  UserBuilder? _user;
  UserBuilder get user => _$this._user ??= new UserBuilder();
  set user(UserBuilder? user) => _$this._user = user;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  String? _expiresIn;
  String? get expiresIn => _$this._expiresIn;
  set expiresIn(String? expiresIn) => _$this._expiresIn = expiresIn;

  AuthDataBuilder();

  AuthDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _user = $v.user?.toBuilder();
      _accessToken = $v.accessToken;
      _expiresIn = $v.expiresIn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuthData;
  }

  @override
  void update(void Function(AuthDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AuthData build() {
    _$AuthData _$result;
    try {
      _$result = _$v ??
          new _$AuthData._(
              user: _user?.build(),
              accessToken: accessToken,
              expiresIn: expiresIn);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'AuthData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
