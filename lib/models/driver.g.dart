// GENERATED CODE - DO NOT MODIFY BY HAND

part of driver;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Driver> _$driverSerializer = new _$DriverSerializer();

class _$DriverSerializer implements StructuredSerializer<Driver> {
  @override
  final Iterable<Type> types = const [Driver, _$Driver];
  @override
  final String wireName = 'Driver';

  @override
  Iterable<Object?> serialize(Serializers serializers, Driver object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.longitude;
    if (value != null) {
      result
        ..add('longitude')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.latitude;
    if (value != null) {
      result
        ..add('latitude')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.driverImage;
    if (value != null) {
      result
        ..add('driverImage')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.carImage;
    if (value != null) {
      result
        ..add('carImage')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.truckType;
    if (value != null) {
      result
        ..add('truckType')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.numberPlate;
    if (value != null) {
      result
        ..add('numberPlate')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Driver deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DriverBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'longitude':
          result.longitude = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'latitude':
          result.latitude = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'driverImage':
          result.driverImage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'carImage':
          result.carImage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'truckType':
          result.truckType = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'numberPlate':
          result.numberPlate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$Driver extends Driver {
  @override
  final String id;
  @override
  final String? name;
  @override
  final double? longitude;
  @override
  final double? latitude;
  @override
  final String? driverImage;
  @override
  final String? carImage;
  @override
  final int? truckType;
  @override
  final String? numberPlate;

  factory _$Driver([void Function(DriverBuilder)? updates]) =>
      (new DriverBuilder()..update(updates)).build();

  _$Driver._(
      {required this.id,
      this.name,
      this.longitude,
      this.latitude,
      this.driverImage,
      this.carImage,
      this.truckType,
      this.numberPlate})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'Driver', 'id');
  }

  @override
  Driver rebuild(void Function(DriverBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DriverBuilder toBuilder() => new DriverBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Driver &&
        id == other.id &&
        name == other.name &&
        longitude == other.longitude &&
        latitude == other.latitude &&
        driverImage == other.driverImage &&
        carImage == other.carImage &&
        truckType == other.truckType &&
        numberPlate == other.numberPlate;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, id.hashCode), name.hashCode),
                            longitude.hashCode),
                        latitude.hashCode),
                    driverImage.hashCode),
                carImage.hashCode),
            truckType.hashCode),
        numberPlate.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Driver')
          ..add('id', id)
          ..add('name', name)
          ..add('longitude', longitude)
          ..add('latitude', latitude)
          ..add('driverImage', driverImage)
          ..add('carImage', carImage)
          ..add('truckType', truckType)
          ..add('numberPlate', numberPlate))
        .toString();
  }
}

class DriverBuilder implements Builder<Driver, DriverBuilder> {
  _$Driver? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  String? _driverImage;
  String? get driverImage => _$this._driverImage;
  set driverImage(String? driverImage) => _$this._driverImage = driverImage;

  String? _carImage;
  String? get carImage => _$this._carImage;
  set carImage(String? carImage) => _$this._carImage = carImage;

  int? _truckType;
  int? get truckType => _$this._truckType;
  set truckType(int? truckType) => _$this._truckType = truckType;

  String? _numberPlate;
  String? get numberPlate => _$this._numberPlate;
  set numberPlate(String? numberPlate) => _$this._numberPlate = numberPlate;

  DriverBuilder();

  DriverBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _longitude = $v.longitude;
      _latitude = $v.latitude;
      _driverImage = $v.driverImage;
      _carImage = $v.carImage;
      _truckType = $v.truckType;
      _numberPlate = $v.numberPlate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Driver other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Driver;
  }

  @override
  void update(void Function(DriverBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Driver build() {
    final _$result = _$v ??
        new _$Driver._(
            id: BuiltValueNullFieldError.checkNotNull(id, 'Driver', 'id'),
            name: name,
            longitude: longitude,
            latitude: latitude,
            driverImage: driverImage,
            carImage: carImage,
            truckType: truckType,
            numberPlate: numberPlate);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
