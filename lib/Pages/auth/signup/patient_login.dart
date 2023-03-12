import 'package:dynamic_doctor/Pages/auth/Forgot_password.dart';
import 'package:dynamic_doctor/Pages/auth/signup/patient_registration1.dart';
import 'package:dynamic_doctor/Pages/patient/home.dart';
import 'package:dynamic_doctor/Services/auth_provider.dart';
import 'package:dynamic_doctor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientLoginEmail extends StatefulWidget {
  const PatientLoginEmail({Key? key}) : super(key: key);

  @override
  _PatientLoginEmailState createState() => _PatientLoginEmailState();
}

class _PatientLoginEmailState extends State<PatientLoginEmail> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SizedBox(
              height: height,
              child: Stack(
                children: [
                  Container(
                      decoration: const BoxDecoration(
                        color: lightpurple,
                        image: DecorationImage(
                          image: AssetImage("assets/background1.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: null),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.05),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.arrow_back,
                            size: height * 0.04,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: width * 0.05),
                        Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.1,
                              color: Colors.white),
                        ),
                        SizedBox(height: width * 0.01),
                        Text(
                          'Sign in Now',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.06,
                              color: Colors.white),
                        ),
                        SizedBox(height: height * 0.1),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.name,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Email or Mobile Number',
                                  labelStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: width * 0.04),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.5),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusColor: purple,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: lightpurple, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(width: 1, color: dark),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              SizedBox(height: width * 0.05),
                              TextFormField(
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: width * 0.04),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.5),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusColor: purple,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: lightpurple, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(width: 1, color: dark),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              SizedBox(height: width * 0.08),
                              SizedBox(
                                width: width,
                                height: width * 0.12,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                lightpurple)),
                                    onPressed: () {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      AuthClass()
                                          .signIN(_emailController.text.trim(),
                                              _passwordController.text.trim())
                                          .then((value) {
                                        if (value == "Welcome" &&
                                            _emailController.text.isNotEmpty &&
                                            _passwordController
                                                .text.isNotEmpty) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Home()),
                                              (route) => false);
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(value)));
                                        }
                                      });
                                    },
                                    child: isLoading == false
                                        ? Text(
                                            'Login',
                                            style: GoogleFonts.raleway(
                                              fontWeight: FontWeight.w600,
                                              fontSize: width * 0.06,
                                            ),
                                          )
                                        : const Center(
                                            child: CircularProgressIndicator(
                                                color: Colors.white),
                                          )),
                              ),
                              SizedBox(height: width * 0.1),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PatientRegistrationwithEmail()),
                                ),
                                child: Text(
                                  'Not Registered Yet? Sign Up Now',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w600,
                                      fontSize: width * 0.04,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(height: width * 0.05),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPassword())),
                                child: Text(
                                  'Forget Password?',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w600,
                                      fontSize: width * 0.04,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class PatientLoginPhone extends StatefulWidget {
  const PatientLoginPhone({Key? key}) : super(key: key);

  @override
  _PatientLoginPhoneState createState() => _PatientLoginPhoneState();
}

class _PatientLoginPhoneState extends State<PatientLoginPhone> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SizedBox(
              height: height,
              child: Stack(
                children: [
                  Container(
                      decoration: const BoxDecoration(
                        color: lightpurple,
                        image: DecorationImage(
                          image: AssetImage("assets/background1.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: null),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.05),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.arrow_back,
                            size: height * 0.04,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: width * 0.05),
                        Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.1,
                              color: Colors.white),
                        ),
                        SizedBox(height: width * 0.01),
                        Text(
                          'Sign in Now',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.06,
                              color: Colors.white),
                        ),
                        SizedBox(height: height * 0.1),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.name,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Email or Mobile Number',
                                  labelStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: width * 0.04),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.5),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusColor: purple,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: lightpurple, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(width: 1, color: dark),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              SizedBox(height: width * 0.05),
                              TextFormField(
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: width * 0.04),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.5),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusColor: purple,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: lightpurple, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(width: 1, color: dark),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              SizedBox(height: width * 0.08),
                              SizedBox(
                                width: width,
                                height: width * 0.12,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                lightpurple)),
                                    onPressed: () {
                                      if (_emailController.text
                                          .contains(RegExp(r'[0-9]'), 1)) {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        AuthClass()
                                            .signINForPhone(
                                                _emailController.text.trim(),
                                                _passwordController.text.trim())
                                            .then((value) {
                                          if (value == "Welcome" &&
                                              _emailController
                                                  .text.isNotEmpty &&
                                              _passwordController
                                                  .text.isNotEmpty) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Home()),
                                                (route) => false);
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(value)));
                                          }
                                        });
                                      } else {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        AuthClass()
                                            .signIN(
                                                _emailController.text.trim(),
                                                _passwordController.text.trim())
                                            .then((value) {
                                          if (value == "Welcome" &&
                                              _emailController
                                                  .text.isNotEmpty &&
                                              _passwordController
                                                  .text.isNotEmpty) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Home()),
                                                (route) => false);
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(value)));
                                          }
                                        });
                                      }
                                    },
                                    child: isLoading == false
                                        ? Text(
                                            'Login',
                                            style: GoogleFonts.raleway(
                                              fontWeight: FontWeight.w600,
                                              fontSize: width * 0.06,
                                            ),
                                          )
                                        : const Center(
                                            child: CircularProgressIndicator(
                                                color: Colors.white),
                                          )),
                              ),
                              SizedBox(height: width * 0.1),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PatientRegistrationwithPhone()),
                                ),
                                child: Text(
                                  'Not Registered Yet? Sign Up Now',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w600,
                                      fontSize: width * 0.04,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(height: width * 0.05),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPassword())),
                                child: Text(
                                  'Forget Password?',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w600,
                                      fontSize: width * 0.04,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
