import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_app/Preferences/preferences_helper.dart';
import 'package:image_app/auth_bloc/auth_bloc.dart';
import 'package:image_app/screen/home_page.dart';
import 'package:image_app/screen/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Preferences/preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PreferencesHelper.init().then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
          googleSignIn: GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/drive.readonly',
        ],
      )),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: PreferencesHelper.getBoolean(Preferences.isLoggedIn)
            ? const MyHomePage()
            : const LoginScreen(),
      ),
    );
  }
}

// 'https://drive.google.com/thumbnail?id=${imageId}&sz=w200-h200',
