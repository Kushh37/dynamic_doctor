import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_doctor/Pages/auth/login/login.dart';
import 'package:dynamic_doctor/Pages/my_prescriptions.dart';

import 'package:dynamic_doctor/Pages/patient/CallHistory.dart';
import 'package:dynamic_doctor/Pages/patient/confirm_doctor.dart';

import 'package:dynamic_doctor/Pages/patient/home.dart';
import 'package:dynamic_doctor/Pages/patient/patient_editprofile.dart';
import 'package:dynamic_doctor/Pages/patient/prescription/previous_prescription.dart';
import 'package:dynamic_doctor/Pages/patient/settings.dart';
import 'package:dynamic_doctor/Services/auth_provider.dart';

import 'package:dynamic_doctor/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class Drawers extends StatefulWidget {
  const Drawers({
    Key? key,
  }) : super(key: key);

  @override
  _DrawersState createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  String _name = "";

  String? _profileUrl = "";
  Future<void> _getData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;
    FirebaseFirestore.instance
        .collection("USERS")
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
    context.watch<LanguageController>();
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
                  image: DecorationImage(
                      image: NetworkImage(
                    _profileUrl!,
                  ))),
              padding: EdgeInsets.only(top: height * 0.01),
              // child: Image.network(
              //   _photoUrl,
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
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Patient",
                style: GoogleFonts.lato(
                    color: grey4,
                    fontWeight: FontWeight.w500,
                    fontSize: height * 0.024),
              ),
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const Home()));
              },
              child: _listTile(height, width, "home", "Home".tr())),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.02),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => EditProfileScreen()));
              },
              child: _listTile(
                  height, width, "edit-profile", "Edit_Profile".tr())),
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
                    builder: (_) => const CallHistoryScreen()));
              },
              child: _listTile(height, width, "call", "Call_History".tr())),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.02),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ConfirmDoctor()));
              },
              child:
                  _listTile(height, width, "eye", "Send_Doctor_History".tr())),
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
                    builder: (_) => const CallHistoryScreen()));
              },
              child: _listTile(
                  height, width, "appointments", "Appointments".tr())),
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
                  builder: (_) => const PreviousPrescription()));
            },
            child: _listTile(height, width, "prescription (1)",
                "Previous_Prescriptions".tr()),
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.02),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const MyPres()));
            },
            child: _listTile(height, width, "prescription (1)",
                "Medicine_Order_History".tr()),
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.02),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PatientSettings()));
              },
              child: _listTile(height, width, "setting", "Settings".tr())),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.02),
          GestureDetector(
              onTap: () {
                AuthClass().logOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false);
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
