// import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_doctor/Pages/booking_info.dart';
import 'package:dynamic_doctor/Pages/call.dart';
import 'package:dynamic_doctor/Pages/doctor/chat_support_d.dart';
import 'package:dynamic_doctor/Pages/doctor/doctor_edit_profile_screen.dart';
import 'package:dynamic_doctor/Pages/doctor/prescriptions/generate_prescription.dart';
import 'package:dynamic_doctor/Pages/doctor/settingd.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:dynamic_doctor/widgets/drawer_doctor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorCallHistoryAppointmentScreen extends StatefulWidget {
  const DoctorCallHistoryAppointmentScreen({Key? key}) : super(key: key);

  @override
  _DoctorCallHistoryAppointmentScreenState createState() =>
      _DoctorCallHistoryAppointmentScreenState();
}

class _DoctorCallHistoryAppointmentScreenState
    extends State<DoctorCallHistoryAppointmentScreen>
    with SingleTickerProviderStateMixin {
  var status = false;
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

  Stream<QuerySnapshot> _getBooking() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection("DOCTORS")
        .doc(userdoc)
        .collection("BOOKINGS");

    return mainCollection.snapshots();
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
        body: Stack(
          children: [
            Container(
              height: height,
              decoration: const BoxDecoration(
                color: lightpurple,
                image: DecorationImage(
                  image: AssetImage("assets/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: null,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              height: height,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: _getBooking(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        } else if (snapshot.hasData || snapshot.data != null) {
                          return ListView.separated(
                            separatorBuilder: (BuildContext context, index) {
                              return SizedBox(height: width * 0.02);
                            },
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              //String aaaa= snapshot.data!.docs.where((element) => false);
                              String patientName =
                                  snapshot.data!.docs[index]['patientName'];
                              String doctorId =
                                  snapshot.data!.docs[index]['doctorId'];
                              String patientId =
                                  snapshot.data!.docs[index]['patientId'];
                              String patientEmail =
                                  snapshot.data!.docs[index]['patientEmail'];
                              String patientAddress =
                                  snapshot.data!.docs[index]['city'];
                              String patientGender =
                                  snapshot.data!.docs[index]['gender'];
                              String symptoms =
                                  snapshot.data!.docs[index]['symptoms'];
                              String patientImage =
                                  snapshot.data!.docs[index]['patientImage'];

                              String doctorLocation =
                                  snapshot.data!.docs[index]['doctorLocation'];
                              String doctorSpeciality = snapshot
                                  .data!.docs[index]['doctorSpeciality'];

                              String bookingId = snapshot.data!.docs[index].id;

                              String doctorName =
                                  snapshot.data!.docs[index]['doctorName'];
                              String bookingDetails =
                                  snapshot.data!.docs[index]['bookingDetails'];

                              String url =
                                  snapshot.data!.docs[index]['doctorUrl'];
                              String prescriptionStatus = snapshot
                                  .data!.docs[index]['prescriptionStatus'];
                              String enableStatus =
                                  snapshot.data!.docs[index]['status'];
                              String type = snapshot.data!.docs[index]['type'];
                              String bookingType =
                                  snapshot.data!.docs[index]['bookingType'];
                              var totalAmount =
                                  snapshot.data!.docs[index]['totalAmount'];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ListTile(
                                      horizontalTitleGap: 0.0,
                                      contentPadding: EdgeInsets.zero,
                                      minVerticalPadding: 0.0,
                                      leading: Container(
                                        height: width * 0.23,
                                        width: width * 0.23,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          CupertinoIcons.person_alt,
                                          color: dark,
                                          size: width * 0.1,
                                        ),
                                      ),
                                      title: Text(
                                        patientName,
                                        style: GoogleFonts.raleway(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            color: dark),
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Icon(
                                            Icons.pin_drop,
                                            color: dark,
                                            size: width * 0.04,
                                          ),
                                          Text(
                                            patientAddress,
                                            style: GoogleFonts.raleway(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: dark),
                                          ),
                                          SizedBox(
                                            width: width * 0.02,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (enableStatus == "inactive" ||
                                                  enableStatus == "unpaid") {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BookingInfo(
                                                              patientImage:
                                                                  patientImage,
                                                              patientName:
                                                                  patientName,
                                                              patientAddress:
                                                                  patientAddress,
                                                              patientGender:
                                                                  patientGender,
                                                              doctorName:
                                                                  doctorName,
                                                              doctorLocation:
                                                                  doctorLocation,
                                                              doctorSpeciality:
                                                                  doctorSpeciality,
                                                              bookingDetails:
                                                                  bookingDetails,
                                                              bookingId:
                                                                  bookingId,
                                                              symptoms:
                                                                  symptoms,
                                                              url: url,
                                                            )));
                                              } else if (enableStatus ==
                                                      "active" ||
                                                  enableStatus == "paid" ||
                                                  (prescriptionStatus ==
                                                          "Pending" &&
                                                      enableStatus ==
                                                          "completed")) {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            GeneratePres(
                                                                doctorSpeciality:
                                                                    doctorSpeciality,
                                                                patientId:
                                                                    patientId,
                                                                patientEmail:
                                                                    patientEmail,
                                                                bookingId:
                                                                    bookingId,
                                                                type: type,
                                                                doctorId:
                                                                    doctorId)));
                                              } else {
                                                print("no route");
                                              }
                                            },
                                            child: Text(
                                              enableStatus == "inactive"
                                                  ? "View Details"
                                                  : (enableStatus == "paid" &&
                                                              prescriptionStatus ==
                                                                  "Pending") ||
                                                          (prescriptionStatus ==
                                                                  "Pending" &&
                                                              enableStatus ==
                                                                  "paid") ||
                                                          enableStatus ==
                                                              "active"
                                                      ? "Upload Prescription"
                                                      : enableStatus == "unpaid"
                                                          ? ""
                                                          : (enableStatus ==
                                                                      "completed" &&
                                                                  prescriptionStatus ==
                                                                      "Uploaded")
                                                              ? "Prescription Uploaded"
                                                              : "",
                                              style: GoogleFonts.raleway(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: dark),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: enableStatus == "completed"
                                          ? Text(
                                              "Completed",
                                              style: GoogleFonts.raleway(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: dark),
                                            )
                                          : enableStatus == "unpaid"
                                              ? SizedBox(
                                                  width: width * 0.2,
                                                  child: IconButton(
                                                    iconSize: width * 0.1,
                                                    onPressed: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("DOCTORS")
                                                          .doc(doctorId)
                                                          .set(
                                                              {
                                                            "status": "AWAY",
                                                          },
                                                              SetOptions(
                                                                  merge: true));
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("Doctor")
                                                          .doc(doctorSpeciality)
                                                          .collection("DOCTORS")
                                                          .doc(doctorId)
                                                          .set(
                                                              {
                                                            "status": "AWAY",
                                                          },
                                                              SetOptions(
                                                                  merge: true));
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return CallPage(
                                                          bookingType:
                                                              bookingType,
                                                          price: totalAmount,
                                                          type: type,
                                                          doctorId: doctorId,
                                                          bookingId: bookingId,
                                                          patientEmail:
                                                              patientEmail,
                                                          patientid: patientId,
                                                          route: "doctorCall",
                                                          doctorName:
                                                              doctorName,
                                                          doctorSpeciality:
                                                              doctorSpeciality,
                                                          patientCity:
                                                              patientAddress,
                                                          patientName:
                                                              patientName,
                                                          bookingDetails:
                                                              bookingDetails,
                                                        );
                                                      }));
                                                    },
                                                    icon: Container(
                                                      width: width * 0.2,
                                                      height: width * 0.2,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration:
                                                          const BoxDecoration(
                                                              color:
                                                                  Colors.green,
                                                              shape: BoxShape
                                                                  .circle),
                                                      child: Icon(
                                                        CupertinoIcons
                                                            .video_camera,
                                                        color: Colors.white,
                                                        size: width * 0.08,
                                                      ),
                                                    ),
                                                  ))
                                              : enableStatus == "active"
                                                  ? SizedBox(
                                                      width: width * 0.2,
                                                      child: IconButton(
                                                        iconSize: width * 0.1,
                                                        onPressed: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "DOCTORS")
                                                              .doc(doctorId)
                                                              .set(
                                                                  {
                                                                "status":
                                                                    "AWAY",
                                                              },
                                                                  SetOptions(
                                                                      merge:
                                                                          true));
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Doctor")
                                                              .doc(
                                                                  doctorSpeciality)
                                                              .collection(
                                                                  "DOCTORS")
                                                              .doc(doctorId)
                                                              .set(
                                                                  {
                                                                "status":
                                                                    "AWAY",
                                                              },
                                                                  SetOptions(
                                                                      merge:
                                                                          true));
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                            return CallPage(
                                                              bookingType:
                                                                  bookingType,
                                                              price:
                                                                  totalAmount,
                                                              type: type,
                                                              doctorId:
                                                                  doctorId,
                                                              bookingId:
                                                                  bookingId,
                                                              patientEmail:
                                                                  patientEmail,
                                                              patientid:
                                                                  patientId,
                                                              route: "doctor",
                                                              doctorName:
                                                                  doctorName,
                                                              doctorSpeciality:
                                                                  doctorSpeciality,
                                                              patientCity:
                                                                  patientAddress,
                                                              patientName:
                                                                  patientName,
                                                              bookingDetails:
                                                                  bookingDetails,
                                                            );
                                                          }));
                                                        },
                                                        icon: Container(
                                                          width: width * 0.2,
                                                          height: width * 0.2,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Colors
                                                                      .green,
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: Icon(
                                                            CupertinoIcons
                                                                .video_camera,
                                                            color: Colors.white,
                                                            size: width * 0.08,
                                                          ),
                                                        ),
                                                      ))
                                                  : enableStatus == "paid"
                                                      ? Text(
                                                          "Paid",
                                                          style: GoogleFonts
                                                              .raleway(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                  color: dark),
                                                        )
                                                      : SizedBox(
                                                          width: width * 0.2,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Switch(
                                                                activeColor:
                                                                    dark,
                                                                inactiveTrackColor:
                                                                    dark,
                                                                value: status,
                                                                onChanged:
                                                                    (val) {
                                                                  //setState(() {
                                                                  //status = val;
                                                                  print(
                                                                      "object : $status");
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "BOOKING")
                                                                      .doc(
                                                                          bookingId)
                                                                      .set({
                                                                    "status":
                                                                        "active"
                                                                  }, SetOptions(merge: true));
                                                                  type == "AGENT"
                                                                      ? FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "AGENTS")
                                                                          .doc(
                                                                              patientId)
                                                                          .collection(
                                                                              "BOOKINGS")
                                                                          .doc(
                                                                              bookingId)
                                                                          .set(
                                                                              {
                                                                              "status": "active"
                                                                            },
                                                                              SetOptions(
                                                                                  merge:
                                                                                      true))
                                                                      : FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "USERS")
                                                                          .doc(
                                                                              patientId)
                                                                          .collection(
                                                                              "BOOKINGS")
                                                                          .doc(
                                                                              bookingId)
                                                                          .set({
                                                                          "status":
                                                                              "active"
                                                                        }, SetOptions(merge: true));
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "DOCTORS")
                                                                      .doc(
                                                                          doctorId)
                                                                      .collection(
                                                                          "BOOKINGS")
                                                                      .doc(
                                                                          bookingId)
                                                                      .set({
                                                                    "status":
                                                                        "active"
                                                                  }, SetOptions(merge: true));
                                                                  //});
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                ],
                              );
                            },
                          );
                        }
                        return const CircularProgressIndicator(
                          color: dark,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
