part of 'maps_bloc.dart';

class MapsState extends Equatable {
  const MapsState({this.pickUpAddress, this.destinationAddress});

  final Address? pickUpAddress;

  final Address? destinationAddress;
  
  @override
  List<Object?> get props => [pickUpAddress, destinationAddress];
}
