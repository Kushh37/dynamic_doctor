import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_doctor/Pages/doctor/chat_support_d.dart';
import 'package:dynamic_doctor/Pages/doctor/doctor_call_history_appointment_screen.dart';
import 'package:dynamic_doctor/Pages/doctor/doctor_edit_profile_screen.dart';
import 'package:dynamic_doctor/Pages/doctor/settingd.dart';
import 'package:dynamic_doctor/Services/storage_provider.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:dynamic_doctor/utils/image_helper.dart';
import 'package:dynamic_doctor/widgets/drawer_doctor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadPrescription extends StatefulWidget {
  final String patientId;
  final String patientEmail;
  final String bookingId;
  final String type;
  final String doctorId;
  final String doctorSpeciality;

  const UploadPrescription(
      {Key? key,
      required this.patientId,
      required this.patientEmail,
      required this.type,
      required this.doctorId,
      required this.doctorSpeciality,
      required this.bookingId})
      : super(key: key);

  @override
  _UploadPrescriptionState createState() => _UploadPrescriptionState();
}

class _UploadPrescriptionState extends State<UploadPrescription>
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
    // getfuid();
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

  Future<void> addItem() async {
    final CollectionReference mainCollection =
        FirebaseFirestore.instance.collection('BOOKING');
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userdoc = user!.uid;

    final CollectionReference mainCollection2 = FirebaseFirestore.instance
        .collection('USERS')
        .doc(widget.patientId)
        .collection("BOOKINGS");
    final CollectionReference mainCollection4 = FirebaseFirestore.instance
        .collection('AGENTS')
        .doc(widget.patientId)
        .collection("BOOKINGS");
    final CollectionReference mainCollection3 = FirebaseFirestore.instance
        .collection('DOCTORS')
        .doc(userdoc)
        .collection("BOOKINGS");

    // DocumentReference documentReferencer =
    //     _mainCollection.doc(userdoc).collection('PRESCRIPTION').doc();

    StorageProvider storageProvider =
        StorageProvider(firebaseStorage: FirebaseStorage.instance);
    String imageUrl = await storageProvider.uploadPrescriptionBookingImage(
        image: selectedFile);

    Map<String, dynamic> data = <String, dynamic>{
      "prescriptionUrl": imageUrl,
      "prescriptionStatus": "Uploaded",
      "prescriptionType": "upload",
      "status": "completed",
    };
    await FirebaseFirestore.instance
        .collection("DOCTORS")
        .doc(widget.doctorId)
        .set({"bookingStatus": "unbooked"}, SetOptions(merge: true));
    await FirebaseFirestore.instance
        .collection("Doctor")
        .doc(widget.doctorSpeciality)
        .collection("DOCTORS")
        .doc(widget.doctorId)
        .set({"bookingStatus": "unbooked"}, SetOptions(merge: true));

    if (widget.type == "PATIENT") {
      await mainCollection
          .doc(widget.bookingId)
          .set(data, SetOptions(merge: true))
          .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Prescription Added Successfully.'))))
          .catchError((e) => print(e));
      await mainCollection2
          .doc(widget.bookingId)
          .set(data, SetOptions(merge: true))
          .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Prescription Added Successfully.'))))
          .catchError((e) => print(e));
      await mainCollection3
          .doc(widget.bookingId)
          .set(data, SetOptions(merge: true))
          .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Prescription Added Successfully.'))))
          .catchError((e) => print(e));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const DoctorCallHistoryAppointmentScreen()),
          (route) => false);
    } else if (widget.type == "AGENT") {
      await mainCollection
          .doc(widget.bookingId)
          .set(data, SetOptions(merge: true))
          .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Prescription Added Successfully.'))))
          .catchError((e) => print(e));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const DoctorCallHistoryAppointmentScreen()),
          (route) => false);
      await mainCollection4
          .doc(widget.bookingId)
          .set(data, SetOptions(merge: true))
          .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Prescription Added Successfully.'))))
          .catchError((e) => print(e));
      await mainCollection3
          .doc(widget.bookingId)
          .set(data, SetOptions(merge: true))
          .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Prescription Added Successfully.'))))
          .catchError((e) => print(e));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const DoctorCallHistoryAppointmentScreen()),
          (route) => false);
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
                "Prescription",
                style: TextStyle(
                    color: dark,
                    fontSize: height * 0.05,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: height * 0.025),
            Container(
              margin: EdgeInsets.only(left: width * 0.08),
              alignment: Alignment.centerLeft,
              child: Text(
                "Capture and upload your Prescription",
                style: TextStyle(
                    color: dark,
                    fontSize: height * 0.025,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: height * 0.1),
            Container(
              margin: EdgeInsets.only(left: width * 0.08),
              alignment: Alignment.centerLeft,
              child: Text(
                "Upload your prescription in image, doc, pdf format only",
                style: TextStyle(
                    color: dark,
                    fontSize: height * 0.017,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: height * 0.02),
            selectedFile != null
                ? Padding(
                    padding:
                        EdgeInsets.only(left: width * 0.1, right: width * 0.1),
                    child: Center(
                      child: Image.asset(
                        "assets/success.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                : Padding(
                    padding:
                        EdgeInsets.only(left: width * 0.1, right: width * 0.1),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(20.0),
                      color: grey,
                      strokeWidth: 2.0,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.06, bottom: height * 0.06),
                        child: GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: Column(
                            children: [
                              Center(
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      "assets/dot.png",
                                      height: height * 0.12,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width * 0.055,
                                          top: height * 0.021),
                                      child: Image.asset(
                                        "assets/folder (1).png",
                                        height: height * 0.07,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height * 0.02),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Scan | Capture | Upload",
                                  style: TextStyle(
                                      color: dark,
                                      fontSize: height * 0.017,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: height * 0.04),
            Container(
              margin: EdgeInsets.only(left: width * 0.12, right: width * 0.12),
              width: width * 0.4,
              height: width * 0.12,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(dark)),
                  onPressed: () {
                    if (selectedFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please Upload')));
                    } else {
                      addItem();
                    }
                  },
                  child: Text(
                    'Submit',
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                    ),
                  )),
            ),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }
}
