// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shuaal/utils/alert.dart';
import 'package:shuaal/utils/colors.dart';
import 'package:shuaal/utils/text.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextStyle ts = const TextStyle(
      fontFamily: 'almarai', fontWeight: FontWeight.bold, fontSize: 20);
  OutlineInputBorder outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: primary, width: 2));
  TextEditingController email = TextEditingController();

  bool load = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            child: Image.asset(
              "assets/images/corner.png",
              width: 200,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              alignment: Alignment.topRight,
              width: double.infinity,
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text(
                      text: 'إعادة تعيين كلمة المرور',
                      size: 25.0,
                      fontWeight: FontWeight.bold),
                  const SizedBox(height: 30),
                  Image.asset(
                    "assets/images/logo.png",
                    width: 130,
                  ),
                  const SizedBox(height: 30),
                  TextField(
                      style: ts,
                      controller: email,
                      decoration: InputDecoration(
                          hintText: 'البريد الإلكتروني',
                          hintStyle: ts,
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15),
                          prefixIcon: const Icon(Icons.email),
                          enabledBorder: outline,
                          focusedBorder: outline)),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () => load ? null : reset_password(),
                      color: primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: load
                          ? const SpinKitThreeBounce(color: Colors.white)
                          : text(
                              text: 'إعادة تعيين',
                              color: Colors.white,
                              size: 20.0,
                              fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: text(text: 'رجوع'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  reset_password() async {
    if (email.text.isEmpty) {
      Alert().show(context, 'الرجاء إدخال البريد الإلكتروني');
    } else {
      setState(() => load = true);
      FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.text)
          .then((value) async {
        setState(() => load = false);
        email.clear();
        Alert().show(context,
            'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني');
      }).catchError((e) {
        setState(() => load = false);
        if (e.code == 'invalid-email') {
          Alert().show(context, 'البريد الإلكتروني غير صحيح');
        } else {
          Alert().show(context, e.toString());
        }
      });
    }
  }
}
