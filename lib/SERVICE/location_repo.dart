import '../UI/model/location.dart';
import 'package:location/location.dart';

class LocationRepo {
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  // late DeviceLocation _currentLocation;
  Future<bool> checkLocationService() async {
    return (!await location.serviceEnabled()) ? false : true;
  }

  Future<void> checkLocationServiceIsEnabled() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  Future<void> getLocationPermission() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<DeviceLocation> getLocation() async {
    _locationData = await location.getLocation();
    return DeviceLocation(
      latitude: _locationData.latitude,
      longitude: _locationData.longitude,
      speed: _locationData.speed,
      time: _locationData.time,
    );
  }
}
