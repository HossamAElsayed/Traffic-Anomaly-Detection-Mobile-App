import 'dart:async';

import 'package:adtracker/LOGIC/bloc/auth_bloc.dart';
import 'package:adtracker/LOGIC/cubit/records_cubit.dart';
import 'package:adtracker/UI/shared/shared.dart';

import '../../model/user.dart';
import '../../shared/constants.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../LOGIC/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    User user = context.read<AuthBloc>().state.user;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/SignInScreen', (Route<dynamic> route) => false);
          showASnackBar(
            context,
            "Logged out successfully.",
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
            child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 150.0,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: false,
                        titlePadding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        title: Text(
                          'Settings',
                          style: GoogleFonts.sora(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text("Account",
                              style: theme.textTheme.headline6
                                  ?.copyWith(fontWeight: FontWeight.w400)),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => _showProfileInfoModel(context, user),
                            child: Container(
                              height: 80,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade200),
                              child: Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey
                                          .shade300, // : Colors.grey.shade300
                                    ),
                                    child: (context.read<AuthBloc>().isLogged)
                                        ? const Center(
                                            child: Icon(
                                                Icons.verified_user_sharp,
                                                size: 32,
                                                color: Colors.green),
                                          )
                                        : Center(
                                            child: Icon(Icons.person,
                                                size: 32,
                                                color: Colors.grey.shade500),
                                          ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      user.uid,
                                      style: theme.textTheme.subtitle1
                                          ?.copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.blue),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text("Settings",
                              style: theme.textTheme.headline6
                                  ?.copyWith(fontWeight: FontWeight.w400)),
                          const SizedBox(height: 8),
                          _buildListTile(
                            'Data Usage',
                            //'total data usage by the app.',
                            'total usage: 450 MB',
                            Icons.data_usage_rounded,
                            Text('',
                                style: theme.textTheme.bodyText1
                                    ?.copyWith(color: Colors.grey.shade600)),
                            Colors.orange,
                            theme,
                            // onTap: () => Navigator.of(context)
                            //     .pushNamed('/DataUsageScreen'),
                          ),
                          // _buildListTile(
                          //   'Language',
                          //   '',
                          //   Icons.language,
                          //   Text('English',
                          //       style: theme.textTheme.bodyText1
                          //           ?.copyWith(color: Colors.grey.shade600)),
                          //   Colors.orange,
                          //   theme,
                          //   onTab: () {},
                          // ),
                          // const SizedBox(height: 8),
                          _buildListTile(
                            'Capture Duration',
                            'set time duration between each data capture.',
                            Icons.camera_alt,
                            BlocBuilder<SettingsCubit, SettingsState>(
                              builder: (context, state) {
                                final duration = context
                                    .select(
                                        (SettingsCubit b) => b.state.duration)
                                    .toString();
                                return Text(
                                  "$duration seconds",
                                  style: theme.textTheme.bodyText1
                                      ?.copyWith(color: Colors.grey.shade600),
                                );
                              },
                            ),
                            Colors.blue,
                            theme,
                            onTap: () => _showChangeDurationModel(context),
                          ),
                          const SizedBox(height: 8),
                          _buildListTile(
                              'Offline Mode',
                              'collect data without sending it to main server.',
                              Icons.cloud_off,
                              BlocBuilder<SettingsCubit, SettingsState>(
                            builder: (context, state) {
                              return Switch(
                                  value: context
                                      .read<SettingsCubit>()
                                      .getIsOfflineModeOn,
                                  onChanged: (value) {
                                    context
                                        .read<SettingsCubit>()
                                        .setIsOfflineMode = value;
                                  });
                            },
                          ), Colors.green, theme, onTap: () {}),
                          const SizedBox(height: 8),
                          _buildListTile(
                              'Start Syncing',
                              'Sync collected data with centerlized server.',
                              Icons.cloud_sync_outlined,
                              BlocBuilder<SettingsCubit, SettingsState>(
                            builder: (context, state) {
                              return (context.read<SettingsCubit>().getIsSync)
                                  ? const Center(
                                      child: SizedBox(
                                          width: 60,
                                          height: 10,
                                          child: LinearProgressIndicator()))
                                  : TextButton(
                                      onPressed: () {
                                        context
                                            .read<SettingsCubit>()
                                            .setIsSync = true;
                                        context.read<RecordsCubit>().sync();
                                        Timer.periodic(
                                            const Duration(milliseconds: 500),
                                            (timer) {
                                          if (context
                                              .read<RecordsCubit>()
                                              .isSyncFinished) {
                                            context
                                                .read<SettingsCubit>()
                                                .setIsSync = false;
                                            timer.cancel();
                                          }
                                        });
                                      },
                                      child: const Text(
                                        "sync",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    );
                              // return Switch(
                              //     value: context.read<RecordsCubit>().isSync,
                              //     onChanged: (value) {
                              //       context.read<RecordsCubit>().isSync = false;
                              //     });
                            },
                          ), Colors.deepPurple, theme, onTap: () {}),
                          const SizedBox(height: 8),
                          _buildListTile(
                            'Logout',
                            '',
                            Icons.exit_to_app,
                            const Text(''),
                            Colors.red,
                            theme,
                            onTap: () =>
                                context.read<AuthBloc>().add(AuthLogOut()),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationIcon: const FlutterLogo(),
                            applicationName: 'Anomaly Detection App',
                            applicationVersion: 'Version 1.0.0',
                            // applicationLegalese: '©2022 Woolha.com',
                            children: <Widget>[
                              const Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Text(devNames))
                            ],
                          );
                        },
                        child: Text("Version 1.0.0",
                            style: theme.textTheme.bodyText2
                                ?.copyWith(color: Colors.grey.shade500)),
                      ),
                    ],
                  ),
                ))),
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle, IconData icon,
      Widget trailing, Color color, theme,
      {onTap}) {
    return ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: Container(
          width: 46,
          height: 46,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: color.withAlpha(30)),
          child: Center(
            child: Icon(
              icon,
              color: color,
            ),
          ),
        ),
        title: Text(title, style: theme.textTheme.subtitle1),
        subtitle: Text(
          subtitle,
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              trailing,
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ],
          ),
        ),
        onTap: onTap);
  }

  _showProfileInfoModel(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 20),
              height: MediaQuery.of(context).size.height * 0.17,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'You are logged as:',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300, // : Colors.grey.shade300
                        ),
                        child: Center(
                          child: Icon(Icons.person,
                              size: 32, color: Colors.grey.shade500),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(fontSize: 25),
                          ),
                          Text(user.uid),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  _showChangeDurationModel(BuildContext context) {
    List<int> durationList = [for (var i = 10; i <= 30; i++) i];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 20),
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.14,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: durationList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            context.read<SettingsCubit>().setDuration =
                                durationList[index];
                            Navigator.pop(context);
                          },
                          child: ListTile(
                            title: Text(
                              "${durationList[index]} seconds",
                              style: const TextStyle(fontSize: 21),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
