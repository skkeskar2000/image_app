import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_app/screen/home_page.dart';

import '../auth_bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          print(state);
          if (state is GoogleSignInSuccess) {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => MyHomePage(),
              ),
            );
          }
        },
        child: Center(
          child: FloatingActionButton.extended(
            backgroundColor: Colors.white,
            onPressed: () {
              context.read<AuthBloc>().add(GoogleSignInEvent());
            },
            label: Row(
              children: [
                Image.asset('asset/google_logo.png', height: 50, width: 50),
                const SizedBox(width: 10),
                const Text(
                  'Sign in with Google',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
