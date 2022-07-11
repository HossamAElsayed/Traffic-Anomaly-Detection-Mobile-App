import 'package:adtracker/LOGIC/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void nav(String routeName) {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacementNamed(routeName);
    });
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        // context.read<PermissionsCubit>().isAllPermissionsGranted()
        if (state is AuthLoggedIn) {
          nav('/HomePage');
        } else if (state is AuthLoggedOut) {
          nav('/SignInScreen');
        }
      },
      child: const Scaffold(
        backgroundColor: Color.fromRGBO(3, 9, 23, 1),
        body: Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: Image(
              image: AssetImage('assets/icons/SP.png'),
            ),
          ),
        ),
      ),
    );
  }
}
