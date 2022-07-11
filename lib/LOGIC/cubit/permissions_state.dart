part of 'permissions_cubit.dart';

// ignore: must_be_immutable
class PermissionsState extends Equatable {
  bool isCameraPermissionGranted;
  bool isGPSPermissionGranted;
  PermissionsState({
    this.isCameraPermissionGranted = false,
    this.isGPSPermissionGranted = false,
  });

  @override
  List<Object> get props => [isCameraPermissionGranted, isGPSPermissionGranted];

  PermissionsState copyWith({
    bool? isCameraPermissionGranted,
    bool? isGPSPermissionGranted,
  }) {
    return PermissionsState(
      isCameraPermissionGranted:
          isCameraPermissionGranted ?? this.isCameraPermissionGranted,
      isGPSPermissionGranted:
          isGPSPermissionGranted ?? this.isGPSPermissionGranted,
    );
  }
}
