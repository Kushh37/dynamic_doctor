import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_doctor/Pages/patient/CallHistory.dart';
import 'package:dynamic_doctor/Pages/patient/Chat_Support.dart';

import 'package:dynamic_doctor/Pages/patient/home.dart';
import 'package:dynamic_doctor/Pages/patient/settings.dart';
import 'package:dynamic_doctor/Services/storage_provider.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:dynamic_doctor/utils/image_helper.dart';
import 'package:dynamic_doctor/widgets/drawer_patient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
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
    _getDetails();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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

  String _profileUrl = "";

  Future<void> _getDetails() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;
    String userdoc = user!.uid;

    FirebaseFirestore.instance
        .collection("USERS")
        .doc(userdoc)
        .snapshots()
        .listen((event) {
      setState(() {
        _nameController.text = event.get("name").toString();

        _emailController.text = event.get("email").toString();
        _phoneController.text = event.get("phone").toString();
        _genderValue = event.get("gender").toString();
        _ageController.text = event.get("age").toString();
        _addressController.text = event.get("address").toString();
        _profileUrl = event.get("profileUrl").toString();
      });
    });
  }

  Future<void> _sendData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;
    if (selectedFile != null) {
      StorageProvider storageProvider =
          StorageProvider(firebaseStorage: FirebaseStorage.instance);
      String imageUrl =
          await storageProvider.uploadPatientImage(image: selectedFile);
      await FirebaseFirestore.instance.collection("USERS").doc(userdoc).set({
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "gender": _genderValue.toString(),
        "age": _ageController.text.trim(),
        "type": "PATIENT",
        "address": _addressController.text.trim(),
        "profileUrl": imageUrl,
      });
    } else {
      await FirebaseFirestore.instance.collection("USERS").doc(userdoc).set({
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "gender": _genderValue.toString(),
        "age": _ageController.text.trim(),
        "type": "PATIENT",
        "address": _addressController.text.trim(),
        "profileUrl": _profileUrl,
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _genderValue;
  final List<String> _genderType = <String>[
    'Male',
    'Female',
    'Others',
  ];
  Widget selectGender(height, width) {
    return Container(
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
                items: _genderType
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
                    _genderValue = selectedtype;
                  });
                },
                value: _genderValue,
                hint: Text(
                  "Gender",
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

  File? selectedFile;

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

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _selectImageFromGallery(context);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _selectImageFromCamera(context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    LanguageController languageController = context.read<LanguageController>();
    context.watch<LanguageController>();

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
          backgroundColor: Colors.transparent,
          drawer: Drawers(),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: dark),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            title: CustomTitle(
                langHindi: false,
                languageController: languageController,
                width: width,
                height: height),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const ChatSupportScreen()));
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
              unselectedLabelColor: grey,
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
                        builder: (context) => PatientSettings(),
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
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(height: height * 0.20, color: Colors.white12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: selectedFile == null
                          ? Container(
                              height: width * 0.3,
                              width: width * 0.3,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: lightgrey),
                              child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: lightgrey,
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: NetworkImage(_profileUrl))),
                                  child: null))
                          : Container(
                              height: width * 0.3,
                              width: width * 0.3,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: lightgrey,
                                  image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image:
                                          FileImage(selectedFile!, scale: 5))),
                              child: null,
                            ),
                    ),
                    SizedBox(height: width * 0.1),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height * 0.01,
                              ),
                              TextFormField(
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: dark,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    CupertinoIcons.person,
                                    color: purple,
                                  ),
                                  labelText: 'Full_Name'.tr(),
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
                                controller: _emailController,
                                keyboardType: TextInputType.text,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: dark,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    CupertinoIcons.mail,
                                    color: purple,
                                  ),
                                  labelText: 'Email'.tr(),
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
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: dark,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    CupertinoIcons.phone,
                                    color: purple,
                                  ),
                                  labelText: 'Phone_No'.tr(),
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
                              selectGender(height, width),
                              SizedBox(height: height * 0.01),
                              TextFormField(
                                controller: _ageController,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: dark,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.male,
                                    color: purple,
                                  ),
                                  labelText: 'Age'.tr(),
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
                                maxLines: 2,
                                controller: _addressController,
                                keyboardType: TextInputType.text,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: dark,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    CupertinoIcons.house,
                                    color: purple,
                                  ),
                                  labelText: 'Address'.tr(),
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
                              SizedBox(height: height * 0.05),
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

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text("Saved")));

                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => Home()));
                                    },
                                    child: Text(
                                      'Save'.tr(),
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          fontSize: height * 0.025),
                                    )),
                              ),
                              SizedBox(height: height * 0.1),
                            ],
                          )),
                    )
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
