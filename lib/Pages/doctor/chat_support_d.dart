import 'package:dynamic_doctor/Pages/doctor/doctor_call_history_appointment_screen.dart';
import 'package:dynamic_doctor/Pages/patient/CallHistory.dart';
import 'package:dynamic_doctor/Pages/patient/home.dart';
import 'package:dynamic_doctor/Pages/patient/settings.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:dynamic_doctor/widgets/drawer_doctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../chat_support.dart';

class ChatSupportScreenD extends StatefulWidget {
  const ChatSupportScreenD({Key? key}) : super(key: key);

  @override
  _ChatSupportScreenDState createState() => _ChatSupportScreenDState();
}

class _ChatSupportScreenDState extends State<ChatSupportScreenD>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: const Drawerd(),
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
                        "Hindi",
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
              //unselectedLabelColor: grey,
              controller: _tabController,
              indicatorColor: lightpurple,
              tabs: [
                Tab(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Home(),
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
                      builder: (context) => const CallHistoryScreen(),
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
                        builder: (context) => const PatientSettings(),
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
          floatingActionButton: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LiveChat(route: "doctor")));
            },
            child: Container(
              height: height * 0.15,
              width: width * 0.15,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: dark,
              ),
              child: Icon(
                Icons.message,
                size: width * 0.08,
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(width * 0.02),
              child: Column(
                children: [
                  Text(
                    "CHAT SUPPORT",
                    style: TextStyle(
                        color: dark,
                        fontSize: height * 0.03,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    "Are you lost? Can't be able to understand how to book a doctor or order medicine.Click on the chat bubble in the bottom right corner to start a chat session with our agent.But here are some quick links for you.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.05),
                  Column(
                    children: [
                      Container(
                        color: lightgrey.withOpacity(0.09),
                        width: width,
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.04, vertical: width * 0.02),
                        margin: EdgeInsets.symmetric(
                            horizontal: width * 0.04, vertical: width * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "View Appointments",
                              style: TextStyle(
                                  color: dark,
                                  fontSize: width * 0.08,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: width * 0.02),
                            Text(
                              "Check your past and future appointments and manage them.",
                              style: TextStyle(
                                  color: dark,
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: width * 0.04),
                            SizedBox(
                              width: width * 0.4,
                              height: width * 0.12,
                              child: MaterialButton(
                                  elevation: 0.0,
                                  color: lightpurple.withOpacity(0.6),
                                  onPressed: () async {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            const DoctorCallHistoryAppointmentScreen()));
                                  },
                                  child: Text(
                                    'View Appointments',
                                    style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.w400,
                                        color: grey,
                                        fontSize: width * 0.03),
                                  )),
                            ),
                            SizedBox(height: width * 0.04),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
