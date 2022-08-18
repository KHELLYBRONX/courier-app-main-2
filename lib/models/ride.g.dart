// GENERATED CODE - DO NOT MODIFY BY HAND

part of ride;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Ride> _$rideSerializer = new _$RideSerializer();

class _$RideSerializer implements StructuredSerializer<Ride> {
  @override
  final Iterable<Type> types = const [Ride, _$Ride];
  @override
  final String wireName = 'Ride';

  @override
  Iterable<Object?> serialize(Serializers serializers, Ride object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.riderId;
    if (value != null) {
      result
        ..add('riderId')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.driverId;
    if (value != null) {
      result
        ..add('driverId')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.status;
    if (value != null) {
      result
        ..add('status')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.pickUpLatitude;
    if (value != null) {
      result
        ..add('pickUpLatitude')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.pickUpLongitude;
    if (value != null) {
      result
        ..add('pickUpLongitude')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.destinationLatitude;
    if (value != null) {
      result
        ..add('destinationLatitude')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.destinationLongitude;
    if (value != null) {
      result
        ..add('destinationLongitude')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.price;
    if (value != null) {
      result
        ..add('price')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.paymentMethod;
    if (value != null) {
      result
        ..add('paymentMethod')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.createdAt;
    if (value != null) {
      result
        ..add('createdAt')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Ride deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RideBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'riderId':
          result.riderId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'driverId':
          result.driverId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'pickUpLatitude':
          result.pickUpLatitude = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'pickUpLongitude':
          result.pickUpLongitude = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'destinationLatitude':
          result.destinationLatitude = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'destinationLongitude':
          result.destinationLongitude = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'price':
          result.price = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'paymentMethod':
          result.paymentMethod = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$Ride extends Ride {
  @override
  final String? id;
  @override
  final String? riderId;
  @override
  final String? driverId;
  @override
  final String? status;
  @override
  final double? pickUpLatitude;
  @override
  final double? pickUpLongitude;
  @override
  final double? destinationLatitude;
  @override
  final double? destinationLongitude;
  @override
  final double? price;
  @override
  final String? paymentMethod;
  @override
  final String? createdAt;

  factory _$Ride([void Function(RideBuilder)? updates]) =>
      (new RideBuilder()..update(updates)).build();

  _$Ride._(
      {this.id,
      this.riderId,
      this.driverId,
      this.status,
      this.pickUpLatitude,
      this.pickUpLongitude,
      this.destinationLatitude,
      this.destinationLongitude,
      this.price,
      this.paymentMethod,
      this.createdAt})
      : super._();

  @override
  Ride rebuild(void Function(RideBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RideBuilder toBuilder() => new RideBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Ride &&
        id == other.id &&
        riderId == other.riderId &&
        driverId == other.driverId &&
        status == other.status &&
        pickUpLatitude == other.pickUpLatitude &&
        pickUpLongitude == other.pickUpLongitude &&
        destinationLatitude == other.destinationLatitude &&
        destinationLongitude == other.destinationLongitude &&
        price == other.price &&
        paymentMethod == other.paymentMethod &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc($jc(0, id.hashCode),
                                            riderId.hashCode),
                                        driverId.hashCode),
                                    status.hashCode),
                                pickUpLatitude.hashCode),
                            pickUpLongitude.hashCode),
                        destinationLatitude.hashCode),
                    destinationLongitude.hashCode),
                price.hashCode),
            paymentMethod.hashCode),
        createdAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Ride')
          ..add('id', id)
          ..add('riderId', riderId)
          ..add('driverId', driverId)
          ..add('status', status)
          ..add('pickUpLatitude', pickUpLatitude)
          ..add('pickUpLongitude', pickUpLongitude)
          ..add('destinationLatitude', destinationLatitude)
          ..add('destinationLongitude', destinationLongitude)
          ..add('price', price)
          ..add('paymentMethod', paymentMethod)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class RideBuilder implements Builder<Ride, RideBuilder> {
  _$Ride? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _riderId;
  String? get riderId => _$this._riderId;
  set riderId(String? riderId) => _$this._riderId = riderId;

  String? _driverId;
  String? get driverId => _$this._driverId;
  set driverId(String? driverId) => _$this._driverId = driverId;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  double? _pickUpLatitude;
  double? get pickUpLatitude => _$this._pickUpLatitude;
  set pickUpLatitude(double? pickUpLatitude) =>
      _$this._pickUpLatitude = pickUpLatitude;

  double? _pickUpLongitude;
  double? get pickUpLongitude => _$this._pickUpLongitude;
  set pickUpLongitude(double? pickUpLongitude) =>
      _$this._pickUpLongitude = pickUpLongitude;

  double? _destinationLatitude;
  double? get destinationLatitude => _$this._destinationLatitude;
  set destinationLatitude(double? destinationLatitude) =>
      _$this._destinationLatitude = destinationLatitude;

  double? _destinationLongitude;
  double? get destinationLongitude => _$this._destinationLongitude;
  set destinationLongitude(double? destinationLongitude) =>
      _$this._destinationLongitude = destinationLongitude;

  double? _price;
  double? get price => _$this._price;
  set price(double? price) => _$this._price = price;

  String? _paymentMethod;
  String? get paymentMethod => _$this._paymentMethod;
  set paymentMethod(String? paymentMethod) =>
      _$this._paymentMethod = paymentMethod;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  RideBuilder();

  RideBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _riderId = $v.riderId;
      _driverId = $v.driverId;
      _status = $v.status;
      _pickUpLatitude = $v.pickUpLatitude;
      _pickUpLongitude = $v.pickUpLongitude;
      _destinationLatitude = $v.destinationLatitude;
      _destinationLongitude = $v.destinationLongitude;
      _price = $v.price;
      _paymentMethod = $v.paymentMethod;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Ride other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Ride;
  }

  @override
  void update(void Function(RideBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Ride build() {
    final _$result = _$v ??
        new _$Ride._(
            id: id,
            riderId: riderId,
            driverId: driverId,
            status: status,
            pickUpLatitude: pickUpLatitude,
            pickUpLongitude: pickUpLongitude,
            destinationLatitude: destinationLatitude,
            destinationLongitude: destinationLongitude,
            price: price,
            paymentMethod: paymentMethod,
            createdAt: createdAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
