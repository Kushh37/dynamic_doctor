import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_doctor/Pages/doctor/doctor_edit_profile_screen.dart';
import 'package:dynamic_doctor/Pages/patient/home.dart';
import 'package:dynamic_doctor/Services/firebase_push_notification_services.dart';
import 'package:dynamic_doctor/utils/constants.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Pages/auth/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  Splash createState() => Splash();
}

class Splash extends State<SplashScreen> {
  late FirebaseNotifcation firebase;
  @override
  void initState() {
    firebase = FirebaseNotifcation();
    firebase.initialize(context);
    super.initState();
    _getDoctor();
    _getPatient();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  String? _patient;
  Future<void> _getPatient() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;
    String userdoc = user!.uid;

    FirebaseFirestore.instance
        .collection("USERS")
        .doc(userdoc)
        .snapshots()
        .listen((event) {
      setState(() {
        _patient = event.get("type").toString();
      });
    });
  }

  String? _doctor;
  Future<void> _getDoctor() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;
    String userdoc = user!.uid;

    FirebaseFirestore.instance
        .collection("DOCTORS")
        .doc(userdoc)
        .snapshots()
        .listen((event) {
      setState(() {
        _doctor = event.get("type").toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (auth.currentUser == null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
              (route) => false);
        } else if (_patient == "PATIENT") {
          // print('Doctor Screen Route');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
              (route) => false);
        } else if (_doctor == "DOCTOR") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const DoctorEditProfileScreen()),
              (route) => false);
        }
      },
    );
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/background.jpg'),
          ),
          color: Colors.transparent),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(height: height * 0.3),
            Container(
              height: height * 0.15,
              margin: EdgeInsets.symmetric(horizontal: width * 0.1),
              alignment: Alignment.center,
              child: Image.asset("assets/Logofull.png"),
            ),
            SizedBox(height: height * 0.07),
            Center(
                child: Padding(
              padding: EdgeInsets.only(
                left: width * 0.1,
                right: width * 0.1,
              ),
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey[400],
                color: dark,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
