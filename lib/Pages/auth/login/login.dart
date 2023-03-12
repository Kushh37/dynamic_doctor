import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_doctor/Pages/auth/Forgot_password.dart';
import 'package:dynamic_doctor/Pages/auth/signup/doctor_login.dart';
import 'package:dynamic_doctor/Pages/auth/signup/patient_login.dart';
import 'package:dynamic_doctor/Pages/patient/home.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

var registrationtype;

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  //static final FacebookLogin facebookSignIn = new FacebookLogin();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    // getDetails();
    super.initState();
    // initPlatformState();
  }

  //

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.1),
              Container(
                height: height * 0.15,
                margin: EdgeInsets.symmetric(horizontal: width * 0.1),
                alignment: Alignment.center,
                child: Image.asset("assets/Logofull.png"),
              ),
              SizedBox(height: height * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05, vertical: width * 0.05),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: lightpurple, width: 2),
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50)),
                      color: lightpurple,
                    ),
                    unselectedLabelColor: black2,
                    tabs: [
                      Tab(
                          child: Container(
                        //height: height,
                        width: width * 0.9,
                        decoration: const BoxDecoration(),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'I AM A PATIENT',
                              style: GoogleFonts.raleway(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                      )),
                      Tab(
                          child: Container(
                        //height: height,
                        width: width * 0.9,
                        decoration: const BoxDecoration(),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'I AM A DOCTOR',
                              style: GoogleFonts.raleway(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                      )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: width,
                  height: height,
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      _patient(height, width, context),
                      const DoctorLogin(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: width,
                child: Text(
                  'Powered by Humbingo Technologies.',
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w700, fontSize: 10, color: dark),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: height * 0.01),
            ],
          ),
        ),
      ),
    );
  }

  Widget _patient(height, width, context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: height * 0.04),
          Text(
            'Welcome',
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
                fontWeight: FontWeight.w600, fontSize: 26, color: dark),
          ),
          SizedBox(height: height * 0.01),
          Text(
            'Sign in to continue',
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
                fontWeight: FontWeight.w700, fontSize: 18, color: dark),
          ),
          SizedBox(height: height * 0.04),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(blue2)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PatientLoginPhone()));
              },
              child: Text(
                'Sign in with mobile number',
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              )),
          SizedBox(height: height * 0.02),
          Text(
            '---------- or ----------',
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
                fontWeight: FontWeight.w700, fontSize: 18, color: dark),
          ),
          SizedBox(height: height * 0.02),
          Row(
            children: [
              // Expanded(
              //   child: GestureDetector(
              //     onTap: () async {
              //       // this.displayIncomingCall();
              //       // FirebaseAuth auth = FirebaseAuth.instance;
              //       // final credential1 = await auth
              //       //     .signInWithPhoneNumber("+917797562341")
              //       //     .then((value) {
              //       //   print("Value: $value");
              //       //   Navigator.of(context).push(
              //       //       MaterialPageRoute(builder: (context) => Home()));
              //       // });
              //       // print("Cred: $credential1");

              //       //             String? facebookName, facebookEmail;
              //       //             final FacebookLoginResult result =
              //       //                 await facebookSignIn.logIn(['email']);

              //       //             switch (result.status) {
              //       //               case FacebookLoginStatus.loggedIn:
              //       //                 final FacebookAccessToken accessToken =
              //       //                     result.accessToken;
              //       //                 final graphResponse = await http.get(Uri.parse(
              //       //                     "https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}"));
              //       //                 final profile = json.decode(graphResponse.body);
              //       //                 print("Profile: $profile");
              //       //                 setState(() {
              //       //                   facebookName = profile['first_name'];
              //       //                   facebookEmail = profile['email'];
              //       //                 });
              //       //                 print("Facebook Name: $facebookName");
              //       //                 print("Facebook Name: $facebookEmail");
              //       //                 Navigator.of(context).pushReplacement(
              //       //                     MaterialPageRoute(builder: (context) {
              //       //                   return Home();
              //       //                 }));

              //       //                 print('''
              //       //  Logged in!

              //       //  Token: ${accessToken.token}
              //       //  User id: ${accessToken.userId}
              //       //  Expires: ${accessToken.expires}
              //       //  Permissions: ${accessToken.permissions}

              //       //  ''');
              //       //                 break;
              //       //               case FacebookLoginStatus.cancelledByUser:
              //       //                 print('Login cancelled by the user.');
              //       //                 break;
              //       //               case FacebookLoginStatus.error:
              //       //                 print('Something went wrong with the login process.\n'
              //       //                     'Here\'s the error Facebook gave us: ${result.errorMessage}');
              //       //                 break;
              //       //             }
              //     },
              //     child: Container(
              //       //margin: EdgeInsets.only(left: width * 0.04),
              //       height: width * 0.08,
              //       decoration: BoxDecoration(
              //         color: const Color.fromRGBO(66, 103, 178, 1),
              //         //color: Colors.white,
              //         borderRadius: BorderRadius.circular(3),
              //       ),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           SvgPicture.asset(
              //             'assets/facebook.svg',
              //             color: Colors.white,
              //             height: width * 0.05,
              //             width: width * 0.05,
              //           ),
              //           SizedBox(width: width * 0.02),
              //           Container(
              //             alignment: Alignment.center,
              //             child: Text(
              //               'Facebook',
              //               style: GoogleFonts.raleway(
              //                   fontWeight: FontWeight.w700,
              //                   fontSize: width * 0.04,
              //                   color: Colors.white),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Text(
                '  ',
                style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w700, fontSize: 18, color: dark),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    FirebaseMessaging fcm = FirebaseMessaging.instance;
                    FirebaseAuth auth = FirebaseAuth.instance;
                    final googleSignIn = GoogleSignIn();
                    final googleUser = await googleSignIn.signIn();
                    if (googleUser != null) {
                      final googleAuth = await googleUser.authentication;
                      if (googleAuth.idToken != null) {
                        final userCredential = await auth.signInWithCredential(
                          GoogleAuthProvider.credential(
                              idToken: googleAuth.idToken,
                              accessToken: googleAuth.accessToken),
                        );
                        final user = userCredential.user;
                        String userdoc = user!.uid;
                        FirebaseFirestore.instance
                            .collection('USERS')
                            .doc(userdoc)
                            .set({
                          "email": googleUser.email.toString(),
                          "name": googleUser.displayName.toString(),
                          "type": "PATIENT",
                          "phone": "",
                          "profileUrl": googleUser.photoUrl.toString(),
                          "gender": "Male",
                          "age": "NotFound",
                          "address": "",
                        });
                        var _fcmToken = fcm.getToken().then((value) {
                          FirebaseFirestore.instance
                              .collection("USERS")
                              .doc(user.uid)
                              .collection("TOKENS")
                              .doc(value)
                              .set({
                            "token": value,
                          });
                        });

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('email', googleUser.email.toString());
                        DocumentSnapshot data = await FirebaseFirestore.instance
                            .collection("USERS")
                            .doc(userdoc)
                            .get();

                        if (data.exists) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('You have successfully logged in')));
                          //user exists so navigate to dashboard
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Error signing in')));
                        }
                        // return userCrediatial.user;

                      } else {
                        throw FirebaseAuthException(
                          message: "Sign in aborded by user",
                          code: "ERROR_ABORDER_BY_USER",
                        );
                      }
                    }

                    //To Do
                  },
                  child: Container(
                    //margin: EdgeInsets.only(left: width * 0.04),
                    height: width * 0.08,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/google.svg',
                          //color: Colors.white,
                          height: width * 0.05,
                          width: width * 0.05,
                        ),
                        SizedBox(width: width * 0.02),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Google',
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w700,
                                fontSize: width * 0.04,
                                color: dark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                '  ',
                style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w700, fontSize: 18, color: dark),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PatientLoginEmail()));
                  },
                  child: Container(
                    //margin: EdgeInsets.only(left: width * 0.04),
                    height: width * 0.08,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mail, color: dark, size: width * 0.04),
                        SizedBox(width: width * 0.02),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Email',
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w700,
                                fontSize: width * 0.04,
                                color: dark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.04),
          Text(
            'Forget Password?',
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
                fontWeight: FontWeight.w600, fontSize: 26, color: dark),
          ),
          SizedBox(height: height * 0.01),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ForgotPassword()));
            },
            child: Text(
              'click here to reset it',
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700, fontSize: 18, color: dark),
            ),
          ),
        ],
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  signInWithGoogle(context) async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('fuid', googleUser.id.toString());

        DocumentSnapshot data = await FirebaseFirestore.instance
            .collection("USERS")
            .doc(googleUser.id.toString())
            .get();

        FirebaseFirestore.instance
            .collection("USERS")
            .doc(googleUser.id.toString())
            .snapshots()
            .listen((event) {
          setState(() {
            registrationtype = event.get("registration_type");
            // print("registration type: " + registrationtype);
          });
        });

        if (data.exists && registrationtype == "GMAIL_LOGIN") {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You have successfully logged in')));
          //user exists so navigate to dashboard
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Home()));
        } else if (registrationtype == "") {
          //if registration type does not exist then save the data
          // CollectionReference _users =
          //     FirebaseFirestore.instance.collection('USERS');

          FirebaseFirestore.instance
              .collection('USERS')
              .doc(googleUser.id.toString())
              .set({
            "email": googleUser.email.toString(),
            "fuid": googleUser.id.toString(),
            "name": "User",
            "registration_type": "GMAIL_LOGIN",
            "user_type": "PATIENT",
          });

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Home()));

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('You have successfully registered with Sebok')));
        } else if (data.exists && registrationtype == "PHONE_OTP_LOGIN") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('You have registered with your phone number')));
        } else if (!data.exists) {
          FirebaseFirestore.instance
              .collection('USERS')
              .doc(googleUser.id.toString())
              .set({
            "email": googleUser.email.toString(),
            "fuid": googleUser.id.toString(),
            "name": "User",
            "registration_type": "GMAIL_LOGIN",
            "user_type": "PATIENT",
          });

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Home()));

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('You have successfully registered with Sebok')));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Error signing in')));
        }

        // return userCredential.user;

      }
    } else {
      throw FirebaseAuthException(
        message: "Sign in aborded by user",
        code: "ERROR_ABORDER_BY_USER",
      );
    }
  }
}
