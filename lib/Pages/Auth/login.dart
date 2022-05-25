// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuaal/utils/alert.dart';
import 'package:shuaal/utils/colors.dart';
import 'package:shuaal/utils/text.dart';
import '../Home/home_screen.dart';
import 'reset_password.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextStyle ts = const TextStyle(
      fontFamily: 'almarai', fontWeight: FontWeight.bold, fontSize: 20);
  OutlineInputBorder outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: primary, width: 2));
  TextEditingController email = TextEditingController(),
      password = TextEditingController();
  bool vis = true, load = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
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
          Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  text(
                      text: 'مرحباً مجدداً',
                      size: 25.0,
                      fontWeight: FontWeight.bold),
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
                  const SizedBox(height: 20),
                  TextField(
                      style: ts,
                      controller: password,
                      obscureText: vis,
                      decoration: InputDecoration(
                          hintText: 'كلمة المرور',
                          hintStyle: ts,
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15),
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => vis = !vis),
                            child: Icon(
                                vis ? Icons.visibility : Icons.visibility_off),
                          ),
                          enabledBorder: outline,
                          focusedBorder: outline)),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ResetPassword())),
                    child: text(text: 'نسيت كلمة المرور؟'),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () => load ? null : login(),
                      color: primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: load
                          ? const SpinKitThreeBounce(color: Colors.white)
                          : text(
                              text: 'تسجيل الدخول',
                              color: Colors.white,
                              size: 20.0,
                              fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () => load
                          ? null
                          : Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Signup())),
                      color: l2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: load
                          ? const SpinKitThreeBounce(color: Colors.white)
                          : text(
                              text: 'حساب جديد',
                              color: Colors.white,
                              size: 20.0,
                              fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  login() async {
    if (email.text.isEmpty) {
      Alert().show(context, 'الرجاء إدخال البريد الإلكتروني');
    } else if (password.text.isEmpty) {
      Alert().show(context, 'الرجاء إدخال كلمة المرور');
    } else {
      setState(() => load = true);
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((value) async {
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString('uid', value.user!.uid).then((value) {
          setState(() => load = false);
          return Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (builder) => const HomeScreen()),
              (route) => false);
        });
      }).catchError((e) {
        setState(() => load = false);
        if (e.code == 'invalid-email') {
          Alert().show(context, 'البريد الإلكتروني غير صحيح');
        } else if (e.code == 'wrong-password') {
          Alert().show(context, 'البريد الإلكتروني أو كلمة المرور غير صحيحة');
        } else {
          Alert().show(context, e.toString());
        }

        print(e.code);
      });
    }
  }
}
