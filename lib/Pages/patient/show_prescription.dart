import 'package:dynamic_doctor/Pages/patient/CallHistory.dart';
import 'package:dynamic_doctor/Pages/patient/Chat_Support.dart';
import 'package:dynamic_doctor/Pages/patient/home.dart';
import 'package:dynamic_doctor/Pages/patient/settings.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:dynamic_doctor/widgets/drawer_patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowPrescription extends StatefulWidget {
  final String url;
  const ShowPrescription({Key? key, required this.url}) : super(key: key);

  @override
  _ShowPrescriptionState createState() => _ShowPrescriptionState();
}

class _ShowPrescriptionState extends State<ShowPrescription>
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
    return Scaffold(
      drawer: Drawers(),
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
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ChatSupportScreen()));
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
      body: Center(
          child: Image.network(
        widget.url,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return const Center(
            child: CircularProgressIndicator(
              color: dark,
            ),
          );
        },
        fit: BoxFit.cover,
      )),
    );
  }
}
