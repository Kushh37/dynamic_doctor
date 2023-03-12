import 'package:dynamic_doctor/Pages/auth/Forgot_password.dart';
import 'package:dynamic_doctor/Pages/auth/signup/google_verify.dart';
import 'package:dynamic_doctor/Services/auth_provider.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'verification_email_screen.dart';

class PatientRegistrationwithEmail extends StatefulWidget {
  const PatientRegistrationwithEmail({Key? key}) : super(key: key);

  @override
  _PatientRegistrationwithEmailState createState() =>
      _PatientRegistrationwithEmailState();
}

class _PatientRegistrationwithEmailState
    extends State<PatientRegistrationwithEmail> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    // String? _verificationid;
    super.initState();
  }

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
                        SizedBox(height: height * 0.04),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.arrow_back,
                            size: height * 0.04,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: width * 0.03),
                        Text(
                          'Register',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.1,
                              color: Colors.white),
                        ),
                        SizedBox(height: width * 0.01),
                        Text(
                          'Sign up Now',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.06,
                              color: Colors.white),
                        ),
                        SizedBox(height: height * 0.05),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
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
                              SizedBox(height: height * 0.015),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Email',
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
                              SizedBox(height: height * 0.015),
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Phone No.(optional)',
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
                              SizedBox(height: height * 0.015),
                              TextFormField(
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Password',
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
                              SizedBox(height: height * 0.015),
                              SizedBox(height: height * 0.05),
                              SizedBox(
                                width: width,
                                height: width * 0.12,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                lightpurple)),
                                    onPressed: () {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      AuthClass()
                                          .createUser(
                                              _nameController.text.trim(),
                                              _emailController.text.trim(),
                                              _phoneController.text.trim(),
                                              _passwordController.text.trim())
                                          .then((value) {
                                        if (value == "Created") {
                                          setState(() {
                                            isLoading = false;
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        VerificationEmailScreen()),
                                                (route) => false);
                                          });
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(value)));
                                        }
                                      });
                                    },
                                    child: isLoading == false
                                        ? Text(
                                            'Sign Up',
                                            style: GoogleFonts.raleway(
                                              fontWeight: FontWeight.w600,
                                              fontSize: width * 0.06,
                                            ),
                                          )
                                        : const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )),
                              ),
                              SizedBox(height: width * 0.02),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Already a member? Sign in now',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w600,
                                      fontSize: width * 0.04,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(height: width * 0.02),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPassword())),
                                child: Text(
                                  'forget Password?',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w600,
                                      fontSize: width * 0.04,
                                      color: Colors.white),
                                ),
                              ),
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

class PatientRegistrationwithPhone extends StatefulWidget {
  const PatientRegistrationwithPhone({Key? key}) : super(key: key);

  @override
  _PatientRegistrationwithPhoneState createState() =>
      _PatientRegistrationwithPhoneState();
}

class _PatientRegistrationwithPhoneState
    extends State<PatientRegistrationwithPhone> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  //String verificationId = "";
  //String phoneNo = "";
  //String? smsCode;
