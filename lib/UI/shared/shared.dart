import 'package:flutter/material.dart';

void showASnackBar(
  context,
  String msg, {
  double fontSize = 14,
  Color color = Colors.white,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
          content: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: fontSize, color: color),
      )),
    );
}
