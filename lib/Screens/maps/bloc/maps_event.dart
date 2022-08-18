part of 'maps_bloc.dart';

abstract class MapsEvent extends Equatable {
  const MapsEvent();

  @override
  List<Object> get props => [];
}

class UpdatePickUpAddressEvent extends MapsEvent {
  final Address address;

  const UpdatePickUpAddressEvent(this.address);
  @override
  List<Object> get props => [address];
}

class UpdateDestinationAddressEvent extends MapsEvent {
  final Address address;

  const UpdateDestinationAddressEvent(this.address);
  @override
  List<Object> get props => [address];
}
