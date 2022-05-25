// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuaal/utils/alert.dart';
import 'package:shuaal/utils/colors.dart';
import 'package:shuaal/utils/text.dart';

import '../Home/home_screen.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextStyle ts = const TextStyle(
      fontFamily: 'almarai', fontWeight: FontWeight.bold, fontSize: 20);
  OutlineInputBorder outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: primary, width: 2));
  TextEditingController name = TextEditingController(),
      email = TextEditingController(),
      password1 = TextEditingController(),
      password2 = TextEditingController();
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
                      text: 'حساب جديد',
                      size: 25.0,
                      fontWeight: FontWeight.bold),
                  Image.asset(
                    "assets/images/logo.png",
                    width: 130,
                  ),
                  const SizedBox(height: 30),
                  TextField(
                      style: ts,
                      controller: name,
                      decoration: InputDecoration(
                          hintText: 'الاسم الكامل',
                          hintStyle: ts,
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15),
                          prefixIcon: const Icon(Icons.person),
                          enabledBorder: outline,
                          focusedBorder: outline)),
                  const SizedBox(height: 20),
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
                      controller: password1,
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
                  const SizedBox(height: 20),
                  TextField(
                      style: ts,
                      controller: password2,
                      obscureText: vis,
                      decoration: InputDecoration(
                          hintText: 'تأكيد كلمة المرور',
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
                              text: 'تسجيل',
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
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            alignment: Alignment.topRight,
            width: double.infinity,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  login() async {
    if (name.text.isEmpty) {
      Alert().show(context, 'الرجاء إدخال الاسم الكامل');
    } else if (email.text.isEmpty) {
      Alert().show(context, 'الرجاء إدخال البريد الإلكتروني');
    } else if (password1.text.isEmpty) {
      Alert().show(context, 'الرجاء إدخال كلمة المرور');
    } else if (password2.text.isEmpty) {
      Alert().show(context, 'الرجاء إدخال تأكيد كلمة المرور');
    } else if (password1.text != password2.text) {
      Alert().show(context, 'كلمة المرور غير متطابقة');
    } else {
      setState(() => load = true);
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password1.text)
          .then((value) async {
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString('uid', value.user!.uid);

        FirebaseFirestore.instance
            .collection("Users")
            .doc(value.user!.uid)
            .set({
          "name": name.text,
          "email": email.text,
          "bio": '',
          "major": '',
          "avatar": '',
          "id": value.user!.uid,
          "isAdmin": false,
          "isSupervisor": false
        }).then((value) {
          setState(() => load = false);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (builder) => const HomeScreen()),
              (route) => false);
        }).catchError((e) {
          setState(() => load = false);
          Alert().show(context, e.toString());
          print(e.code);
        });
      }).catchError((e) {
        setState(() => load = false);

        if (e.code == 'invalid-email') {
          Alert().show(context, 'البريد الإلكتروني غير صحيح');
        } else if (e.code == 'weak-password') {
          Alert().show(context, 'كلمة المرور ضعيفة جداً');
        } else {
          Alert().show(context, e.toString());
        }
        print(e.code);
      });
    }
  }
}
