import 'package:dynamic_doctor/Pages/auth/login/login.dart';

import 'package:dynamic_doctor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SizedBox(
              height: height,
              child: Stack(
                children: [
                  Container(
                      decoration: const BoxDecoration(
                        color: lightpurple,
                        image: DecorationImage(
                          image: AssetImage("assets/background1.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: null),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.05),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.arrow_back,
                            size: height * 0.04,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: width * 0.05),
                        Text(
                          'Forgot Password?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.bold,
                              fontSize: 38,
                              color: Colors.white),
                        ),
                        SizedBox(height: width * 0.01),
                        Text(
                          'Reset your password now',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white),
                        ),
                        SizedBox(height: height * 0.2),
                        Text(
                          'To reset your password,please enter your email address or username below',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w400,
                              fontSize: width * 0.05,
                              color: Colors.white),
                        ),
                        SizedBox(height: height * 0.04),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                //controller: _phonecontroller,
                                keyboardType: TextInputType.name,

                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Enter your Username or Email',
                                  labelStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: width * 0.04),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.5),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusColor: purple,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: lightpurple, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(width: 1, color: dark),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              SizedBox(height: width * 0.05),
                              SizedBox(height: width * 0.08),
                              SizedBox(
                                width: width,
                                height: width * 0.12,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                lightpurple)),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) => const Login()));
                                    },
                                    child: Text(
                                      'Reset my password',
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.w600,
                                        fontSize: width * 0.05,
                                      ),
                                    )),
                              ),
                              SizedBox(height: width * 0.1),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
