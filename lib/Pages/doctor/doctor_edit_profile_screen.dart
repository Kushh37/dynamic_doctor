import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_doctor/Pages/doctor/chat_support_d.dart';
import 'package:dynamic_doctor/Pages/doctor/doctor_call_history_appointment_screen.dart';
import 'package:dynamic_doctor/Pages/doctor/doctor_editprofile.dart';
import 'package:dynamic_doctor/Pages/doctor/settingd.dart';

import 'package:dynamic_doctor/utils/constants.dart';
import 'package:dynamic_doctor/widgets/drawer_doctor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import 'doctor_add_timing.dart';

class DoctorEditProfileScreen extends StatefulWidget {
  const DoctorEditProfileScreen({Key? key}) : super(key: key);

  @override
  _DoctorEditProfileScreenState createState() =>
      _DoctorEditProfileScreenState();
}

class _DoctorEditProfileScreenState extends State<DoctorEditProfileScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> _makePhoneCall(String contact, bool direct) async {
    if (direct == true) {
      bool? res = await FlutterPhoneDirectCaller.callNumber(contact);
    } else {
      String telScheme = 'tel:$contact';

      if (await canLaunch(telScheme)) {
        await launch(telScheme);
      } else {
        throw 'Could not launch $telScheme';
      }
    }
  }

  Stream<QuerySnapshot> _getReviews(speciality, id) {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc(speciality)
        .collection("DOCTORS")
        .doc(id)
        .collection('REVIEWS');

    return mainCollection.snapshots();
  }

  String _name = "";
  String _id = "";
  String _speciality = "";
  String _location = "";
  String _experience = "";
  String _registrationNumber = "";
  String _fullInfo = "";
  String _fullExperience = "";
  String _type = "";

  String _profilePicture = "";
  var status = true;

  Future<void> _getDoctorDetails() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;
    String userdoc = user!.uid;

    FirebaseFirestore.instance
        .collection("DOCTORS")
        .doc(userdoc)
        .snapshots()
        .listen((event) {
      setState(() {
        _id = userdoc;
        _name = event.get("name").toString();
        _speciality = event.get("speciality").toString();
        _location = event.get("location").toString();
        _experience = event.get("experience").toString();
        _registrationNumber = event.get("registration").toString();
        _fullInfo = event.get("fullInfo").toString();
        _fullExperience = event.get("fullExperience").toString();
        _profilePicture = event.get("profileUrl").toString();
        _type = event.get("type").toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _getDoctorDetails();
    if (_type == "DOCTOR") {
      didChangeAppLifecycleState(AppLifecycleState.resumed);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      String userdoc = user!.uid;

      await FirebaseFirestore.instance.collection("DOCTORS").doc(userdoc).set({
        "presence": "ACTIVE",
      }, SetOptions(merge: true));
      await FirebaseFirestore.instance
          .collection("Doctor")
          .doc(_speciality)
          .collection("DOCTORS")
          .doc(userdoc)
          .set({
        "presence": "ACTIVE",
      }, SetOptions(merge: true));
    } else {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      String userdoc = user!.uid;

      await FirebaseFirestore.instance.collection("DOCTORS").doc(userdoc).set({
        "presence": "INACTIVE",
      }, SetOptions(merge: true));
      await FirebaseFirestore.instance
          .collection("Doctor")
          .doc(_speciality)
          .collection("DOCTORS")
          .doc(userdoc)
          .set({
        "presence": "INACTIVE",
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: lightpurple,
          ),
          child: TabBar(
            controller: _tabController,
            indicatorColor: lightpurple,
            tabs: [
              Tab(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DoctorEditProfileScreen(),
                  )),
                  child: const Icon(
                    Icons.home_outlined,
                    size: 30,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        const DoctorCallHistoryAppointmentScreen(),
                  ));
                },
                child: const Tab(
                  child: Icon(
                    Icons.history,
                    size: 30,
                  ),
                ),
              ),
              Tab(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettingD(),
                    ));
                  },
                  child: const Icon(
                    Icons.settings,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: dark),
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: width * 0.07,
                width: width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: lightpurple2,
                ),
                child: Center(
                  child: Text(
                    "English",
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w600,
                        fontSize: height * 0.02,
                        color: Colors.white),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  languageHindi(context, width, height);
                },
                child: Container(
                  height: width * 0.07,
                  width: width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: dark,
                  ),
                  child: Center(
                    child: Text(
                      "Bengali",
                      style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w600,
                          fontSize: height * 0.02,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const ChatSupportScreenD()));
              },
              child: Image.asset(
                "assets/b1.png",
                width: width * 0.05,
              ),
            ),
            SizedBox(
              width: width * 0.02,
            ),
            GestureDetector(
              onTap: () {
                Alert(
                  context: context,
                  type: AlertType.success,
                  // title: "RFLUTTER ALERT",
                  desc: "Do you want to make a phone call to our support?",
                  buttons: [
                    DialogButton(
                      onPressed: () {
                        _makePhoneCall("06352192149", true);
                      },
                      color: lightpurple2,
                      child: const Text(
                        "Yes",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    DialogButton(
                      onPressed: () => Navigator.pop(context),
                      color: lightpurple2,
                      child: const Text(
                        "No",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ).show();
              },
              child: Image.asset(
                "assets/p1.png",
                width: width * 0.05,
              ),
            ),
            SizedBox(
              width: width * 0.03,
            ),
          ],
        ),
        drawer: Drawerd(),
        key: _scaffoldKey,
        body: Stack(
          children: [
            Container(
              height: height,
              decoration: const BoxDecoration(
                color: lightpurple,
                image: DecorationImage(
                  image: AssetImage("assets/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: null,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              height: height,
              width: width,
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: height * 0.20,
                        child: _details(width, height),
                      ),
                      SizedBox(height: height * 0.03),
                      Row(
                        children: [
                          Expanded(
                            child: EditButton(
                              width: width,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => DocEditProfileScreen()));
                              },
                              title: 'Edit Profile',
                            ),
                          ),
                          Expanded(
                            child: EditButton(
                              width: width,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) =>
                                        const DoctorAddTimingScreen()));
                              },
                              title: 'Edit Timing',
                            ),
                          ),
                          Expanded(
                            child: EditButton(
                              width: width,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) =>
                                        const DoctorCallHistoryAppointmentScreen()));
                              },
                              title: 'Appointments',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.04),
                  Expanded(
                    flex: 100,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: _info(height),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                ],
              ),
            ),
          ],
        ));
  }

  ListView _info(double height) {
    return ListView(
      children: [
        Text(
          'Info',
          style: GoogleFonts.raleway(
              fontSize: 18, fontWeight: FontWeight.bold, color: grey),
        ),
        SizedBox(height: height * 0.01),
        Text(
          // "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
          _fullInfo.toString(),
          style: GoogleFonts.raleway(
              fontSize: 14, fontWeight: FontWeight.w600, color: grey2),
        ),
        SizedBox(height: height * 0.02),
        Text(
          'Experience',
          style: GoogleFonts.raleway(
              fontSize: 18, fontWeight: FontWeight.bold, color: grey),
        ),
        SizedBox(height: height * 0.01),
        Text(
          // "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
          _fullExperience.toString(),
          style: GoogleFonts.raleway(
              fontSize: 14, fontWeight: FontWeight.w600, color: grey2),
        ),
      ],
    );
  }

  Row _details(double width, height) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(20)),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            _profilePicture,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Container(
                height: height * 0.2,
                width: width * 0.35,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: lightpink3,
                ),
              );
            },
            height: height * 0.2,
            width: width * 0.35,
            fit: BoxFit.cover,
          ),
        ),
        // ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(width * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // "Anil Bandi",
                  _name.toString(),
                  textAlign: TextAlign.left,
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600, fontSize: 24, color: grey),
                ),
                SizedBox(
                  width: width * 0.5,
                  height: width * 0.04,
                  child: StreamBuilder(
                    stream: _getReviews(_speciality, _id),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      } else if (snapshot.hasData || snapshot.data != null) {
                        //print(snapshot.data.toString());
                        return SizedBox(
                          width: width,
                          // color: Colors.blue,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              // String docId = snapshot.data!.docs[index]['email'];
                              int count1 = snapshot.data!.docs.length;
                              double rating = snapshot
                                      .data!.docs[index]["ratings"]
                                      .toDouble() ??
                                  0.0;

                              return count1 == 0
                                  ? Row(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        RatingBarIndicator(
                                          rating: 4,
                                          itemBuilder: (context, index) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: width * 0.03,
                                          direction: Axis.horizontal,
                                        ),
                                        const Text("(Reviews)")
                                      ],
                                    )
                                  : Row(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        RatingBarIndicator(
                                          rating: rating.toDouble(),
                                          itemBuilder: (context, index) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: width * 0.03,
                                          direction: Axis.horizontal,
                                        ),
                                        Text("($count1 Reviews)")
                                      ],
                                    );
                            },
                          ),
                        );
                      }
                      return const CircularProgressIndicator(
                        color: dark,
                      );
                    },
                  ),
                ),
                // Row(
                //   children: [
                //     Image.asset(
                //       'assets/star.png',
                //       height: width * 0.04,
                //       width: width * 0.04,
                //       color: orange,
                //     ),
                //     SizedBox(width: width * 0.01),
                //     Image.asset(
                //       'assets/star.png',
                //       height: width * 0.04,
                //       width: width * 0.04,
                //       color: orange,
                //     ),
                //     SizedBox(width: width * 0.01),
                //     Image.asset(
                //       'assets/star.png',
                //       height: width * 0.04,
                //       width: width * 0.04,
                //       color: orange,
                //     ),
                //     SizedBox(width: width * 0.01),
                //     Image.asset(
                //       'assets/star.png',
                //       height: width * 0.04,
                //       width: width * 0.04,
                //       color: orange,
                //     ),
                //     SizedBox(width: width * 0.01),
                //     Image.asset(
                //       'assets/star.png',
                //       height: width * 0.04,
                //       width: width * 0.04,
                //       color: orange,
                //     ),
                //     SizedBox(width: width * 0.01),
                //     Text(
                //       '(${_review.toString()}Reviews)',
                //       textAlign: TextAlign.center,
                //       style: GoogleFonts.raleway(
                //           fontWeight: FontWeight.w600,
                //           fontSize: 16,
                //           color: grey3),
                //     ),
                //   ],
                // ),
                SizedBox(height: width * 0.01),
                Text(
                  // 'Cardio Specialist',
                  _speciality.toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600, fontSize: 18, color: grey3),
                ),
                SizedBox(height: width * 0.02),
                Text(
                  // 'kolkata',
                  _location.toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600,
                      fontSize: width * 0.035,
                      color: grey3),
                ),
                SizedBox(height: width * 0.02),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EditButton extends StatelessWidget {
  const EditButton({
    Key? key,
    required this.width,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final double width;
  final Function onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      width: width,
      height: width * 0.1,
      child: ElevatedButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              elevation: MaterialStateProperty.all(5),
              backgroundColor: MaterialStateProperty.all(lightpurple)),
          onPressed: () => onTap(),
          child: Text(
            title,
            style: GoogleFonts.raleway(
                fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
          )),
    );
  }
}
