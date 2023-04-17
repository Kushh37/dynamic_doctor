import 'dart:ui';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//colours:
const dark = Color(0xff54415e);
const dark2 = Color(0xff262626);
const blue = Color(0xff3976ea);
const blue2 = Color(0xff7ea5e6);
const blue3 = Color(0xff3875ea);
const lightblue = Color(0xff76a1ed);
const black = Color(0xff141010);
const black2 = Color(0xff131313);
const purple = Color(0xffa538e5);
const darkpurple = Color(0xff625006b);
const lightpurple = Color(0xffd3bbdd);
const lightpurple2 = Color(0xffc58de2);
const lightpink = Color(0xffcd99a1);
const lightpink2 = Color(0xffcc969e);
const lightpink3 = Color(0xffefd9e4);
const lightestpurple = Color(0xffF5E5FF);
const grey = Color(0xff7a727d);
const grey2 = Color(0xffa49ba7);
const grey3 = Color(0xffbdb4c1);
const grey4 = Color(0xff4b444e);
const grey5 = Color(0xffcac6cc);
const lightgrey = Color(0xffb6b6b6);
const orange = Color(0xffdc9539);
const green = Color(0xff04be04);

const videoAppId = 328174001;
const videoAppSign =
    "47c3e992217b0113482089da76606c767af5903f202ff461e42673e96ce2bfd2";

const storeId = "vedas612dadfd20e40";
const storePassword = "vedas612dadfd20e40@ssl";

// const appId = "2228eb5309e64440806e7a71f9719eec";

// /// Please refer to https://docs.agora.io/en/Agora%20Platform/token
// const token =
//     "0062228eb5309e64440806e7a71f9719eecIABwwCDVFN5TZRCWrzYnka9DFDIKebPhRmkjqPYWRIfCc4AO3FUAAAAAEABSSZ5eZ702YQEAAQBnvTZh";

// /// Your channel ID
// const channelId = "demo1";
const APP_ID = '2228eb5309e64440806e7a71f9719eec';
// const Token =
// '0062228eb5309e64440806e7a71f9719eecIABwwCDVFN5TZRCWrzYnka9DFDIKebPhRmkjqPYWRIfCc4AO3FUAAAAAEABSSZ5eZ702YQEAAQBnvTZh';

// /// Your int user ID
// const uid = YOUR_UID;

// /// Your string user ID
// const stringUid = YOUR_STRING_UID;

languageHindi(
  BuildContext context,
  double width,
  double height,
) {
  return showGeneralDialog(
      context: context,
      //barrierDismissible: true,
      // barrierLabel:
      //     MaterialLocalizations.of(context).modalBarrierDismissLabel,
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
                      // SizedBox(height: height * 0.2),
                      Text(
                        'Coming Soon',
                        style: GoogleFonts.raleway(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: grey),
                      ),
                      // Text(
                      //   '|| প্রক্রিয়াকরণ চলছে ||',
                      //   style: GoogleFonts.raleway(
                      //       fontSize: 22,
                      //       fontWeight: FontWeight.w700,
                      //       color: grey),
                      // ),

                      SizedBox(height: height * 0.03),
                      SizedBox(
                        width: width * 0.4,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(lightpink3)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Okay',
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

class LanguageController extends ChangeNotifier {
  onLanguageChanged() {
    notifyListeners();
  }
}

class CustomTitle extends StatelessWidget {
  CustomTitle({
    Key? key,
    required LanguageController languageController,
    required this.width,
    required this.height,
    required this.langHindi,
  })  : _languageController = languageController,
        super(key: key);

  final LanguageController _languageController;
  final double width;
  final double height;
  bool langHindi;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              context.locale = Locale('en', 'US');
              langHindi = false;
              _languageController.onLanguageChanged();
            },
            child: Container(
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
          ),
          GestureDetector(
            onTap: () {
              context.locale = Locale('bn', 'BD');
              langHindi = true;
              _languageController.onLanguageChanged();
              // languageHindi(context, width, height);
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
    );
  }
}
