import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_doctor/Pages/patient/CallHistory.dart';
import 'package:dynamic_doctor/Pages/patient/Chat_Support.dart';
import 'package:dynamic_doctor/Pages/patient/settings.dart';
import 'package:dynamic_doctor/Pages/patient/show_prescription.dart';
import 'package:dynamic_doctor/Pages/patient/your_prescriptions.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:dynamic_doctor/widgets/drawer_patient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'patient/upload_prescription.dart';

class MyPres extends StatefulWidget {
  const MyPres({Key? key}) : super(key: key);

  @override
  _MyPresState createState() => _MyPresState();
}

class _MyPresState extends State<MyPres> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );

    readItems();
  }

  static Stream<QuerySnapshot> readItems() {
    final CollectionReference mainCollection =
        FirebaseFirestore.instance.collection('PRESCRIPTION');
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userdoc = user!.uid;

    // CollectionReference prescriptionCollection =
    //     _mainCollection.doc().snapshots();

    return mainCollection.where("userId", isEqualTo: userdoc).snapshots();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //String fuid = "";
  String url = "";
  var prescription = [];
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
    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: 'FoMlSB6ftQg',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
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
        bottomNavigationBar: SizedBox(
          height: width * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.2),
                //width: width * 0.5,
                height: width * 0.1,
                child: MaterialButton(
                  elevation: 0.0,
                  color: lightpink.withOpacity(0.3),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const UploadPres()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.add,
                        size: height * 0.035,
                        color: dark,
                      ),
                      SizedBox(width: width * 0.01),
                      Text(
                        'Add new Prescription',
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w800,
                            fontSize: height * 0.02,
                            color: dark),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Container(
                decoration: const BoxDecoration(
                  color: lightpurple,
                ),
                child: TabBar(
                  //unselectedLabelColor: grey,
                  controller: _tabController,
                  indicatorColor: lightpurple,
                  tabs: [
                    const Tab(
                      child: Icon(
                        Icons.home_outlined,
                        size: 30,
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
            ],
          ),
        ),
        key: _scaffoldKey,
        drawer: const Drawers(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: grey4),
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          ),
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
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      barrierLabel: "Barrier",
                      barrierDismissible: false,
                      // barrierColor: Colors.black.withOpacity(0.5),
                      transitionDuration: const Duration(milliseconds: 700),
                      context: context,
                      pageBuilder: (_, __, ___) {
                        return Container(
                          padding: EdgeInsets.only(
                              left: width * 0.02,
                              right: width * 0.02,
                              top: height * 0.04,
                              bottom: height * 0.04),
                          child: Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: StatefulBuilder(
                              builder: (BuildContext context, setState) {
                                return Container(
                                  color: Colors.black,
                                  height: height,
                                  width: width,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: height - height * 0.1,
                                          width: width,
                                          // padding:
                                          //     const EdgeInsets.all(12.0),
                                          child: YoutubePlayer(
                                            controller: controller,
                                            showVideoProgressIndicator: true,
                                            progressIndicatorColor:
                                                Colors.amber,
                                            onReady: () {},
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      transitionBuilder: (_, anim, __, child) {
                        return SlideTransition(
                          position: Tween(
                                  begin: const Offset(0, 1),
                                  end: const Offset(0, 0))
                              .animate(anim),
                          child: child,
                        );
                      },
                    );
                  },
                  child: Text(
                    'Help',
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w800,
                        fontSize: height * 0.017,
                        color: dark),
                  ),
                ),
                SizedBox(width: width * 0.01),
                Icon(
                  CupertinoIcons.question_circle,
                  color: dark,
                  size: height * 0.03,
                ),
                SizedBox(
                  width: width * 0.04,
                ),
              ],
            ),
            SizedBox(
              height: height * 0.55,
              child: StreamBuilder(
                  stream: readItems(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                          "You have no prescriptions yet",
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w800,
                              fontSize: height * 0.024,
                              color: dark),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          String docId = snapshot.data!.docs[index].id;

                          String status = snapshot.data!.docs[index]['status'];
                          String prescriptionUrl =
                              snapshot.data!.docs[index]['url'];

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: lightpink,
                            ),
                            margin: EdgeInsets.only(
                              left: width * 0.04,
                              // right: width * 0.04,
                            ),
                            // height: width * 0.7,
                            width: width * 0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  // alignment: Alignment.center,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),

                                  margin: EdgeInsets.only(
                                      left: width * 0.03,
                                      right: width * 0.03,
                                      top: height * 0.02),
                                  height: height * 0.4,
                                  width: width * 0.25,
                                  child: Image.network(
                                    prescriptionUrl,
                                    fit: BoxFit.contain,
                                    loadingBuilder: (BuildContext context,
                                        child,
                                        ImageChunkEvent? loadingProgress) {
                                      {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      }
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Container(
                                        alignment: Alignment.center,
                                        child: const CircularProgressIndicator(
                                          color: lightpink3,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                Container(
                                  alignment: Alignment.center,
                                  height: height * 0.05,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width * 0.02),
                                  // margin: EdgeInsets.only(
                                  //     left: width * 0.03, right: width * 0.03, top: height * 0.03),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: lightpurple.withOpacity(0.7),
                                  ),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (status == "medicine uploaded") {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      YourPrescription(
                                                          url: url,
                                                          docId: docId)));
                                        } else if (status == "pending") {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShowPrescription(
                                                          url:
                                                              prescriptionUrl)));
                                          // await ImageDownloader
                                          //     .downloadImage(
                                          //   url,
                                          //   destination:
                                          //       AndroidDestinationType
                                          //           .directoryDownloads
                                          //         ..subDirectory(
                                          //             "prescriptions.jpg"),
                                          // );
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //         content: Text(
                                          //             "Download Completed")));
                                        }
                                      },
                                      child: Text(
                                        status == "medicine uploaded"
                                            ? "Buy Now"
                                            : status == "paid"
                                                ? "Paid"
                                                : status == "Delivered"
                                                    ? "Delivered"
                                                    : 'Pending',
                                        style: GoogleFonts.raleway(
                                            fontWeight: FontWeight.w800,
                                            fontSize: height * 0.018,
                                            color: dark),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
            SizedBox(
              height: width * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
