import 'dart:async';

import 'package:location/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service.g.dart';

@Riverpod(keepAlive: true)
class LocationService extends _$LocationService {
  final Location _location = Location();

  @override
  Stream<LocationData?> build() {
    return getLocationData().asStream();
  }

  Future<LocationData?> getLocationData() async {
    if (await isEnabled() && await permissionGranted()) {
      _location.onLocationChanged.listen((currentLocation) {
        state = AsyncData(currentLocation);
      });
      final data = await _location.getLocation();
      return data;
    }

    return null;
  }

  Future<bool> isEnabled() async {
    bool _serviceEnabled;
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }
    return _serviceEnabled;
  }

  Future<bool> permissionGranted() async {
    PermissionStatus _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
}