//  String? verificationId;

  // Future<void> verifyPhone() async {
  //   final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
  //       (String verId) {
  //     this.verificationId = verId;
  //   };

  //   final PhoneCodeSent smsCodeSent = (String verId, int? forceResendingToken) {
  //     this.verificationId = verId;
  //     smsCodeDialog(context).then((value) => print("Signed In"));
  //   };

  //   final PhoneVerificationCompleted verifiedSuccess =
  //       (PhoneAuthCredential phoneAuth) {
  //     print("Verified");
  //   };
  //   final PhoneVerificationFailed verificationFailed =
  //       (FirebaseAuthException exception) {
  //     print("${exception.message}");
  //   };
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: this.phoneNo,
  //       verificationCompleted: verifiedSuccess,
  //       verificationFailed: verificationFailed,
  //       codeSent: smsCodeSent,
  //       timeout: const Duration(seconds: 5),
  //       codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  // }

  // Future<bool?> smsCodeDialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text("Enter OTP"),
  //           content: TextField(
  //             onChanged: (value) {
  //               this.smsCode = value;
  //             },
  //           ),
  //           contentPadding: EdgeInsets.all(10),
  //           actions: [
  //             ElevatedButton(
  //                 onPressed: () {
  //                   FirebaseAuth auth = FirebaseAuth.instance;
  //                   if (auth.currentUser != null) {
  //                     Navigator.of(context).pop();
  //                     Navigator.of(context).push(
  //                         MaterialPageRoute(builder: (context) => Home()));
  //                   } else {
  //                     Navigator.of(context).pop();
  //                     signInWithPhone();
  //                   }
  //                 },
  //                 child: Text("Submit")),
  //           ],
  //         );
  //       });
  // }

  // signInWithPhone() {
  //   try {
  //     FirebaseAuth auth = FirebaseAuth.instance;
  //     auth.signInWithPhoneNumber(this.phoneNo);

  //     Navigator.of(context)
  //         .push(MaterialPageRoute(builder: (context) => Home()));
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

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
                        SizedBox(height: height * 0.04),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.arrow_back,
                            size: height * 0.04,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: width * 0.03),
                        Text(
                          'Register',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.1,
                              color: Colors.white),
                        ),
                        SizedBox(height: width * 0.01),
                        Text(
                          'Sign up Now',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.06,
                              color: Colors.white),
                        ),
                        SizedBox(height: height * 0.05),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
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
                              SizedBox(height: height * 0.015),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Email (Optional)',
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
                              SizedBox(height: height * 0.015),
                              TextFormField(
                                controller: _phoneController,
                                // onChanged: (value) {
                                //   this.phoneNo = value;
                                // },
                                keyboardType: TextInputType.phone,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Phone No.',
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
                              SizedBox(height: height * 0.015),
                              TextFormField(
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Password',
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
                              SizedBox(height: height * 0.015),
                              SizedBox(height: height * 0.05),
                              SizedBox(
                                width: width,
                                height: width * 0.12,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                lightpurple)),
                                    onPressed: () {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      AuthClass()
                                          .createUserforPhone(
                                              _nameController.text.trim(),
                                              _emailController.text.trim(),
                                              _phoneController.text.trim(),
                                              _passwordController.text.trim())
                                          .then((value) {
                                        if (value == "Created") {
                                          setState(() {
                                            isLoading = false;
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const GoogleVerifyScreen()),
                                                (route) => false);
                                          });
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(value)));
                                        }
                                      });
                                      // Navigator.of(context).push(
                                      //   MaterialPageRoute(
                                      //     builder: (context) => OtpScreen(
                                      //       route: "register",
                                      //       phone: _phoneController.text,
                                      //       name: _nameController.text,
                                      //       email: _emailController.text,
                                      //     ),
                                      //   ),
                                      // );
                                      // verifyPhone();
                                    },
                                    // onPressed: () async {
                                    //   FirebaseAuth _auth =
                                    //       FirebaseAuth.instance;
                                    //   isLoading = true;

                                    //   await _auth.verifyPhoneNumber(
                                    //     phoneNumber: _phoneController.text,
                                    //     verificationCompleted:
                                    //         (phoneAuthCredential) async {
                                    //       setState(() {
                                    //         isLoading = false;
                                    //       });
                                    //     },
                                    //     verificationFailed:
                                    //         (verificationFailed) async {
                                    //       isLoading = false;
                                    //       ScaffoldMessenger.of(context)
                                    //           .showSnackBar(SnackBar(
                                    //               content: Text(
                                    //                   verificationFailed.message
                                    //                       .toString())));
                                    //     },
                                    //     codeSent: (verificationId,
                                    //         resendingToken) async {
                                    //       isLoading = false;
                                    //       setState(() {
                                    //         verificationId = verificationId;
                                    //       });
                                    //     },
                                    //     codeAutoRetrievalTimeout:
                                    //         (verificationId) async {},
                                    //   );
                                    //   // Navigator.of(context)
                                    //   //     .push(MaterialPageRoute(
                                    //   //         builder: (context) => OtpScreen(
                                    //   //               verificationId:
                                    //   //                   verificationId,
                                    //   //             )));
                                    //   print("VerificationID:$verificationId");
                                    // },
                                    // onPressed: () {
                                    //   setState(() {
                                    //     isLoading = true;
                                    //   });
                                    //   AuthClass()
                                    //       .createUser(
                                    //           _nameController.text.trim(),
                                    //           _emailController.text.trim(),
                                    //           _phoneController.text.trim(),
                                    //           _passwordController.text.trim())
                                    //       .then((value) {
                                    //     if (value == "Created") {
                                    //       setState(() {
                                    //         isLoading = false;
                                    //         Navigator.pushAndRemoveUntil(
                                    //             context,
                                    //             MaterialPageRoute(
                                    //                 builder: (context) =>
                                    //                     Home()),
                                    //             (route) => false);
                                    //       });
                                    //     } else {
                                    //       setState(() {
                                    //         isLoading = false;
                                    //       });
                                    //       ScaffoldMessenger.of(context)
                                    //           .showSnackBar(SnackBar(
                                    //               content: Text(value)));
                                    //     }
                                    //   });
                                    // },
                                    child: isLoading == false
                                        ? Text(
                                            'Sign Up',
                                            style: GoogleFonts.raleway(
                                              fontWeight: FontWeight.w600,
                                              fontSize: width * 0.06,
                                            ),
                                          )
                                        : const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )),
                              ),
                              SizedBox(height: width * 0.02),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Already a member? Sign in now',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w600,
                                      fontSize: width * 0.04,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(height: width * 0.02),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPassword())),
                                child: Text(
                                  'forget Password?',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w600,
                                      fontSize: width * 0.04,
                                      color: Colors.white),
                                ),
                              ),
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
