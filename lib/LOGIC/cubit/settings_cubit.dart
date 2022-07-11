import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({var box})
      : super(
          SettingsState(
            box.get('duration', defaultValue: 10),
            box.get('isOffline', defaultValue: false),
            false,
          ),
        ) {
    b = box;
  }
  late var b;

  set setDuration(int value) {
    b.put('duration', value);
    emit(state.copyWith(duration: value));
  }

  set setIsOfflineMode(bool value) {
    b.put('isOffline', value);
    emit(state.copyWith(isOffline: value));
  }

  set setIsSync(bool value) {
    // b.put('isOffline', value);
    emit(state.copyWith(isSync: value));
  }

  get getDuration => state.duration;
  get getIsOfflineModeOn => state.isOffline;
  get getIsSync => state.isSync;
}
