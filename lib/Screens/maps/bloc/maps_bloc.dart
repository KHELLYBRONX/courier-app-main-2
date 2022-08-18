import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/address.dart';

part 'maps_event.dart';
part 'maps_state.dart';

class MapsBloc extends Bloc<MapsEvent, MapsState> {
  MapsBloc() : super(const MapsState()) {
    on<UpdatePickUpAddressEvent>(updatePickupAddress);
    on<UpdateDestinationAddressEvent>(updateDestinationAddress);
  }

  void updatePickupAddress(
    UpdatePickUpAddressEvent event,
    Emitter<MapsState> emit,
  ) {
    emit(MapsState(pickUpAddress: event.address));
  }

  void updateDestinationAddress(
    UpdateDestinationAddressEvent event,
    Emitter<MapsState> emit,
  ) {
    emit(MapsState(destinationAddress: event.address));
  }
}
