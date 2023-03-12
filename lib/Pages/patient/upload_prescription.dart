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
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class UploadPres extends StatefulWidget {
  const UploadPres({Key? key}) : super(key: key);

  @override
  _UploadPresState createState() => _UploadPresState();
}

class _UploadPresState extends State<UploadPres>
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

  Future<void> addItem() async {
    final CollectionReference mainCollection =
        FirebaseFirestore.instance.collection('PRESCRIPTION');
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userdoc = user!.uid;

    // DocumentReference documentReferencer =
    //     _mainCollection.doc(userdoc).collection('PRESCRIPTION').doc();

    StorageProvider storageProvider =
        StorageProvider(firebaseStorage: FirebaseStorage.instance);
    String imageUrl =
        await storageProvider.uploadPrescriptionImage(image: selectedFile);

    Map<String, dynamic> data = <String, dynamic>{
      "userId": userdoc,
      "name": _name,
      "orderDate":
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      "url": imageUrl,
      "status": "pending",
    };

    await mainCollection.doc().set(data).whenComplete(() {
      setState(() {
        isLoading = false;
      });
      _showBottomWhenDone(context);
      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Prescription Added Successfully.')));
    }).catchError((e) => print(e));

    // Navigator.pushAndRemoveUntil(context,
    //     MaterialPageRoute(builder: (context) => MyPres()), (route) => false);
  }

  void _showBottomWhenDone(BuildContext ctx) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Prescription Added Successfully!",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.12,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(dark)),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const Home()),
                                (route) => false);
                          },
                          child: Text(
                            'Done',
                            style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                            ),
                          )),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.12,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(dark)),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const UploadPres()),
                                (route) => false);
                          },
                          child: Text(
                            'Add another one',
                            style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    LanguageController languageController = context.read<LanguageController>();
    context.watch<LanguageController>();
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
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const Home()));
                  },
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
        key: _scaffoldKey,
        drawer: Drawers(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: dark),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          // leading: new IconButton(
          //   icon: new Icon(Icons.menu, color: grey4),
          //   onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          // ),
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
                "Prescription".tr(),
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
                "Capture_and_upload_your_Prescription".tr(),
                style: TextStyle(
                    color: dark,
                    fontSize: height * 0.025,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: height * 0.05),
            Container(
              margin: EdgeInsets.only(left: width * 0.08),
              alignment: Alignment.centerLeft,
              child: Text(
                "Upload_your_prescription_in_image_doc_pdf_format_only".tr(),
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
                                  "Scan_Capture_Upload".tr(),
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
                      setState(() {
                        isLoading = true;
                      });
                      addItem();
                    }
                  },
                  child: isLoading == true
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Submit'.tr(),
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

  Widget _listTile(height, width, String image, String title) {
    return Row(
      children: [
        SizedBox(
          width: width * 0.03,
        ),
        Image.asset(
          "assets/$image.png",
          width: width * 0.046,
        ),
        SizedBox(
          width: width * 0.04,
        ),
        Text(
          "$title",
          style: GoogleFonts.lato(
              color: grey4,
              fontWeight: FontWeight.w700,
              fontSize: height * 0.024),
        ),
      ],
    );
  }
}
