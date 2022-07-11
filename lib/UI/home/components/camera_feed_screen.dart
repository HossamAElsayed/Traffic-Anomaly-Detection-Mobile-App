import 'dart:async';

import 'package:adtracker/LOGIC/cubit/records_cubit.dart';
import 'package:adtracker/SERVICE/database.dart';
import 'package:adtracker/UI/model/record.dart';

import '../../../LOGIC/cubit/server_conn_cubit.dart';
import '../../../SERVICE/local_db.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../LOGIC/cubit/internet_cubit.dart';
import '../../../LOGIC/cubit/settings_cubit.dart';
import '../../../SERVICE/location_repo.dart';
import '../../../main.dart';
import '../../model/location.dart';
import '../../records/records.dart';
import '../../shared/enums.dart';
import '../../shared/shared.dart';

class CameraFeedScreen extends StatefulWidget {
  const CameraFeedScreen({Key? key}) : super(key: key);

  @override
  CameraFeedScreenState createState() => CameraFeedScreenState();
}

class CameraFeedScreenState extends State<CameraFeedScreen> {
  bool _isStarted = false;
  late CameraController controller;
  late Future<void> _initializeControllerFuture;
  final LocationRepo _locationRepo = LocationRepo();
  final DataBaseRepo _dataBaseRepo = DataBaseRepo();
  late DeviceLocation locationData;

  String generateRID() => const Uuid().v1();

  Future<void> getCurrentLocation() async {
    locationData = await _locationRepo.getLocation();

    // ignore: use_build_context_synchronously
    showASnackBar(context,
        "speed: ${locationData.speed.toString()}\nlatitude: ${locationData.latitude.toString()}\nlongitude: ${locationData.longitude.toString()}");
  }

