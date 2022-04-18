import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:verbyl_project/authentication/login_email.dart';
import 'package:verbyl_project/pages/home.dart';
import 'package:verbyl_project/theme.dart';

import '../models/authentication_controller.dart';
import '../services/data.dart';

class VerifyScreen extends StatefulWidget {
  final name;
  const VerifyScreen({Key? key,required this.name}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState(name);
}

class _VerifyScreenState extends State<VerifyScreen> {
  final name;
  _VerifyScreenState(this.name);

  final FirebaseAuth auth = FirebaseAuth.instance;
  //AuthenticationController ac = AuthenticationController(FirebaseAuth.instance);
  var user;
  late Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();
    timer = Timer.periodic(
        const Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if(user.emailVerified){
      timer.cancel();
      sendUserData(name,user.email); //-> DB
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgDark,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Spacer(flex: 1,),
          SizedBox(
            height: 0.4 * height,
            width: width,
            child: Image(
              image: Image.network("https://media.istockphoto.com/vectors/profile-verification-check-marks-icons"
                  "-vector-illustration-vector-id1313547780?k=20&m=1313547780&s="
                  "612x612&w=0&h=dpYT_kesPq9p3wHVyXTXdMy71_o-YczCkG0zMrsNfiA=").image,
            ),
          ),
          const Spacer(flex: 2,),
          const CircularProgressIndicator(),
          const Spacer(flex: 1,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "A verification link has been sent to \n ${auth.currentUser?.email.toString()}",
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                    color: textLight,
                    fontSize: 20.0),
              ),
              const SizedBox(height: 8,),
              Text(
                "Please Verify",
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                    color: textLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ],
          ),
          const Spacer(flex: 2,)
        ],
      ),
    );
  }
}
