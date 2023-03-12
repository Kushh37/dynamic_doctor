import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_doctor/Pages/patient/Chat_Support.dart';
import 'package:dynamic_doctor/Pages/patient/home.dart';
import 'package:dynamic_doctor/Pages/patient/settings.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:dynamic_doctor/widgets/drawer_patient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCEMITransactionInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCShipmentInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'CallHistory.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String doctorUrl;
  final String doctorLocation;
  final String doctorSpeciality;
  final String bookedDateAndTime;
  final String registration;
  final double price;

  const CheckOutScreen(
      {Key? key,
      required this.doctorId,
      required this.price,
      required this.doctorName,
      required this.doctorUrl,
      required this.doctorLocation,
      required this.doctorSpeciality,
      required this.registration,
      required this.bookedDateAndTime})
      : super(key: key);

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static final GlobalKey<FormState> _formnKey = GlobalKey<FormState>();
  // var _paymenttype;
  // List<String> _paymentType = <String>[
  //   'Pay offline',
  //   "Pay Online"
  //   //'Instamojo',
  // ];
  var _gendertype;
  final List<String> _genderType = <String>[
    'Male',
    "Female",
    "Other",
    //'Instamojo',
  ];
  var status = true;

  String _name = "";
  String _email = "";

  Future<void> _getUserData() async {
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
        _email = event.get("email").toString();
        print(_name);
        print(_email);
      });
    });
  }

  Future<void> sslCommerzGeneralCall(price) async {
    Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
      //Use the ipn if you have valid one, or it will fail the transaction.
      //   ipn_url: "www.ipnurl.com",
      multi_card_name: 'visa,master,bkash',
      currency: SSLCurrencyType.BDT,
      product_category: "Consultancy",
      sdkType: SSLCSdkType.TESTBOX,
      store_id: 'mrhealerhslive',
      store_passwd: '61371C2BAF4AE37538',
      total_amount: price,
      tran_id: "1231321321321312",
    ));
    sslcommerz
        .addEMITransactionInitializer(
            sslcemiTransactionInitializer: SSLCEMITransactionInitializer(
                emi_options: 1, emi_max_list_options: 3, emi_selected_inst: 2))
        .addShipmentInfoInitializer(
            sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
                shipmentMethod: "yes",
                numOfItems: 5,
                shipmentDetails: ShipmentDetails(
                    shipAddress1: "Ship address 1",
                    shipCity: "Faridpur",
                    shipCountry: "Bangladesh",
                    shipName: "Ship name 1",
                    shipPostCode: "7860")))
        .addCustomerInfoInitializer(
            customerInfoInitializer: SSLCCustomerInfoInitializer(
                customerName: _nameController.text,
                customerEmail: _email,
                customerAddress1: _address1Controller.text,
                customerAddress2: _address2Controller.text,
                customerCity: _cityController.text,
                customerPostCode: _pinController.text,
                customerState: "Gujarat",
                customerCountry: "India",
                customerPhone: _phoneController.text));
    // sslcommerz.payNow();

    var result = await sslcommerz.payNow();
    if (result is PlatformException) {
      print("the response is: " +
          result.status.toString() +
          " code: " +
          result.status.toString());
    } else {
      SSLCTransactionInfoModel model = result;
      Fluttertoast.showToast(
          msg: "Transaction successful: Amount ${model.amount} TK",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 0);
    print(widget.bookedDateAndTime);
    print(widget.doctorName);
    _getUserData();
    _getData();

    super.initState();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  String? _photoUrl = "";
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
        _photoUrl = user.photoURL;
        _profileUrl = event.get("profileUrl").toString();
        print(_name);
      });
    });
  }

  Stream<QuerySnapshot> _getCount() {
    final CollectionReference mainCollection =
        FirebaseFirestore.instance.collection('BOOKING');

    return mainCollection.snapshots();
  }

  Future<void> _sendData(bookingid) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;

    await FirebaseFirestore.instance
        .collection("DOCTORS")
        .doc(widget.doctorId)
        .set({"bookingStatus": "booked"}, SetOptions(merge: true));
    await FirebaseFirestore.instance
        .collection("Doctor")
        .doc(widget.doctorSpeciality)
        .collection("DOCTORS")
        .doc(widget.doctorId)
        .set({"bookingStatus": "booked"}, SetOptions(merge: true));

    await FirebaseFirestore.instance.collection("BOOKING").doc(bookingid).set({
      "patientId": userdoc,
      "patientName": _nameController.text,
      "patientEmail": user.email,
      "patientImage": _photoUrl ?? _profileUrl,
      "gender": _gendertype,
      "age": _ageController.text,
      "phone": _phoneController.text,
      "address": "${_address1Controller.text},${_address2Controller.text}",
      "city": _cityController.text,
      "pincode": _pinController.text,
      "symptoms": _symptomsController.text,
      "doctorId": widget.doctorId,
      "doctorName": widget.doctorName,
      "doctorUrl": widget.doctorUrl,
      "doctorSpeciality": widget.doctorSpeciality,
      "doctorLocation": widget.doctorLocation,
      "doctorregistration": widget.registration,
      "bookingDetails": widget.bookedDateAndTime,
      "totalAmount": widget.price,
      // "method": _paymenttype == "Pay Online" ? "Online" : "Offline",
      "prescriptionStatus": "Pending",
      "prescriptionType": "",
      "prescriptionUrl": "",
      "status": "inactive",
      "type": "PATIENT",
      "bookingType": "booking"
      // "paymentStatus"
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection("USERS")
        .doc(userdoc)
        .collection("BOOKINGS")
        .doc(bookingid)
        .set({
      "patientId": userdoc,
      "patientName": _nameController.text,
      "patientEmail": user.email,
      "patientImage": _photoUrl ?? _profileUrl,
      "gender": _gendertype,
      "age": _ageController.text,
      "phone": _phoneController.text,
      "address": "${_address1Controller.text},${_address2Controller.text}",
      "city": _cityController.text,
      "pincode": _pinController.text,
      "symptoms": _symptomsController.text,
      "doctorId": widget.doctorId,
      "doctorName": widget.doctorName,
      "doctorUrl": widget.doctorUrl,
      "doctorSpeciality": widget.doctorSpeciality,
      "doctorLocation": widget.doctorLocation,
      "bookingDetails": widget.bookedDateAndTime,
      "doctorregistration": widget.registration,
      "prescriptionType": "",
      "totalAmount": widget.price,
      //"method": _paymenttype == "Pay Online" ? "Online" : "Offline",
      "prescriptionStatus": "Pending",
      "prescriptionUrl": "",
      "status": "inactive",
      "type": "PATIENT",
      "bookingType": "booking"
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection("DOCTORS")
        .doc(widget.doctorId)
        .collection("BOOKINGS")
        .doc(bookingid)
        .set({
      "patientId": userdoc,
      "patientName": _nameController.text,
      "patientEmail": user.email,
      "gender": _gendertype,
      "age": _ageController.text,
      "patientImage": _photoUrl ?? _profileUrl,
      "phone": _phoneController.text,
      "address": "${_address1Controller.text},${_address2Controller.text}",
      "city": _cityController.text,
      "pincode": _pinController.text,
      "symptoms": _symptomsController.text,
      "doctorId": widget.doctorId,
      "doctorName": widget.doctorName,
      "doctorregistration": widget.registration,
      "doctorUrl": widget.doctorUrl,
      "doctorSpeciality": widget.doctorSpeciality,
      "doctorLocation": widget.doctorLocation,
      "bookingDetails": widget.bookedDateAndTime,
      "totalAmount": widget.price,
      "prescriptionType": "",
      //"method": _paymenttype == "Pay Online" ? "Online" : "Offline",
      "prescriptionStatus": "Pending",
      "prescriptionUrl": "",
      "status": "inactive",
      "type": "PATIENT",
      "bookingType": "booking"
    }, SetOptions(merge: true));
    print(_name);

    //print("User id: $user");
  }

  var bookingCount;

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
    LanguageController languageController = context.read<LanguageController>();
    context.watch<LanguageController>();
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
        backgroundColor: lightestpurple,
        drawer: const Drawers(),
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
        body: Stack(
          children: [
            Container(
              height: height,
              decoration: const BoxDecoration(
                color: lightestpurple,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                image: DecorationImage(
                  image: AssetImage("assets/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SizedBox(
                width: width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: height * 0.04),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: Text(
                          'Billing_Details'.tr(),
                          textAlign: TextAlign.left,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.03,
                              color: grey),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Form(
                        key: _formnKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.04,
                                right: width * 0.04,
                                // top: height * 0.01,
                              ),
                              child: TextFormField(
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                                cursorColor: lightpurple,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: grey,
                                    fontSize: height * 0.022),
                                decoration: InputDecoration(
                                  hintText: "Full_Name".tr(),
                                  hintStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w500,
                                      color: grey,
                                      fontSize: height * 0.02),
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
                            SizedBox(height: height * 0.02),
                            Padding(
                                padding: EdgeInsets.only(
                                  left: width * 0.04,
                                  right: width * 0.04,
                                  // top: height * 0.01,
                                ),
                                child: Container(
                                  // margin: EdgeInsets.fromLTRB(width * 0.05, 0.0,
                                  //     width * 0.05, height * 0.04),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: lightpurple,
                                      width: 2,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                      width * 0.025,
                                      height * 0.002,
                                      width * 0.017,
                                      height * 0.002),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            items: _genderType
                                                .map((value) =>
                                                    DropdownMenuItem(
                                                      value: value,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            value,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: dark),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                .toList(),
                                            onChanged: (selectedtype) {
                                              setState(() {
                                                _gendertype = selectedtype;
                                              });
                                            },
                                            value: _gendertype,
                                            hint: Text(
                                              "Gender".tr(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: height * 0.03,
                                              ),
                                            ),
                                            elevation: 0,
                                            isExpanded: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            SizedBox(height: height * 0.02),
                            Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.04,
                                right: width * 0.04,
                                // top: height * 0.01,
                              ),
                              child: TextFormField(
                                controller: _ageController,
                                keyboardType: TextInputType.number,
                                cursorColor: lightpurple,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: grey,
                                    fontSize: height * 0.022),
                                decoration: InputDecoration(
                                  hintText: "Age".tr(),
                                  hintStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w500,
                                      color: grey,
                                      fontSize: height * 0.02),
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
                            SizedBox(height: height * 0.02),
                            Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.04,
                                right: width * 0.04,
                                // top: height * 0.01,
                              ),
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                cursorColor: lightpurple,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: grey,
                                    fontSize: height * 0.022),
                                decoration: InputDecoration(
                                  hintText: "Phone".tr(),
                                  hintStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w500,
                                      color: grey,
                                      fontSize: height * 0.02),
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
                            SizedBox(height: height * 0.02),
                            Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.04,
                                right: width * 0.04,
                                // top: height * 0.01,
                              ),
                              child: TextFormField(
                                controller: _address1Controller,
                                keyboardType: TextInputType.text,
                                cursorColor: lightpurple,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: grey,
                                    fontSize: height * 0.022),
                                decoration: InputDecoration(
                                  hintText: "Street_Address".tr(),
                                  hintStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w500,
                                      color: grey,
                                      fontSize: height * 0.02),
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
                            SizedBox(height: height * 0.02),
                            Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.04,
                                right: width * 0.04,
                                // top: height * 0.02,
                              ),
                              child: TextFormField(
                                controller: _address2Controller,
                                keyboardType: TextInputType.text,
                                cursorColor: lightpurple,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: grey,
                                    fontSize: height * 0.02),
                                decoration: InputDecoration(
                                  labelText: "Street_Address_2".tr(),
                                  labelStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w500,
                                      color: grey,
                                      fontSize: height * 0.02),
                                  fillColor:
                                      Colors.transparent.withOpacity(0.1),
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
                            SizedBox(height: height * 0.02),
                            Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.04,
                                right: width * 0.04,
                                // top: height * 0.01,
                              ),
                              child: TextFormField(
                                controller: _cityController,
                                keyboardType: TextInputType.streetAddress,
                                cursorColor: lightpurple,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: grey,
                                    fontSize: height * 0.02),
                                decoration: InputDecoration(
                                  labelText: "City".tr(),
                                  labelStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w500,
                                      color: grey,
                                      fontSize: height * 0.02),
                                  fillColor:
                                      Colors.transparent.withOpacity(0.1),
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
                            SizedBox(height: height * 0.02),
                            Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.04,
                                right: width * 0.04,
                                // top: height * 0.01,
                              ),
                              child: TextFormField(
                                controller: _pinController,
                                keyboardType: TextInputType.number,
                                cursorColor: lightpurple,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: grey,
                                    fontSize: height * 0.02),
                                decoration: InputDecoration(
                                  labelText: 'Pincode'.tr(),
                                  labelStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w500,
                                      color: grey,
                                      fontSize: height * 0.02),
                                  fillColor:
                                      Colors.transparent.withOpacity(0.1),
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
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.04),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: Text(
                          'Additional_Information'.tr(),
                          textAlign: TextAlign.left,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.03,
                              color: grey),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.04,
                          right: width * 0.04,
                          // top: height * 0.01,
                        ),
                        child: TextFormField(
                          controller: _symptomsController,
                          keyboardType: TextInputType.text,
                          cursorColor: lightpurple,
                          maxLines: 2,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: grey,
                              fontSize: height * 0.02),
                          decoration: InputDecoration(
                            labelText: 'Symptoms'.tr(),
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
                      SizedBox(height: height * 0.04),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: Text(
                          'Your_Orders'.tr(),
                          textAlign: TextAlign.left,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.03,
                              color: grey),
                        ),
                      ),
                      SizedBox(height: height * 0.04),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                        child: Table(
                            // border: TableBorder.symmetric(
                            //   inside: BorderSide(color: grey2),
                            // ), // Allows to add a border decoration around your table
                            children: [
                              TableRow(children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: height * 0.02,
                                    bottom: height * 0.02,
                                    // left: width * 0.03,
                                    // right: width * 0.03
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Timing'.tr(),
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.w600,
                                          fontSize: height * 0.025,
                                          color: black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: height * 0.02,
                                    bottom: height * 0.02,
                                    // left: width * 0.03,
                                    // right: width * 0.03
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Price',
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.w600,
                                          fontSize: height * 0.025,
                                          color: black),
                                    ),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: height * 0.02,
                                    // bottom: height * 0.02,
                                    // left: width * 0.03,
                                    // right: width * 0.03
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Booking for @${widget.doctorName}- ${widget.bookedDateAndTime}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.w600,
                                          fontSize: height * 0.02,
                                          color: black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: height * 0.02,
                                    // bottom: height * 0.02,
                                    // left: width * 0.03,
                                    // right: width * 0.03
                                  ),
                                  child: Center(
                                    child: Text(
                                      '₹${widget.price}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * 0.03,
                                          color: black),
                                    ),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    top: height * 0.02,
                                    bottom: height * 0.02,
                                    // left: width * 0.03,
                                    // right: width * 0.03
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Total'.tr(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.w800,
                                          fontSize: height * 0.02,
                                          color: black),
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                    top: height * 0.02,
                                    // bottom: height * 0.02,
                                    // left: width * 0.03,
                                    // right: width * 0.03
                                  ),
                                  child: Center(
                                    child: Text(
                                      '₹${widget.price}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * 0.03,
                                          color: black),
                                    ),
                                  ),
                                ),
                              ]),
                            ]),
                      ),
                      // SizedBox(height: height * 0.04),
                      // selectTopic(height, width),
                      SizedBox(height: height * 0.04),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Text(
                          'Your Personal data will be used to process your order, support your experience throughout this website,and for other purposes described in our privacy Policy.',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.03,
                              color: dark),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      SizedBox(
                        width: width,
                        //height: height * 0.1,
                        child: StreamBuilder(
                          stream: _getCount(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            } else if (snapshot.hasData ||
                                snapshot.data != null) {
                              var itemCount = snapshot.data!.docs.length;
                              //print(snapshot.data.toString());
                              return Container(
                                width: width * 0.4,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.08),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                lightpurple)),
                                    onPressed: () {
                                      if (_nameController.text.isEmpty ||
                                          _ageController.text.isEmpty ||
                                          _gendertype == null ||
                                          _phoneController.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Field must not be empty.")));
                                      } else {
                                        var item = itemCount + 1;

                                        sslCommerzGeneralCall(widget.price)
                                            .then((value) {
                                          setState(() {
                                            _sendData("MH000$item");
                                            _showAppointmentDoneDialog(
                                                context,
                                                width,
                                                height,
                                                item,
                                                widget.bookedDateAndTime);
                                          });
                                        });
                                      }
                                    },
                                    child: Text(
                                      'Place_Order'.tr(),
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.w600,
                                          fontSize: height * 0.023,
                                          color: grey),
                                    )),
                              );
                            }
                            return const CircularProgressIndicator(
                              color: dark,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showAppointmentDoneDialog(BuildContext context, double width, double height,
      var bookingId, var dateAndTime) {
    return showGeneralDialog(
        context: context,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                width: width,
                height: height,
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    height: height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.2),
                        Image.asset(
                          'assets/like (1).png',
                          height: width * 0.25,
                          width: width * 0.25,
                          color: grey,
                        ),
                        SizedBox(height: height * 0.06),
                        Text(
                          'Thank_You'.tr(),
                          style: GoogleFonts.raleway(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: grey),
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          'Your_Appointment_has_been_Created'.tr(),
                          style: GoogleFonts.raleway(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: grey),
                        ),
                        SizedBox(height: height * 0.03),
                        Text(
                          "Your Booking Id: MH000$bookingId",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: grey),
                        ),
                        SizedBox(height: width * 0.02),
                        Text(
                          "Booking Date & Time:$dateAndTime",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: grey),
                        ),
                        SizedBox(height: width * 0.02),
                        Text(
                          "For_any_inconvenience_contact_us".tr(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: grey),
                        ),
                        SizedBox(height: height * 0.2),
                        SizedBox(
                          width: width * 0.4,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(lightpink3)),
                              onPressed: () {
                                // Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const Home()));
                              },
                              child: Text(
                                'Done',
                                style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                    color: grey),
                              )),
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }
}
