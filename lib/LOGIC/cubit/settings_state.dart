part of 'settings_cubit.dart';

// ignore: must_be_immutable
class SettingsState extends Equatable {
  SettingsState(this.duration, this.isOffline, this.isSync);
  int duration;
  bool isOffline;
  bool isSync;
  @override
  List<Object> get props => [duration, isOffline, isSync];

  SettingsState copyWith({
    int? duration,
    bool? isOffline,
    bool? isSync,
  }) {
    return SettingsState(
      duration ?? this.duration,
      isOffline ?? this.isOffline,
      isSync ?? this.isSync,
    );
  }
}