  Future<XFile> takeAPicture() async {
    late XFile image;
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Attempt to take a picture and then get the location
      // where the image file is saved.
      image = await controller.takePicture();

      // showASnackBar(context, "Image Taken.");
      return image;
    } catch (e) {
      // If an error occurs, log the error to the console.
      showASnackBar(context, "An error occurred while taking image!");
      debugPrint(e.toString());
    }
    return image;
  }

  void handleDetecting() async {
    // Future.delayed(const Duration(seconds: 5), () => condition = false);
    Stream.periodic(
            Duration(seconds: context.read<SettingsCubit>().state.duration))
        .takeWhile((_) => _isStarted)
        .forEach((e) async {
      // // First step is to take picture
      XFile img = await takeAPicture();
      // sendData(generateRID(), "80", "20.25", "30.12", img);

      // upload(img);
      // // Next, extract name then read it a bytes
      // String fileName = img.path.split('/').last;
      // var x = await img.readAsBytes();
      // String base64Image = base64Encode(x);
      // // After that, we can upload it our storage
      // uploadFile(fileName, base64Image);

      await getCurrentLocation();

      String uniqueRID = generateRID();
      final bool internetState = context.read<InternetCubit>().state.conState;
      String recordState =
          (!context.read<SettingsCubit>().getIsOfflineModeOn && internetState)
              ? "1"
              : "0";
      print("record to be uploaded is: $recordState");
      List l = [
        uniqueRID,
        locationData.latitude,
        locationData.longitude,
        locationData.speed,
        DateTime.now().toString(),
        img.path,
        recordState,
      ];
      context.read<RecordsCubit>().addNewLocalRecord(l);
      context.read<RecordsCubit>().addNewRecord(
            Record(
              rid: l[0],
              latitude: l[1],
              longitude: l[2],
              speed: l[3],
              time: locationData.time,
              dateTime: DateTime.now(),
              img: l[5],
              state: (int.parse(recordState) == 1) ? true : false,
            ),
          );
      if (!context.read<SettingsCubit>().getIsOfflineModeOn) {
        _dataBaseRepo.sendData(
          uniqueRID,
          locationData.speed.toString(),
          locationData.longitude.toString(),
          locationData.latitude.toString(),
          img,
          l[4],
        );
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    }
  }

  @override
  void initState() {
    super.initState();

    controller = CameraController(cameras[0], ResolutionPreset.high);
    _initializeControllerFuture = controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  LocalDB localDB = LocalDB();
  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetCubit, InternetState>(
      listener: (context, state) {
        bool s = context.read<SettingsCubit>().getIsOfflineModeOn;
        if (state is InternetConnected) {
          // showASnackBar(context, 'You are online');

          if (s) {
            _offlineModeStateDialog(context, true);
          }
        } else {
          showASnackBar(context, 'You are Disconnected');
          if (!s) {
            _offlineModeStateDialog(context, false);
          }
        }
      },
      child: Scaffold(
          backgroundColor: const Color(0xff0E1117),
          appBar: AppBar(
            backgroundColor: const Color(0xff0E1117),
            elevation: 0,
            title: Text(
              'Anomaly Detection Tracker',
              style: TextStyle(
                color: Colors.blueGrey.shade200,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: <Widget>[
              BlocBuilder<ServerConnCubit, ServerConnState>(
                builder: (context, state) {
                  return Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (state.isConnected) ? Colors.green : Colors.red,
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.blueGrey,
                ),
                onPressed: () async {
                  Navigator.pushNamed(context, '/SettingsScreen');
                  // XFile img = await takeAPicture();
                  // upload(img);
                  // Next, extract name then read it a bytes
                  // String fileName = img.path.split('/').last;
                  // var x = await img.readAsBytes();

                  //String base64Image = base64Encode(x);
                  // After that, we can upload it our storage
                  //uploadFile(fileName, base64Image);
                },
              ),
            ],
          ),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black,
                  child: CameraPreview(controller),
                ),
                AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: MediaQuery.of(context).size.height * 0.3,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _isStarted
                                ? showASnackBar(context, "Detection stopped.")
                                : showASnackBar(context,
                                    "Detection started.\nAn image will be taken every ${context.read<SettingsCubit>().getDuration} seconds.");
                            setState(() {
                              _isStarted = !_isStarted;
                            });
                            handleDetecting();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: _isStarted
                                  ? const Color(0xff161b22)
                                  : const Color(0xff161b22).withOpacity(0.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  _isStarted
                                      ? Icons.stop_circle
                                      : Icons.start_sharp,
                                  color: Colors.blue.shade600,
                                  size: 30,
                                ),
                                Text(
                                  _isStarted
                                      ? "Stop detecting"
                                      : "Start detecting",
                                  style: TextStyle(
                                      color:
                                          _isStarted ? Colors.red : Colors.blue,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return const RecordsDetailedScreen();
                              },
                              isScrollControlled: true,
                              isDismissible: true,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xff161b22).withOpacity(0.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(
                                  Icons.history,
                                  color: Colors.blueGrey,
                                  size: 30,
                                ),
                                Text(
                                  "Check History",
                                  style: TextStyle(
                                      color: Colors.blueGrey, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     setState(() {
                        //       _currentIndex = 2;
                        //     });
                        //   },
                        //   child: AnimatedContainer(
                        //     duration: const Duration(milliseconds: 500),
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 20.0, vertical: 15.0),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10),
                        //       color: _currentIndex == 2
                        //           ? const Color(0xff161b22)
                        //           : const Color(0xff161b22).withOpacity(0.0),
                        //     ),
                        //     child: Text(
                        //       "Y",
                        //       style: TextStyle(
                        //           color: _currentIndex == 2
                        //               ? Colors.blueGrey.shade200
                        //               : Colors.blueGrey,
                        //           fontSize: 20),
                        //     ),
                        //   ),
                        // ),
                      ],
                    )),
              ])),
    );
  }
}

Future _offlineModeStateDialog(BuildContext context, bool state) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: (state)
            ? const Text('You are back online?')
            : const Text('You are offline?'),
        content: (state)
            ? const Text(
                'Your device looks online. Would you like to disable offline mode and sync data.')
            : const Text(
                'Your device looks offline. Would you like to enable offline mode'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.cancel);
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              if (state) {
                context.read<SettingsCubit>().setIsOfflineMode = false;
                Navigator.of(context).pop(ConfirmAction.accept);
              } else {
                context.read<SettingsCubit>().setIsOfflineMode = true;
                Navigator.of(context).pop(ConfirmAction.accept);
              }
            },
          )
        ],
      );
    },
  );
}
