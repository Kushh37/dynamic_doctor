import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_doctor/Pages/patient/Chat_Support.dart';
import 'package:dynamic_doctor/Pages/patient/settings.dart';
import 'package:dynamic_doctor/Services/storage_provider.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:dynamic_doctor/utils/image_helper.dart';
import 'package:dynamic_doctor/widgets/drawer_patient.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'CallHistory.dart';
import 'home.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );
    _getData();
  }

  String _name = "";

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

        print(_name);
      });
    });
  }

  Future<void> addItem() async {
    final CollectionReference mainCollection =
        FirebaseFirestore.instance.collection('REPORTS');
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userdoc = user!.uid;

    // DocumentReference documentReferencer =
    //     _mainCollection.doc(userdoc).collection('PRESCRIPTION').doc();

    StorageProvider storageProvider =
        StorageProvider(firebaseStorage: FirebaseStorage.instance);
    String imageUrl =
        await storageProvider.uploadReportImage(image: selectedFile);

    Map<String, dynamic> data = <String, dynamic>{
      "name": _name,
      "userId": userdoc,
      "userEmail": user.email,
      "message": messageController.text,
      "url": imageUrl,
      //"status": "pending",
    };

    await mainCollection.doc().set(data).whenComplete(() {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report Submitted Successfully.')));
    }).catchError((e) => print(e));

    Navigator.of(context).pop();
  }

  bool isLoading = false;
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
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
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
            backgroundColor: Colors.transparent,
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
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(width * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "REPORT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: dark,
                          fontSize: height * 0.03,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: width * 0.06),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.04,
                            right: width * 0.04,
                            // top: height * 0.01,
                          ),
                          child: TextFormField(
                            controller: messageController,
                            keyboardType: TextInputType.text,
                            cursorColor: lightpurple,
                            maxLines: 2,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                color: grey,
                                fontSize: height * 0.02),
                            decoration: InputDecoration(
                              labelText: 'Message',
                              labelStyle: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: grey,
                                  fontSize: height * 0.02),
                              fillColor: Colors.transparent.withOpacity(0.1),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: lightpurple),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusColor: purple,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: lightpurple, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 0, color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: width * 0.04),
                        Padding(
                          padding: EdgeInsets.only(
                              left: width * 0.04, right: width * 0.04),
                          child: GestureDetector(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10.0),
                              color: grey,
                              strokeWidth: 2.0,
                              child: SizedBox(
                                height: width * 0.15,
                                // padding: EdgeInsets.only(
                                //     top: height * 0.06, bottom: height * 0.06),
                                child: selectedFile != null
                                    ? Container(
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Icon(Icons.upload),
                                            SizedBox(width: width * 0.02),
                                            Text(
                                              "File Selected!",
                                              style: TextStyle(
                                                  color: dark,
                                                  fontSize: height * 0.02,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.upload),
                                            SizedBox(width: width * 0.02),
                                            Text(
                                              "Attach your Screenshot",
                                              style: TextStyle(
                                                  color: dark,
                                                  fontSize: height * 0.02,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: width * 0.04),
                        Container(
                          margin: EdgeInsets.only(
                              left: width * 0.12, right: width * 0.12),
                          width: width * 0.4,
                          height: width * 0.12,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(dark)),
                              onPressed: () {
                                // if (selectedFile == null) {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //       SnackBar(content: Text('Please Upload')));
                                // } else {
                                setState(() {
                                  isLoading = true;
                                });
                                addItem();
                                // }
                              },
                              child: isLoading == true
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      'Submit',
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 28,
                                      ),
                                    )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
