// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:adtracker/LOGIC/bloc/auth_bloc.dart';
import 'package:adtracker/LOGIC/cubit/permissions_cubit.dart';
import 'package:adtracker/UI/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextEditingController? userNameController = TextEditingController();
    TextEditingController? passwordController = TextEditingController();
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            showASnackBar(
              context,
              "User does not exist.",
              color: Colors.red,
            );
          } else if (state is AuthLoggedIn) {
            if (context.read<PermissionsCubit>().isAllPermissionsGranted()) {
              Navigator.of(context).pushReplacementNamed('/HomePage');
            } else {
              Navigator.of(context).pushReplacementNamed('/PermissionsScreen');
            }
            showASnackBar(
              context,
              "You logged in successfully.",
              color: Colors.green,
            );
          }
        },
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(15),
            // color: Theme.of(context).canvasColor,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset(
                  'assets/icons/SP.png',
                  height: 130,
                ),
                // Spacer(),
                const Text(
                  'AUTOS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                TextField(
                  controller: userNameController,
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Username',
                    contentPadding: const EdgeInsets.all(15),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    contentPadding: const EdgeInsets.all(15),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return (state is AuthInitial)
                        ? const Center(child: CircularProgressIndicator())
                        : TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.blue,
                              backgroundColor: Colors.amber,
                              onSurface: Colors.red,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              // context.read<AuthBloc>().add(AuthLogOut());
                              String username = userNameController.text.trim();
                              String password = passwordController.text.trim();
                              if (username.isNotEmpty && password.isNotEmpty) {
                                context
                                    .read<AuthBloc>()
                                    .add(AuthLogIn(username, password));
                              } else {
                                showASnackBar(context,
                                    "Please enter your username and password to login.");
                              }
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 32),
                            ),
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
