import 'dart:async';
import 'dart:io';

import 'package:adtracker/UI/shared/constants.dart';

import '../../UI/shared/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'server_conn_state.dart';

class ServerConnCubit extends Cubit<ServerConnState> {
  ServerConnCubit() : super(const ServerConnInitial(false)) {
    connectionStateStream().listen((event) {
      if (event == ConnectionState.connected) {
        emit(ServerConnUpdated(true));
      } else if (event == ConnectionState.disconnected) {
        emit(ServerConnUpdated(false));
      } else {
        emit(ServerConnUpdated(false));
      }
    });
  }
  Stream<ConnectionState> connectionStateStream() async* {
    while (true) {
      var url = Uri.parse('http://$mainEndPoint/config.php');
      try {
        http.Response response =
            await http.get(url).timeout(const Duration(seconds: 5));
        if (response.statusCode == 200 && response.body.trim().isEmpty) {
          yield ConnectionState.connected;
        } else {
          yield ConnectionState.disconnected;
        }
      } on TimeoutException catch (e) {
        yield ConnectionState.timeoutError;
        print('Timeout Error: $e');
      } on SocketException catch (e) {
        yield ConnectionState.socketError;
        print('Socket Error: $e');
      } on Error catch (e) {
        yield ConnectionState.unkownError;
        print('General Error: $e');
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
