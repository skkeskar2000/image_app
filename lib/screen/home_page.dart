import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:image_app/Preferences/preferences.dart';
import 'package:image_app/Preferences/preferences_helper.dart';
import 'package:image_app/auth_bloc/auth_bloc.dart';
import 'package:image_app/screen/login_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    _handleSignIn();
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.portraitUp,
      // DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }
  List<String> idList = [];

  Future<void> _handleSignIn() async {
    try {
      final accessCredentials = auth.AccessCredentials(
        auth.AccessToken(
          'Bearer',
          PreferencesHelper.getString(Preferences.accessToken) ?? '',
          DateTime.now()
              .add(const Duration(days: 30))
              .toUtc(), // Set the expiration time to 1 hour from now
        ),
        null,
        ['https://www.googleapis.com/auth/drive.readonly'],
      );
      final authClient = await auth.authenticatedClient(
        http.Client(),
        accessCredentials,
      );

      final driveApi = drive.DriveApi(authClient);
      print(driveApi.files.list());
      drive.FileList files = await driveApi.files
          .list(q: "mimeType='image/jpeg' or mimeType='image/png' or mimeType='image/JPG' or mimeType='image/jpg'");

      if (files.files != null) {
        idList = files.files!.map((file) {
          print(file.name);
          print('https://drive.google.com/thumbnail?id=${file.id}');
          return file.id.toString();
        }).toList();
      } else {
        print("No files found");
        // Handle the case where no files were found
      }
      setState(() {
        idList;
      });
    } catch (error) {
      print("-------error-------");
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is GoogleSignOutSuccess) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              idList.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Center(
                    child: CarouselSlider.builder(
                        itemCount: idList.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) {
                          final imageId = idList[itemIndex];
                          print('https://drive.google.com/thumbnail?id=${imageId}');
                          return CachedNetworkImage(
                            imageUrl:
                                "https://drive.google.com/thumbnail?id=${imageId}",
                            imageBuilder: (context, imageProvider) => Container(
                              height: MediaQuery.of(context).size.height * 0.8,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          );
                        },
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.8,
                          // aspectRatio: 16 / 50,
                          // viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.3,
                          // onPageChanged: callbackFunction,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                  ),

              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(GoogleSignOutEvent());
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
