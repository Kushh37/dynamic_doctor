import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_doctor/Pages/auth/login/login.dart';
import 'package:dynamic_doctor/Pages/doctor/doctor_call_history_appointment_screen.dart';
import 'package:dynamic_doctor/Pages/doctor/doctor_edit_profile_screen.dart';
import 'package:dynamic_doctor/Pages/doctor/doctor_editprofile.dart';
import 'package:dynamic_doctor/Pages/doctor/prescriptions/uploaded_prescription.dart';
import 'package:dynamic_doctor/Services/auth_provider.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Drawerd extends StatefulWidget {
  const Drawerd({Key? key}) : super(key: key);

  @override
  _DrawerdState createState() => _DrawerdState();
}

class _DrawerdState extends State<Drawerd> {
  String _name = "";
  String _profileUrl = "";
  Future<void> _getData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;
    FirebaseFirestore.instance
        .collection("DOCTORS")
        .doc(userdoc)
        .snapshots()
        .listen((event) {
      setState(() {
        _name = event.get("name").toString();
        _profileUrl = event.get("profileUrl").toString();
      });
    });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      width: width * 0.8,
      color: Colors.white,
      child: ListView(
        children: [
          ListTile(
            leading: Container(
              height: width * 0.2,
              width: width * 0.2,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: NetworkImage(_profileUrl))),
              padding: EdgeInsets.only(top: height * 0.01),
              // child: Image.asset(
              //   "assets/profile.png",
              //   width: width * 0.2,
              // ),
            ),
            title: Text(
              _name.toString(),
              style: GoogleFonts.lato(
                  color: grey4,
                  fontWeight: FontWeight.w700,
                  fontSize: height * 0.03),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.045),
          GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => const DoctorEditProfileScreen()));
              },
              child: _listTile(height, width, "home", "Home")),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.02),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const DocEditProfileScreen()));
              },
              child: _listTile(height, width, "edit-profile", "Edit Profile")),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.02),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        const DoctorCallHistoryAppointmentScreen()));
              },
              child: _listTile(height, width, "call", "Call History")),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.02),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const UploadedPrescription()));
            },
            child: _listTile(
                height, width, "prescription (1)", "Uploaded Prescriptions"),
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          // SizedBox(height: height * 0.02),
          // _listTile(height, width, "setting", "Settings"),
          // Padding(
          //   padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
          //   child: Divider(
          //     color: Colors.grey[500],
          //   ),
          // ),
          SizedBox(height: height * 0.02),
          GestureDetector(
              onTap: () {
                AuthClass().logOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: _listTile(height, width, "logout", "Logout")),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.02),
        ],
      ),
    );
  }

  Widget _listTile(height, width, String image, String title) {
    return Row(
      children: [
        SizedBox(
          width: width * 0.03,
        ),
        Image.asset(
          "assets/$image.png",
          width: width * 0.045,
        ),
        SizedBox(
          width: width * 0.037,
        ),
        Text(
          title,
          style: GoogleFonts.lato(
              color: grey4,
              fontWeight: FontWeight.w700,
              fontSize: height * 0.024),
        ),
      ],
    );
  }
}
