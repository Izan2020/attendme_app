import 'package:attendme_app/common/location.dart';
import 'package:attendme_app/presentation/bloc/location/location_event.dart';
import 'package:attendme_app/presentation/bloc/location/location_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationState()) {
    on<OnGetCurrentLocation>((event, emit) async {
      final hasPermission = await handleLocationPermission();
      if (!hasPermission) return;
      final newPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      emit(LocationState(position: newPosition));
    });
  }
}
