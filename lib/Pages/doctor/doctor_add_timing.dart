import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_doctor/Pages/doctor/chat_support_d.dart';
import 'package:dynamic_doctor/Pages/doctor/doctor_call_history_appointment_screen.dart';
import 'package:dynamic_doctor/Pages/doctor/doctor_edit_profile_screen.dart';
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

class DoctorAddTimingScreen extends StatefulWidget {
  const DoctorAddTimingScreen({Key? key}) : super(key: key);

  @override
  _DoctorAddTimingScreenState createState() => _DoctorAddTimingScreenState();
}

class _DoctorAddTimingScreenState extends State<DoctorAddTimingScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );
    _getDoctorDetails().then((value) => print("Speciality: $_speciality"));
    // _getTimings();
    // _getTimings();

    //_getTimings();
  }

  Stream<QuerySnapshot> _getReviews(speciality, id) {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc(_speciality)
        .collection("DOCTORS")
        .doc(_id)
        .collection('REVIEWS');

    return mainCollection.snapshots();
  }

  String _id = "";
  String _name = "";
  String _speciality = "";
  String _location = "";

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

        _profilePicture = event.get("profileUrl").toString();

        print("Name: " + _name.toString());
        print("speciality: " + _speciality.toString());
        print("location: " + _location.toString());
        print("profilePicture: " + _profilePicture.toString());
      });
    });
  }

  Stream<QuerySnapshot> _getTimings() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userdoc = user!.uid;
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection("Doctor")
        .doc(_speciality)
        .collection("DOCTORS")
        .doc(userdoc)
        .collection("TIMINGS");
    return mainCollection.snapshots();
  }

  Future<void> _sendData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userdoc = user!.uid;
    await FirebaseFirestore.instance
        .collection("Doctor")
        .doc(_speciality)
        .collection("DOCTORS")
        .doc(userdoc)
        .collection("TIMINGS")
        .doc("${_dayValue.toString()} ${_timeValue.toString()}")
        .set(
      {
        "day": _dayValue.toString(),
        "time": _timeValue.toString(),
      },
      SetOptions(merge: true),
    );
  }

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

  var _dayValue;
  final List<String> _days = <String>[
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
  Widget selectDay(height, width) {
    return Container(
      margin: EdgeInsets.fromLTRB(width * 0.06, 0.0, width * 0.06, 0.0),
      decoration: BoxDecoration(
        color: dark.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.fromLTRB(
          width * 0.025, height * 0.005, width * 0.017, height * 0.005),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                dropdownColor: Colors.grey[100],
                items: _days
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: dark),
                          ),
                        ))
                    .toList(),
                onChanged: (selectedtype) {
                  setState(() {
                    _dayValue = selectedtype;
                  });
                },
                value: _dayValue,
                hint: Text(
                  "Day",
                  style: TextStyle(
                    color: dark,
                    fontWeight: FontWeight.w600,
                    fontSize: height * 0.025,
                  ),
                ),
                elevation: 0,
                isExpanded: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  var _timeValue;
  final List<String> _times = <String>[
    "10:00 - 10:30",
    "11:00 - 11:30",
    "12:00 - 12:30",
    "01:00 - 01:30",
    "02:00 - 02:30",
    "03:00 - 03:30",
    "04:00 - 04:30",
    "05:00 - 05:30",
    "06:00 - 06:30",
  ];
  Widget selectTime(height, width) {
    return Container(
      margin: EdgeInsets.fromLTRB(width * 0.06, 0.0, width * 0.06, 0.0),
      decoration: BoxDecoration(
        color: dark.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.fromLTRB(
          width * 0.025, height * 0.005, width * 0.017, height * 0.005),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                dropdownColor: Colors.grey[100],
                items: _times
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: dark),
                          ),
                        ))
                    .toList(),
                onChanged: (selectedtype) {
                  setState(() {
                    _timeValue = selectedtype;
                  });
                },
                value: _timeValue,
                hint: Text(
                  "Timings",
                  style: TextStyle(
                    color: dark,
                    fontWeight: FontWeight.w600,
                    fontSize: height * 0.025,
                  ),
                ),
                elevation: 0,
                isExpanded: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawerd(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: dark),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
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
      // backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Stack(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        //padding: EdgeInsets.all(width * 0.04),
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
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02),
                              width: width,
                              height: width * 0.1,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.zero),
                                      elevation: MaterialStateProperty.all(5),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              lightpurple2)),
                                  onPressed: () {},
                                  child: Text(
                                    "Edit Timing",
                                    style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.white),
                                  )),
                            ),
                          ),
                          Expanded(
                            child: EditButton(
                              width: width,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const DoctorCallHistoryAppointmentScreen()));
                              },
                              title: 'Appointments',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.03),
                      Text(
                        'Scheduled Slots',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.05,
                            color: dark),
                      ),
                      SizedBox(height: width * 0.02),
                    ],
                  ),
                  Container(
                    height: width * 0.1,
                    alignment: Alignment.center,
                    child: StreamBuilder(
                      stream: _getTimings(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        } else if (snapshot.hasData || snapshot.data != null) {
                          return ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  width: width * 0.02,
                                );
                              },
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                String day = snapshot.data!.docs[index]['day'];
                                String time =
                                    snapshot.data!.docs[index]['time'];

                                return SizedBox(
                                  height: width * 0.02,
                                  width: width * 0.5,
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.02),
                                    color: lightpink2.withOpacity(0.5),
                                    child: Text(
                                      "$day $time",
                                      style: GoogleFonts.raleway(
                                          fontSize: width * 0.04),
                                    ),
                                  ),
                                );
                              });
                        }
                        return Container(
                          color: Colors.green,
                          child: const CircularProgressIndicator(
                            color: dark,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    'Available Timing',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.05,
                        color: dark),
                  ),
                  SizedBox(height: height * 0.03),
                  selectDay(height, width),
                  SizedBox(height: height * 0.03),
                  selectTime(height, width),
                  SizedBox(height: height * 0.05),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: EditButton(
                          width: width,
                          onTap: () {
                            _sendData();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Availability Added Successfully.")));
                          },
                          title: 'Submit')),
                ],
              ),
            ),
          ],
        ),
      ),
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
              return Image.asset("assets/doctor.jpg");
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
                  textAlign: TextAlign.center,
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
                fontWeight: FontWeight.w600,
                fontSize: title == "Submit" ? 20 : 14,
                color: Colors.white),
          )),
    );
  }
}
