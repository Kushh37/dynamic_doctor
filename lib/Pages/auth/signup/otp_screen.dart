import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_doctor/Pages/patient/home.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpScreen extends StatefulWidget {
  final String route;
  final String? phone;
  final String? name;
  final String? email;

  const OtpScreen({
    Key? key,
    required this.phone,
    this.name,
    required this.route,
    this.email,
  }) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final _otpController = TextEditingController();

  String _verificationCode = "";
  @override
  void initState() {
    super.initState();
    _verifyPhone();

    // print("Phone: ${widget.phone}");
    // print("Name: ${widget.name}");
    // print("Email: ${widget.email}");
  }

  bool isLoading = false;
  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              widget.route == "register"
                  ? FirebaseFirestore.instance
                      .collection("USERS")
                      .doc(value.user!.uid)
                      .set({
                      "email": widget.email,
                      "name": widget.name,
                      "phone": widget.phone,
                      "type": "PATIENT",
                      "profileUrl":
                          "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                    }, SetOptions(merge: true))
                  : null;
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                  (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: const Duration(seconds: 120));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldkey,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: lightpurple,
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: null,
          ),
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: height * 0.2),
                      Icon(
                        CupertinoIcons.device_phone_portrait,
                        size: height * 0.1,
                        color: dark,
                      ),
                      SizedBox(height: height * 0.04),
                      Text(
                        'Verification',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.036,
                            color: dark),
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        'You will get otp via sms on \n ${widget.phone}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w500,
                            fontSize: height * 0.026,
                            color: dark),
                      ),
                      SizedBox(height: height * 0.08),
                      TextFormField(
                        controller: _otpController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: lightpurple,
                            fontSize: 20),
                        decoration: InputDecoration(
                          hintText: '',
                          hintStyle: GoogleFonts.raleway(
                              fontWeight: FontWeight.bold,
                              color: lightpurple,
                              fontSize: 20),
                          // filled: true,
                          // fillColor: Colors.transparent.withOpacity(0.05),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1.0, color: lightpurple),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusColor: purple,
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: lightpurple, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 0, color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.04),
                      SizedBox(
                        width: width,
                        height: width * 0.12,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(lightpurple)),
                            onPressed: () async {
                              try {
                                await FirebaseAuth.instance
                                    .signInWithCredential(
                                        PhoneAuthProvider.credential(
                                            verificationId: _verificationCode,
                                            smsCode: _otpController.text))
                                    .then((value) async {
                                  if (value.user != null) {
                                    FirebaseAuth _auth = FirebaseAuth.instance;
                                    await FirebaseFirestore.instance
                                        .collection("USERS")
                                        .doc(value.user!.uid)
                                        .set({
                                      "email": widget.email,
                                      "name": widget.name,
                                      "phone": widget.phone,
                                      "type": "PATIENT",
                                      "profileUrl":
                                          "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                                    }, SetOptions(merge: true));
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Home()),
                                        (route) => false);
                                  }
                                });
                              } catch (e) {
                                FocusScope.of(context).unfocus();
                                // _scaffoldkey.currentState.showSnackBar(
                                //     SnackBar(content: Text('invalid OTP')));
                              }
                            },
                            child: Text(
                              'Submit',
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w600,
                                fontSize: 28,
                              ),
                            )),
                      ),
                      SizedBox(height: height * 0.04),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     // SizedBox(width: width * 0.08),
                      //     Text(
                      //       'Didn\'t Recieve the verification OTP?',
                      //       style: GoogleFonts.raleway(
                      //           fontSize: height * .018,
                      //           fontWeight: FontWeight.w500,
                      //           color: dark),
                      //     ),
                      //     SizedBox(width: width * 0.01),
                      //     InkWell(
                      //       onTap: () {
                      //         // Navigator.of(context).push(MaterialPageRoute(
                      //         //     builder: (context) => PRegistrationPage()));
                      //       },
                      //       child: Text(
                      //         'Resend Again',
                      //         style: GoogleFonts.raleway(
                      //             fontSize: height * 0.018,
                      //             fontWeight: FontWeight.w500,
                      //             color: lightpurple),
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
