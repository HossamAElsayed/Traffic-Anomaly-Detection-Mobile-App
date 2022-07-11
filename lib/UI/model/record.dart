import 'location.dart';

class Record extends DeviceLocation {
  Record({
    required double? latitude,
    required double? longitude,
    required double? speed,
    required double? time,
    this.img,
    required this.dateTime,
    required this.rid,
    required this.state,
  }) : super(
          latitude: latitude,
          longitude: longitude,
          speed: speed,
          time: time,
        );
  final String rid;
  final String? img;
  final bool state;
  final DateTime dateTime;
}
