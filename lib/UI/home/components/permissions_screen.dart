import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../LOGIC/cubit/permissions_cubit.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({Key? key}) : super(key: key);

  @override
  _PermissionsScreenState createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  @override
  Widget build(BuildContext context) {
    bool isCameraPermissionGranted = context
        .select((PermissionsCubit p) => p.state.isCameraPermissionGranted);
    bool isGPSPermissionGranted =
        context.select((PermissionsCubit p) => p.state.isGPSPermissionGranted);
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          FadeInDown(
            from: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Permissions",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold),
                ),
                (isCameraPermissionGranted && isGPSPermissionGranted)
                    ? Container()
                    : IconButton(
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed('/NoPermissionsGranted'),
                        icon: const Icon(Icons.close))
              ],
            ),
          ),
          const SizedBox(height: 30),
          FadeInDown(
            from: 50,
            child: Text(
              "For this app to run properly, some essential permissions need to be granted.",
              style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 20),
            ),
          ),
          const SizedBox(height: 20),
          // TODO: Tile 1
          BlocBuilder<PermissionsCubit, PermissionsState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  context.read<PermissionsCubit>().checkCameraPermission();
                },
                child: FadeInUp(
                  delay: const Duration(milliseconds: 1 * 100),
                  child: AnimatedContainer(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 20),
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: isCameraPermissionGranted
                                ? Colors.blue
                                : Colors.white.withOpacity(0),
                            width: 2),
                        boxShadow: [
                          isCameraPermissionGranted
                              ? BoxShadow(
                                  color: Colors.blue.shade100,
                                  offset: const Offset(0, 3),
                                  blurRadius: 10)
                              : BoxShadow(
                                  color: Colors.grey.shade200,
                                  offset: const Offset(0, 3),
                                  blurRadius: 10)
                        ]),
                    child: Row(
                      children: [
                        isCameraPermissionGranted
                            ? Image.network(
                                'https://img.icons8.com/color/344/camera.png',
                                width: 50,
                              )
                            : Image.network(
                                'https://img.icons8.com/color/344/camera.png',
                                width: 50,
                              ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Camera',
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'to capture pics then send it to main server.',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        ),
                        Icon(
                          Icons.check_circle,
                          color: isCameraPermissionGranted
                              ? Colors.blue
                              : Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // TODO: Tile 2
          BlocBuilder<PermissionsCubit, PermissionsState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  context.read<PermissionsCubit>().checkLocationPermission();
                  // _locationRepo.getLocationPermission();
                },
                child: FadeInUp(
                  delay: const Duration(milliseconds: 2 * 100),
                  child: AnimatedContainer(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 20),
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: isGPSPermissionGranted
                                ? Colors.blue
                                : Colors.white.withOpacity(0),
                            width: 2),
                        boxShadow: [
                          isGPSPermissionGranted
                              ? BoxShadow(
                                  color: Colors.blue.shade100,
                                  offset: const Offset(0, 3),
                                  blurRadius: 10)
                              : BoxShadow(
                                  color: Colors.grey.shade200,
                                  offset: const Offset(0, 3),
                                  blurRadius: 10)
                        ]),
                    child: Row(
                      children: [
                        isGPSPermissionGranted
                            ? Image.network(
                                'https://img.icons8.com/fluency/344/worldwide-location.png',
                                width: 50,
                              )
                            : Image.network(
                                'https://img.icons8.com/fluency/344/worldwide-location.png',
                                width: 50,
                              ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'GPS Location',
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'to access the accurate location of the vehicle.',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        ),
                        Icon(
                          Icons.check_circle,
                          color: isGPSPermissionGranted
                              ? Colors.blue
                              : Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          BlocBuilder<PermissionsCubit, PermissionsState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  if (isCameraPermissionGranted && isGPSPermissionGranted) {
                    Navigator.of(context)
                        .pushReplacementNamed('/CameraFeedScreen');
                  }
                },
                child: Center(
                  child: Container(
                    width: 120,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: (isCameraPermissionGranted &&
                                isGPSPermissionGranted)
                            ? Colors.blue[800]
                            : Colors.grey[400]),
                    child: const Center(
                        child: Text(
                      "Finish",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ));
  }
}
