part of 'server_conn_cubit.dart';

abstract class ServerConnState extends Equatable {
  final bool isConnected;

  const ServerConnState(this.isConnected);
  @override
  List<Object> get props => [isConnected];
}

class ServerConnInitial extends ServerConnState {
  const ServerConnInitial(bool isConnected) : super(isConnected);
}

class ServerConnUpdated extends ServerConnState {
  ServerConnUpdated(bool isConnected) : super(isConnected) {
    isConnected = isConnected;
  }
}
