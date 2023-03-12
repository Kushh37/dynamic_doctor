import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthClass {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  //Sign in with phone

  //Create Account
  Future<String> createUser(
      String name, String email, String phone, String password) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // final cred1 = await auth.
      final user = credential.user;
      String userdoc = user!.uid;
      await FirebaseFirestore.instance.collection("USERS").doc(userdoc).set({
        "email": email,
        "name": name,
        "phone": phone,
        "type": "PATIENT",
        "gender": "Male",
        "age": "NotFound",
        "address": "",
        "profileUrl": "https://cdn-icons-png.flaticon.com/512/149/149071.png"
      });
      fcm.getToken().then((value) {
        FirebaseFirestore.instance
            .collection("USERS")
            .doc(userdoc)
            .collection("TOKENS")
            .doc(value)
            .set({
          "token": value,
        });
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);

      return "Created";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return "Error occurred $e";
    }
    return 'Information Required';
  }

  Future<String> signINDoctor(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      final user = credential.user;
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection("DOCTORS")
          .doc(user?.uid)
          .get();

      var usertype = data["type"];
      fcm.getToken().then((value) {
        FirebaseFirestore.instance
            .collection("DOCTORS")
            .doc(user!.uid)
            .collection("TOKENS")
            .doc(value)
            .set({
          "token": value,
        });
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);

      if (usertype == "DOCTOR") {
        return "Welcome";
      } else {
        return "Try Again";
      }

      //return "Welcome";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
    return 'Try Again';
  }

  //Sign in user
  Future<String> signIN(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      final user = credential.user;
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection("USERS")
          .doc(user?.uid)
          .get();

      var usertype = data["type"];
      fcm.getToken().then((value) {
        FirebaseFirestore.instance
            .collection("USERS")
            .doc(user!.uid)
            .collection("TOKENS")
            .doc(value)
            .set({
          "token": value,
        });
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);
      if (usertype == "PATIENT") {
        return "Welcome";
      } else {
        return "NotWelcome";
      }

      // return "Welcome";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
    return 'Try Again';
  }

  Future<String> signINForPhone(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: "$email@sms.com", password: password);

      final user = credential.user;
      fcm.getToken().then((value) {
        FirebaseFirestore.instance
            .collection("USERS")
            .doc(user!.uid)
            .collection("TOKENS")
            .doc(value)
            .set({
          "token": value,
        });
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);
      return "Welcome";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
    return 'Try Again';
  }

  //Reset Password
  Future<String> resetPassword({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(
        email: email,
      );
      return "Email sent";
    } catch (e) {
      return "Error occurred";
    }
  }

  //SignOut
  void logOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await auth.signOut();
  }

  Future<String> createUserforPhone(
      String name, String email, String phone, String password) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
          email: "$phone@sms.com", password: password);
      // final cred1 = await auth.
      final user = credential.user;
      String userdoc = user!.uid;
      await FirebaseFirestore.instance.collection("USERS").doc(userdoc).set({
        "email": email,
        "name": name,
        "phone": phone,
        "type": "PATIENT",
        "gender": "Male",
        "age": "NotFound",
        "address": "",
        "profileUrl": "https://cdn-icons-png.flaticon.com/512/149/149071.png"
      });
      fcm.getToken().then((value) {
        FirebaseFirestore.instance
            .collection("USERS")
            .doc(userdoc)
            .collection("TOKENS")
            .doc(value)
            .set({
          "token": value,
        });
      });
      //print(_fcmToken);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);

      return "Created";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return "Error occurred";
    }
    return 'Information Required';
  }
}
