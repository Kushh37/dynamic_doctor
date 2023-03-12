import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_doctor/Pages/patient/CallHistory.dart';
import 'package:dynamic_doctor/Pages/patient/Chat_Support.dart';
import 'package:dynamic_doctor/Pages/patient/settings.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:dynamic_doctor/widgets/drawer_patient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class YourPrescription extends StatefulWidget {
  final String url;
  final String docId;
  const YourPrescription({Key? key, required this.url, required this.docId})
      : super(key: key);

  @override
  _YourPrescriptionState createState() => _YourPrescriptionState();
}

class _YourPrescriptionState extends State<YourPrescription>
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

    _total = 0.0;
    print(widget.docId);
    _getData();
  }

  Future<void> _sendData() async {
    await FirebaseFirestore.instance
        .collection("PRESCRIPTION")
        .doc(widget.docId)
        .set({
      "status": "paid",
    }, SetOptions(merge: true));

    //print("User id: $user");
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _name = "";
  String _email = "";
  String _phone = "";
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
        _email = event.get("email").toString();
        _phone = event.get("phone").toString();
        print(_name);
      });
    });
  }

  double total = 0.0;
  Future<void> sslCommerzGeneralCall(total) async {
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
      total_amount: total,
      tran_id: "1231321321321312",
    ));
    sslcommerz.addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerName: _name,
            customerEmail: _email,
            customerAddress1: "",
            customerCity: "",
            customerPostCode: "",
            customerState: "",
            customerCountry: "",
            customerPhone: _phone));
    // sslcommerz.payNow();

    var result = await sslcommerz.payNow();
    if (result is PlatformException) {
      print("the response is: " +
          result.status.toString() +
          " code: " +
          result.status.toString());
    } else {
      SSLCTransactionInfoModel model = result;
    }
  }

  num totalamount = 0.0;

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

  Stream<QuerySnapshot> readItems() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('PRESCRIPTION')
        .doc(widget.docId)
        .collection("MEDICINES");

    return mainCollection.snapshots();
  }

  double? _total;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // key: _scaffoldKey,

        body: Container(
          // height: height,
          padding: EdgeInsets.symmetric(horizontal: width * 0.02),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Container(
              //   padding: EdgeInsets.only(top: width * 0.02),
              //   height: width * 0.5,
              //   width: width,
              //   child: Image.network(
              //     widget.url,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              //SizedBox(height: width * 0.04),
              Text(
                "Your Prescription",
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(fontSize: width * 0.05),
              ),
              SizedBox(height: width * 0.04),
              Expanded(
                child: StreamBuilder(
                  stream: readItems(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    } else if (snapshot.hasData || snapshot.data != null) {
                      return SizedBox(
                        // color: Colors.red,
                        height: height,
                        width: width,
                        child: ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            height: height * 0.01,
                          ),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            String name =
                                snapshot.data!.docs[index]['medicineName'];
                            String qty = snapshot.data!.docs[index]['qty'];
                            String ppu = snapshot.data!.docs[index]['ppu'];
                            double total = snapshot.data!.docs[index]['total'];

                            return Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                              ),
                              // height: height,
                              width: width,
                              child: GestureDetector(
                                onTap: () async {},
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  tileColor: lightpink3,
                                  horizontalTitleGap: 0.0,
                                  title: Text(
                                    name,
                                    style: GoogleFonts.raleway(
                                        fontSize: width * 0.05,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Qty:  ₹$qty",
                                        style: GoogleFonts.lato(
                                            fontSize: width * 0.04,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(width: width * 0.04),
                                      Text(
                                        "PPU: $ppu",
                                        style: GoogleFonts.lato(
                                            fontSize: width * 0.04,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    "₹$total",
                                    style: GoogleFonts.lato(
                                        fontSize: width * 0.04,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: width * 0.04,
              ),
              Container(
                width: width * 0.5,
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(lightpurple)),
                    onPressed: () {
                      sslCommerzGeneralCall(totalamount).then((value) {
                        setState(() {
                          _sendData();
                          Navigator.of(context).pop();
                        });
                      });
                    },
                    child: Text(
                      "Pay Now",
                      style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w600,
                          fontSize: height * 0.023,
                          color: grey),
                    )),
              ),
            ],
          ),
        ),
        drawer: Drawers(),
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
        bottomNavigationBar: SizedBox(
          height: width * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: dark,
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                alignment: Alignment.center,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('PRESCRIPTION')
                        .doc(widget.docId)
                        .collection('MEDICINES')
                        .snapshots(),
                    // builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {  },;

                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      } else if (snapshot.hasData || snapshot.data != null) {
                        num total = 0;
                        // Future.delayed(Duration(seconds: 3), () {
                        //   snapshot.data!.docs.forEach((doc) =>
                        //       {total += doc.get('total'), totalamount = total});
                        // });
                        snapshot.data!.docs.forEach((doc) =>
                            {total += doc.get('total'), totalamount = total});

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Grand Total",
                              style: GoogleFonts.lato(
                                  fontSize: width * 0.05,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: width * 0.02),
                              child: Text(
                                "₹${total.toString()}",
                                style: GoogleFonts.lato(
                                    fontSize: width * 0.05,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        );
                      }

                      return const Text('Loading');
                    }),
              ),
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
      ),
    );
  }
}
