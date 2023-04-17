import 'package:dynamic_doctor/Pages/doctor/chat_support_d.dart';
import 'package:dynamic_doctor/Pages/doctor/doctor_call_history_appointment_screen.dart';
import 'package:dynamic_doctor/Pages/doctor/doctor_edit_profile_screen.dart';
import 'package:dynamic_doctor/Pages/doctor/prescriptions/upload_prescription.dart';
import 'package:dynamic_doctor/Pages/doctor/settingd.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:dynamic_doctor/widgets/drawer_doctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class GeneratePres extends StatefulWidget {
  final String patientId;
  final String patientEmail;
  final String bookingId;
  final String doctorId;
  final String type;
  final String doctorSpeciality;

  const GeneratePres(
      {Key? key,
      required this.patientId,
      required this.patientEmail,
      required this.bookingId,
      required this.type,
      required this.doctorSpeciality,
      required this.doctorId})
      : super(key: key);

  @override
  _GeneratePresState createState() => _GeneratePresState();
}

class _GeneratePresState extends State<GeneratePres>
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
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
        backgroundColor: Colors.transparent,
        body: ListView(
          children: [
            SizedBox(height: height * 0.04),
            Image.asset(
              "assets/prescription (1).png",
              height: height * 0.12,
            ),
            SizedBox(height: height * 0.07),
            Container(
              margin: EdgeInsets.only(left: width * 0.08),
              alignment: Alignment.centerLeft,
              child: Text(
                "Generate Prescription",
                style: TextStyle(
                    color: dark,
                    fontSize: height * 0.05,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: height * 0.025),
            Container(
              margin: EdgeInsets.only(left: width * 0.1),
              alignment: Alignment.centerLeft,
              child: Text(
                "Upload or write your Prescription",
                style: TextStyle(
                    color: dark,
                    fontSize: height * 0.025,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: height * 0.2),
            GestureDetector(
              // onTap: () {
              //   Navigator.of(context).push(
              //       MaterialPageRoute(builder: (context) => UploadPres()));
              // },
              child: Container(
                margin: EdgeInsets.only(left: width * 0.2, right: width * 0.2),
                width: width * 0.4,
                height: width * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: lightpurple.withOpacity(0.4),
                ),
                child: MaterialButton(
                  elevation: 0.0,
                  color: Colors.transparent,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UploadPrescription(
                              doctorId: widget.doctorId,
                              doctorSpeciality: widget.doctorSpeciality,
                              type: widget.type,
                              bookingId: widget.bookingId,
                              patientEmail: widget.patientEmail,
                              patientId: widget.patientId,
                            )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/folder (1).png",
                        height: height * 0.03,
                      ),
                      SizedBox(width: width * 0.02),
                      Text(
                        'Upload',
                        style: GoogleFonts.raleway(
                          color: dark,
                          fontWeight: FontWeight.w700,
                          fontSize: height * 0.023,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
