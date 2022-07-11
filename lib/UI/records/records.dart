import 'package:adtracker/UI/records/components/record_detailed_screen.dart';

import '../../LOGIC/cubit/records_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RecordsDetailedScreen extends StatefulWidget {
  const RecordsDetailedScreen({Key? key}) : super(key: key);

  @override
  _RecordsDetailedScreenState createState() => _RecordsDetailedScreenState();
}

class _RecordsDetailedScreenState extends State<RecordsDetailedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Record History",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold),
              ),
              (context.read<RecordsCubit>().isEmpty)
                  ? Container()
                  : TextButton(
                      onPressed: () async {
                        final WarningAction _action =
                            await _deleteRecordsDialog(context);
                        if (_action == WarningAction.confirm) setState(() {});
                      },
                      child: const Text("Delete History")),
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close))
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: BlocBuilder<RecordsCubit, RecordsState>(
              builder: (context, state) {
                if (state.records.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/icons/empty-folder.png",
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.5,
                        ),
                        const Text(
                          "start detecting to save some records.",
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                } else if (state is RecordsInitial) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: state.records.length,
                    itemBuilder: (context, index) {
                      return RecordTile(
                        id: state.records[index].rid,
                        latitude: state.records[index].latitude.toString(),
                        longitude: state.records[index].longitude.toString(),
                        speed: state.records[index].speed.toString(),
                        date: DateFormat('E, d MMM yyyy')
                            .format(state.records[index].dateTime)
                            .toString(),
                        time: DateFormat('HH:mm:ss')
                            .format(state.records[index].dateTime)
                            .toString(),
                        loc: state.records[index].img,
                        state: state.records[index].state,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    ));
  }
}

class RecordTile extends StatelessWidget {
  const RecordTile({
    this.id,
    this.latitude,
    this.longitude,
    this.speed,
    this.date,
    this.time,
    this.loc,
    this.state,
    Key? key,
  }) : super(key: key);
  final String? id;
  final String? latitude;
  final String? longitude;
  final String? speed;
  final String? date;
  final String? time;
  final String? loc;
  final bool? state;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/RecordDetailsScreen',
          arguments: RecordDetailsScreen(
            id: id!,
            latitude: latitude!,
            longitude: longitude!,
            speed: speed!,
            time: time!,
            date: date!,
            loc: loc!,
            state: state!,
          )),
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.only(bottom: 20),
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0), width: 2),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(0, 3),
                  blurRadius: 10)
            ]),
        child: Row(
          children: [
            Image.asset(
              "assets/icons/image.png",
              height: 100,
              width: 60,
            ),
            // (loc!.isEmpty)
            //     ? Image.asset(
            //         "assets/icons/image.png",
            //         height: 100,
            //         width: 60,
            //       )
            //     : Image.file(
            //         File(loc!),
            //         height: 100,
            //         width: 60,
            //       ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    id!,
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Latitude: $latitude",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Longitude: $longitude",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Speed: $speed",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Date: $date",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Time: $time",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum WarningAction { cancel, confirm }

Future _deleteRecordsDialog(BuildContext context) async {
  return showDialog<WarningAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete all records?'),
        content: const Text(
            'Please note that this action will delete all collected data.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(WarningAction.cancel),
          ),
          TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                context.read<RecordsCubit>().deleteLocalRecordHistory();
                Navigator.of(context).pop(WarningAction.confirm);
              })
        ],
      );
    },
  );
}
