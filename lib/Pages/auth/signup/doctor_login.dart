import 'package:dynamic_doctor/Pages/doctor/doctor_edit_profile_screen.dart';
import 'package:dynamic_doctor/Services/auth_provider.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorLogin extends StatefulWidget {
  const DoctorLogin({Key? key}) : super(key: key);

  @override
  _DoctorLoginState createState() => _DoctorLoginState();
}

class _DoctorLoginState extends State<DoctorLogin> {
  bool isHiddenPassword = true;
  String username = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: height * 0.05),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          color: dark,
                          fontSize: height * 0.023),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600,
                            color: dark,
                            fontSize: 20),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(width * 0.02),
                          child: Image.asset(
                            'assets/user (5).png',
                            color: dark,
                            height: width * 0.02,
                            width: width * 0.02,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(width: 3, color: dark),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusColor: purple,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: dark, width: 3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: const BorderSide(width: 3, color: dark),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.04),
                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: isHiddenPassword,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          color: dark,
                          fontSize: height * 0.025),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600,
                            color: dark,
                            fontSize: height * 0.025),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(width * 0.02),
                          child: Image.asset(
                            'assets/padlock.png',
                            color: dark,
                            height: width * 0.02,
                            width: width * 0.02,
                          ),
                        ),
                        suffixIcon: InkWell(
                          onTap: _togglePasswordView,
                          child: isHiddenPassword
                              ? Padding(
                                  padding: EdgeInsets.all(width * 0.02),
                                  child: Image.asset(
                                    'assets/view.png',
                                    color: dark,
                                    height: width * 0.02,
                                    width: width * 0.02,
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.all(width * 0.02),
                                  child: Image.asset(
                                    'assets/witness.png',
                                    color: dark,
                                    height: width * 0.025,
                                    width: width * 0.025,
                                  ),
                                ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(width: 3, color: dark),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusColor: purple,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: dark, width: 3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: const BorderSide(width: 3, color: dark),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.08),
                    SizedBox(
                      width: width / 1.5,
                      height: width * 0.12,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(lightpurple)),
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            // Navigator.pushAndRemoveUntil(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             DoctorEditProfileScreen()),
                            //     (route) => false);
                            AuthClass()
                                .signINDoctor(_emailController.text.trim(),
                                    _passwordController.text.trim())
                                .then((value) {
                              if (value == "Welcome" &&
                                  _emailController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty) {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DoctorEditProfileScreen()),
                                    (route) => false);
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(value)));
                              }
                            });
                          },
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w600,
                                fontSize: height * 0.027,
                                color: Colors.black),
                          )),
                    ),
                  ],
                )),
            SizedBox(height: height * 0.05),
            Text(
              'Forget Password?',
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: height * 0.028,
                  color: dark),
            ),
            SizedBox(height: height * 0.01),
            Text(
              'click here to reset it',
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: height * 0.02,
                  color: dark),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }
}
