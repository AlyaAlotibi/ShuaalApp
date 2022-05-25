import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shuaal/utils/alert.dart';
import 'package:shuaal/utils/colors.dart';

import '../utils/text.dart';

class SuggestClub extends StatefulWidget {
  const SuggestClub({Key? key}) : super(key: key);

  @override
  State<SuggestClub> createState() => _SuggestClubState();
}

class _SuggestClubState extends State<SuggestClub> {
  TextStyle ts = const TextStyle(
      fontFamily: 'almarai', fontWeight: FontWeight.bold, fontSize: 20);
  OutlineInputBorder outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: primary, width: 2));
  TextEditingController name = TextEditingController(),
      major = TextEditingController(),
      clubName = TextEditingController(),
      desc = TextEditingController();
  bool load = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Card(
                    color: primary,
                    margin: const EdgeInsets.only(right: 10, top: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/images/add_clubs.png',
                            width: 50,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    )),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 70,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          text(
              text: 'اقتراح نادي | Suggest Club',
              size: 25.0,
              fontWeight: FontWeight.bold),
          SizedBox(
            width: 200,
            child: Divider(
              thickness: 2,
              height: 50,
              color: primary,
            ),
          ),
          const SizedBox(height: 30),
          Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              child: Column(
                children: [
                  TextField(
                      style: ts,
                      controller: name,
                      decoration: InputDecoration(
                          hintText: 'الاسم',
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
                      controller: major,
                      decoration: InputDecoration(
                          hintText: 'التخصص',
                          hintStyle: ts,
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15),
                          prefixIcon: const Icon(Icons.adjust),
                          enabledBorder: outline,
                          focusedBorder: outline)),
                  const SizedBox(height: 20),
                  TextField(
                      style: ts,
                      controller: clubName,
                      decoration: InputDecoration(
                          hintText: 'اسم النادي',
                          hintStyle: ts,
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15),
                          prefixIcon: const Icon(Icons.blur_linear_rounded),
                          enabledBorder: outline,
                          focusedBorder: outline)),
                  const SizedBox(height: 20),
                  TextField(
                      style: ts,
                      controller: desc,
                      maxLines: 5,
                      decoration: InputDecoration(
                          hintText: 'وصف مختصر عن النادي',
                          hintStyle: ts,
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15),
                          prefixIcon: const Icon(Icons.description),
                          enabledBorder: outline,
                          focusedBorder: outline)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        color: primary,
                        onPressed: () => load ? null : suggestClub(),
                        child: load
                            ? const SpinKitThreeBounce(color: Colors.white)
                            : text(
                                text: 'إرسال',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                size: 22.0)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  suggestClub() async {
    if (name.text.isEmpty ||
        major.text.isEmpty ||
        clubName.text.isEmpty ||
        desc.text.isEmpty) {
      Alert().show(context, 'الرجاء إدخال جميع البيانات');
    } else {
      setState(() => load = true);
      FirebaseFirestore.instance.collection("SuggestClub").add({
        "name": name.text,
        "major": major.text,
        "clubName": clubName.text,
        "desc": desc.text
      }).then((value) {
        name.clear();
        major.clear();
        clubName.clear();
        desc.clear();
        setState(() => load = false);
        Alert().show(context, 'تم إرسال الإقتراح بنجاح');
      }).catchError((e) {
        setState(() => load = false);
        Alert().show(context, e.toString());
      });
    }
  }
}
