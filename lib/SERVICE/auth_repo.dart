import 'package:adtracker/UI/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthRepo {
  // static const mainEndPoint = '40.77.47.208';

  Future<String> loginWithNameAndPassword(String name, String password) async {
    late String state;
    var url = Uri.parse('http://$mainEndPoint/log_in.php');
    await http.post(url, body: {
      "first_name": name,
      "password": password,
    }).then((response) {
      if (response.statusCode == 200) {
        state = response.body.trim();
      }
    }).catchError((error) {
      debugPrint('Response error: $error');
    });
    return state;
  }

  Future<void> logOut() async {}
}
