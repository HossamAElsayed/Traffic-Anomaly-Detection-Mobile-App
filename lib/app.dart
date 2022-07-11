import 'package:adtracker/LOGIC/bloc/auth_bloc.dart';
import 'package:adtracker/SERVICE/auth_repo.dart';
import 'package:adtracker/SERVICE/database.dart';

import 'LOGIC/cubit/server_conn_cubit.dart';
import 'SERVICE/local_db.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'LOGIC/cubit/internet_cubit.dart';
import 'LOGIC/cubit/permissions_cubit.dart';
import 'LOGIC/cubit/records_cubit.dart';
import 'LOGIC/cubit/settings_cubit.dart';
import 'UI/router/router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final AppRouter _appRouter = AppRouter();
  final AuthRepo _authRepo = AuthRepo();
  final _connectivity = Connectivity();
  final settingsBox = Hive.box('settingsBox');
  final userBox = Hive.box('userBox');
  final LocalDB _localDB = LocalDB();
  final DataBaseRepo _dataBaseRepo = DataBaseRepo();

  @override
  Widget build(BuildContext context) {
    // _setHive();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ServerConnCubit(),
        ),
        BlocProvider(
            create: (_) =>
                AuthBloc(box: userBox, authRepo: _authRepo)..add(AuthStatus())),
        BlocProvider(
          create: (context) => PermissionsCubit(),
        ),
        BlocProvider(
          create: (context) => InternetCubit(connectivity: _connectivity),
        ),
        BlocProvider(
          create: (context) => SettingsCubit(box: settingsBox),
        ),
        BlocProvider(
          create: (_) => RecordsCubit(
            localDB: _localDB,
            dataBaseRepo: _dataBaseRepo,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: _appRouter.onGenerateRoute,
      ),
    );
  }
}
