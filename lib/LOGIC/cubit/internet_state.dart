part of 'internet_cubit.dart';

abstract class InternetState {
  final bool conState;

  InternetState(this.conState);
}

class InternetLoading extends InternetState {
  InternetLoading(bool conState) : super(conState);
}

class InternetConnected extends InternetState {
  final ConnectionType connectionType;

  InternetConnected({required this.connectionType, required conState})
      : super(conState);
}

class InternetDisconnected extends InternetState {
  InternetDisconnected(bool conState) : super(conState);
}
