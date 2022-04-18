import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_visualizer/music_visualizer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbyl_project/models/authentication_controller.dart';
import 'package:verbyl_project/models/music_player.dart';
import 'package:verbyl_project/models/user.dart';
import 'package:verbyl_project/services/data.dart';
import 'package:verbyl_project/services/location.dart';
import '/theme.dart';
import 'authentication/login_email.dart';
import 'models/charts.dart';
import 'pages/home.dart';
import 'package:device_preview/device_preview.dart';
import 'services/helpers.dart';

//String magicAuthCredentials = "pk_live_B8336C86A7989E33";
AuthenticationController authenticationController = AuthenticationController(FirebaseAuth.instance);
VerbylUser user = VerbylUser();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      const MyApp(),
      // DevicePreview(
      //   builder: (context) => const MyApp(),
      //   enabled: !kReleaseMode,
      // )
    );
  }
  );
}

Charts? sss;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // void fun() async {
  //   sss = await Helpers().getCharts("IN",20);
  // }

  @override
  Widget build(BuildContext context) {
    //fun();
    return MultiProvider(
      providers: [
        Provider<AuthenticationController>(
          create: (_) => AuthenticationController(FirebaseAuth.instance),
        ),
        // ChangeNotifierProvider<MusicPlayerModel>(create: (_) => MusicPlayerModel(),),
        // ChangeNotifierProvider<PlayingQueue>(create: (_) => PlayingQueue([]),),
        StreamProvider(
          create: (context) =>
          context.read<AuthenticationController>().authStateChanges, initialData: null,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.montserratTextTheme(),
        ),
        title: 'Verbyl',
        home: const SplashScreen(),
      )
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var firebaseUser = context.watch<User?>();
    if (firebaseUser != null && firebaseUser.emailVerified){
      //Logged in user
      authenticationController.userEmail = firebaseUser.email.toString();
      getUserData(authenticationController.userEmail).then((value){
          debugPrint("Logged in directly from main.dart");
          return const Home();
      });
      return const Home();
    }
    else {
      return const LoginEmail();
    }
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), (){
      getLocation().then((value){
        setState(() {
          verbylUserLocation = value.address;
          isLocationPermissionDenied = value.isLocationDenied;
        });
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AuthenticationWrapper())
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgDark,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 0.2 * size.height,
            child: Image.asset("assets/images/logo.png"),
          ),
          SizedBox(
            height: size.height * 0.1,
            width: size.width * 0.75,
            // child: null,
            child: MusicVisualizer(
              barCount: 15,
              colors: colors,
              duration: duration,
            ),
          ),
        ],
      ),
    );
  }
}


