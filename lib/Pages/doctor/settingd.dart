import 'package:dynamic_doctor/Pages/auth/login/login.dart';
import 'package:dynamic_doctor/Pages/doctor/chat_support_d.dart';
import 'package:dynamic_doctor/Pages/doctor/doctor_edit_profile_screen.dart';
import 'package:dynamic_doctor/Pages/patient/about_us.dart';
import 'package:dynamic_doctor/Pages/patient/privacy_policy.dart';
import 'package:dynamic_doctor/Pages/patient/refund_policy.dart';
import 'package:dynamic_doctor/Pages/patient/terms_and_condition.dart';
import 'package:dynamic_doctor/Pages/patient/contact_us.dart';
import 'package:dynamic_doctor/Pages/patient/report.dart';
import 'package:dynamic_doctor/Services/auth_provider.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:dynamic_doctor/widgets/drawer_doctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'doctor_call_history_appointment_screen.dart';

class SettingD extends StatefulWidget {
  const SettingD({Key? key}) : super(key: key);

  @override
  _SettingDState createState() => _SettingDState();
}

class _SettingDState extends State<SettingD>
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: lightpurple,
        ),
        child: TabBar(
          // unselectedLabelColor: grey,
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
                    builder: (context) => const SettingD(),
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
        // leading: new IconButton(
        //   icon: new Icon(Icons.menu, color: grey4),
        //   onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        // ),
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
      drawer: Drawerd(),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AboutUsScreen())),
              child: _tile(height, width, "About Us")),
          GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen())),
              child: _tile(height, width, "Privacy Policy")),
          GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TermsAndCondition())),
              child: _tile(height, width, "Terms & Condition")),
          GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RefundPolicyScreen())),
              child: _tile(height, width, "Refund Policy")),
          GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ContactUsScreen())),
              child: _tile(height, width, "Contact Us")),
          GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ReportScreen())),
              child: _tile(height, width, "Report")),
          SizedBox(
            height: height * 0.01,
          ),
          _buttons(height, width, "Delete Account", Colors.black),
          GestureDetector(
              onTap: () {
                AuthClass().logOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false);
              },
              child: _buttons(height, width, "Logout", Colors.red)),
          SizedBox(
            height: height * 0.02,
          ),
        ],
      ),
    );
  }

  Widget _buttons(height, width, String title, Color colour) {
    return Container(
      //margin: EdgeInsets.only(left: width * 0.07, right: width * 0.07),
      height: height * 0.07,
      //width: width * 0.4,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6.0))),
      child: Center(
          child: Text(
        title,
        style: TextStyle(
          color: colour,
          fontSize: height * 0.025,
          fontWeight: FontWeight.w700,
        ),
      )),
    );
  }

  Widget _tile(height, width, String title) {
    return SizedBox(
      height: height * 0.08,
      child: ListTile(
        tileColor: Colors.white,
        leading: Text(
          title,
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
            fontSize: height * 0.025,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: height * 0.03,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
