import 'dart:async';

import 'package:dynamic_doctor/Pages/patient/home.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class GoogleVerifyScreen extends StatelessWidget {
  const GoogleVerifyScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        print('Login Screen Route');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
            (route) => false);
      },
    );
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      child: Scaffold(
        //backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(height: height * 0.3),
            // Container(
            //   height: height * 0.15,
            //   margin: EdgeInsets.symmetric(horizontal: width * 0.1),
            //   alignment: Alignment.center,
            //   child: Image.asset("assets/google.png"),
            // ),
            SvgPicture.asset(
              'assets/google.svg',
              //color: Colors.white,
              height: width * 0.15,
              width: width * 0.15,
            ),
            SizedBox(height: height * 0.07),
            Text(
              "Verifying your Device...",
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w500, fontSize: width * 0.04),
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
