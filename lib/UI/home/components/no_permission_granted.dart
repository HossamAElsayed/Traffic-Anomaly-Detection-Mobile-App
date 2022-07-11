import 'package:flutter/material.dart';

class NoPermissionsGranted extends StatefulWidget {
  const NoPermissionsGranted({Key? key}) : super(key: key);

  @override
  _NoPermissionsGrantedState createState() => _NoPermissionsGrantedState();
}

class _NoPermissionsGrantedState extends State<NoPermissionsGranted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Image.asset('assets/images/user_permission.png')),
          Container(
            height: MediaQuery.of(context).size.height / 2.5,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  "Ooops! 😓",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Some permissions needs to be granted. Check app permission then try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 60),
                MaterialButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/PermissionsScreen'),
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.blue.shade400,
                  child: const Text(
                    "Try Again",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
