import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:location/location.dart';

part 'permissions_state.dart';

class PermissionsCubit extends Cubit<PermissionsState> {
  PermissionsCubit()
      : super(PermissionsState(
          isCameraPermissionGranted: false,
          isGPSPermissionGranted: false,
        )) {
    checkCameraPermission();
    checkLocationPermission();
  }

  Future<void> checkCameraPermission() async {
    // final serviceStatus = await Permission.camera.status;
    // final isCameraOn = serviceStatus == ServiceStatus.enabled;
    // if (!isCameraOn) {
    //   // emit(state.copyWith(isCameraPermissionGranted: true));

    //   print('Turn on camera services before requesting permission.');
    //   return;
    // }

    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      // print('Permission granted');
      emit(state.copyWith(isCameraPermissionGranted: true));
    } else if (status == PermissionStatus.denied) {
      //print('Permission denied. Show a dialog and again ask for the permission');
      emit(state.copyWith(isCameraPermissionGranted: false));
    } else if (status == PermissionStatus.permanentlyDenied) {
      // print('Take the user to the settings page.');
      await openAppSettings();
    }
  }

  Future<void> checkLocationPermission() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;
    if (!isGpsOn) {
      emit(state.copyWith(isGPSPermissionGranted: true));
      // print('Turn on location services before requesting permission.');
      return;
    }

    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      // print('Permission granted');
      emit(state.copyWith(isGPSPermissionGranted: true));
    } else if (status == PermissionStatus.denied) {
      //print('Permission denied. Show a dialog and again ask for the permission');
      emit(state.copyWith(isGPSPermissionGranted: false));
    } else if (status == PermissionStatus.permanentlyDenied) {
      // print('Take the user to the settings page.');
      await openAppSettings();
    }
  }

  bool isAllPermissionsGranted() =>
      (state.isCameraPermissionGranted && state.isGPSPermissionGranted)
          ? true
          : false;
}
