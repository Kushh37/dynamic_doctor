import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_doctor/Pages/doctor/chat_support_d.dart';
import 'package:dynamic_doctor/Pages/doctor/doctor_call_history_appointment_screen.dart';
import 'package:dynamic_doctor/Pages/doctor/doctor_edit_profile_screen.dart';
import 'package:dynamic_doctor/Pages/doctor/settingd.dart';
import 'package:dynamic_doctor/utils/image_helper.dart';
import 'package:dynamic_doctor/widgets/drawer_doctor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class DocEditProfileScreen extends StatefulWidget {
  const DocEditProfileScreen({super.key});

  @override
  _DocEditProfileScreenState createState() => _DocEditProfileScreenState();
}

class _DocEditProfileScreenState extends State<DocEditProfileScreen>
    with SingleTickerProviderStateMixin {
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

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );
    _getDetails();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _expController = TextEditingController();
  final _specialityController = TextEditingController();
  final _infoController = TextEditingController();
  final _registrationController = TextEditingController();
  final _locationController = TextEditingController();
  final _feesController = TextEditingController();

  File? selectedFile;
  var doctorUrl;
  void _selectImageFromGallery(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
        context: context,
        cropStyle: CropStyle.rectangle,
        title: 'Product Image');
    if (pickedFile != null) {
      setState(() {
        selectedFile = pickedFile;
      });
    } else {}
  }

  void _selectImageFromCamera(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromCamera(
        context: context,
        cropStyle: CropStyle.rectangle,
        title: 'Product Image');
    if (pickedFile != null) {
      setState(() {
        selectedFile = pickedFile;
      });
    } else {}
  }

  Future<void> _getDetails() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;
    String userdoc = user!.uid;

    FirebaseFirestore.instance
        .collection("DOCTORS")
        .doc(userdoc)
        .snapshots()
        .listen((event) {
      setState(() {
        _nameController.text = event.get("name").toString();

        _emailController.text = event.get("email").toString();
        _infoController.text = event.get("fullInfo").toString();
        _specialityController.text = event.get("speciality").toString();
        _registrationController.text = event.get("registration").toString();
        _expController.text = event.get("fullExperience").toString();
        _locationController.text = event.get("location").toString();
        _feesController.text = event.get("price").toString();
        doctorUrl = event.get("profileUrl").toString();
        _stateType = event.get("status").toString();
      });
    });
  }

  Future<void> _sendData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;

    await FirebaseFirestore.instance.collection("DOCTORS").doc(userdoc).set(
      {
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "fullInfo": _infoController.text.trim(),
        "speciality": _specialityController.text.trim(),
        "registration": _registrationController.text.trim(),
        "fullExperience": _expController.text.trim(),
        "location": _locationController.text.trim(),
        "status": _stateType,
        "type": "DOCTOR",
        // "profileUrl": imageUrl,
      },
      SetOptions(merge: true),
    );
    await FirebaseFirestore.instance
        .collection("Doctor")
        .doc(_specialityController.text)
        .collection("DOCTORS")
        .doc(userdoc)
        .set(
      {
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "fullInfo": _infoController.text.trim(),
        "speciality": _specialityController.text.trim(),
        "registration": _registrationController.text.trim(),
        "fullExperience": _expController.text.trim(),
        "type": "DOCTOR",
        "status": _stateType,
        "location": _locationController.text.trim(),
        // "profileUrl": imageUrl,
      },
      SetOptions(merge: true),
    );
  }

  var _stateType;
  final List<String> _statetype = <String>[
    'AVAILABLE',
    'AWAY',
  ];

  Widget selectState(height, width) {
    return Container(
      // margin: EdgeInsets.fromLTRB(width * 0.06, 0.0, width * 0.06, 0.0),
      decoration: BoxDecoration(
          color: dark.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.transparent, width: 1)),
      padding: EdgeInsets.fromLTRB(
          width * 0.025, height * 0.005, width * 0.017, height * 0.005),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                dropdownColor: Colors.grey[100],
                items: _statetype
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
                    _stateType = selectedtype;
                  });
                },
                value: _stateType,
                hint: Text(
                  "Select Your Type",
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
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
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(height: height * 0.20, color: Colors.white12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.04),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // _showPicker(context);
                              },
                              child: selectedFile != null
                                  ? Container(
                                      height: width * 0.3,
                                      width: width * 0.3,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: lightgrey,
                                          image: DecorationImage(
                                              fit: BoxFit.contain,
                                              image: FileImage(selectedFile!,
                                                  scale: 5))),
                                      child: null,
                                    )
                                  : Container(
                                      height: width * 0.3,
                                      width: width * 0.3,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: lightgrey),
                                      child: doctorUrl != null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: lightgrey,
                                                  image: DecorationImage(
                                                      fit: BoxFit.contain,
                                                      image: NetworkImage(
                                                          doctorUrl))),
                                              child: null)
                                          : Icon(
                                              CupertinoIcons.person_alt,
                                              size: width * 0.2,
                                            ),
                                    ),
                            ),
                            SizedBox(
                              height: height * 0.05,
                            ),
                            TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: dark,
                                  fontSize: width * 0.04),
                              decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w600,
                                    color: dark,
                                    fontSize: height * 0.025),
                                prefixIcon: const Icon(
                                  CupertinoIcons.person,
                                  color: purple,
                                ),
                                filled: true,
                                fillColor: dark.withOpacity(0.1),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusColor: purple,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: lightpurple, width: 2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Colors.white),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            TextFormField(
                              enabled: false,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: dark,
                                  fontSize: width * 0.04),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w600,
                                    color: dark,
                                    fontSize: height * 0.025),
                                prefixIcon: const Icon(
                                  CupertinoIcons.mail,
                                  color: purple,
                                ),
                                filled: true,
                                fillColor: dark.withOpacity(0.1),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusColor: purple,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: lightpurple, width: 2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Colors.white),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            TextFormField(
                              maxLines: 2,
                              controller: _infoController,
                              keyboardType: TextInputType.name,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: dark,
                                  fontSize: width * 0.04),
                              decoration: InputDecoration(
                                labelText: 'Info',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w600,
                                    color: dark,
                                    fontSize: height * 0.025),
                                prefixIcon: const Icon(
                                  CupertinoIcons.location_north_line,
                                  color: purple,
                                ),
                                filled: true,
                                fillColor: dark.withOpacity(0.1),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusColor: purple,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: lightpurple, width: 2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Colors.white),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            TextFormField(
                              controller: _specialityController,
                              keyboardType: TextInputType.text,
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: dark,
                                  fontSize: width * 0.04),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  CupertinoIcons.book_circle,
                                  color: purple,
                                ),
                                labelText: 'Speciality',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.bold,
                                    color: dark,
                                    fontSize: width * 0.04),
                                filled: true,
                                fillColor: dark.withOpacity(0.1),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusColor: purple,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: lightpurple, width: 2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            TextFormField(
                              controller: _registrationController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: dark,
                                  fontSize: width * 0.04),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  CupertinoIcons.number,
                                  color: purple,
                                ),
                                labelText: 'registration Number',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.bold,
                                    color: dark,
                                    fontSize: width * 0.04),
                                filled: true,
                                fillColor: dark.withOpacity(0.1),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusColor: purple,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: lightpurple, width: 2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            TextFormField(
                              controller: _expController,
                              keyboardType: TextInputType.text,
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: dark,
                                  fontSize: width * 0.04),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  CupertinoIcons.arrow_clockwise_circle,
                                  color: purple,
                                ),
                                labelText: 'Experience',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.bold,
                                    color: dark,
                                    fontSize: width * 0.04),
                                filled: true,
                                fillColor: dark.withOpacity(0.1),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusColor: purple,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: lightpurple, width: 2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            TextFormField(
                              controller: _locationController,
                              keyboardType: TextInputType.text,
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: dark,
                                  fontSize: width * 0.04),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  CupertinoIcons.location,
                                  color: purple,
                                ),
                                labelText: 'Location',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.bold,
                                    color: dark,
                                    fontSize: width * 0.04),
                                filled: true,
                                fillColor: dark.withOpacity(0.1),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusColor: purple,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: lightpurple, width: 2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            TextFormField(
                              enabled: false,
                              controller: _feesController,
                              keyboardType: TextInputType.text,
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: dark,
                                  fontSize: width * 0.04),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  CupertinoIcons.money_dollar,
                                  color: purple,
                                ),
                                labelText: 'My Fees',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.bold,
                                    color: dark,
                                    fontSize: width * 0.04),
                                filled: true,
                                fillColor: dark.withOpacity(0.1),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusColor: purple,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: lightpurple, width: 2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            selectState(height, width),
                            SizedBox(height: height * 0.01),
                            Container(
                              margin: EdgeInsets.only(
                                  left: width * 0.2, right: width * 0.2),
                              width: width * 0.4,
                              height: width * 0.12,
                              child: MaterialButton(
                                  elevation: 0.0,
                                  color: lightpurple.withOpacity(0.6),
                                  onPressed: () async {
                                    _sendData();
                                    //   FirebaseFirestore.instance
                                    //     .collection('USERS')
                                    //     .doc()
                                    //     .set({
                                    //   "name": _nameController.text,
                                    //   "email": _emailController.text,
                                    //   "phone_number": _phoneController.text,
                                    // }, SetOptions(merge: true));

                                    // Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             DoctorNavScreen()));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("saved")));
                                    // Navigator.of(context).push(
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             DocEditProfileScreen()));
                                  },
                                  child: Text(
                                    'Save',
                                    style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        fontSize: height * 0.025),
                                  )),
                            ),
                            SizedBox(height: height * 0.1),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KFormField extends StatelessWidget {
  final TextInputType textInputType;
  final Widget icon;
  final String text;

  final TextEditingController controller;

  const KFormField({
    Key? key,
    required this.textInputType,
    required this.icon,
    required this.text,
    required this.controller,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      style: GoogleFonts.ptSans(
          textStyle: GoogleFonts.ptSans(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      )),
      decoration: InputDecoration(
        prefixIcon: icon,
        labelStyle: GoogleFonts.nunito(color: Colors.black26),
        labelText: text,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: lightpurple)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: lightpurple)),
      ),
    );
  }
}
