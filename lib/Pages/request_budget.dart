import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shuaal/utils/alert.dart';
import 'package:shuaal/utils/colors.dart';

import '../utils/text.dart';

class RequestBudget extends StatefulWidget {
  const RequestBudget({Key? key}) : super(key: key);

  @override
  State<RequestBudget> createState() => _RequestBudgetClubState();
}

class _RequestBudgetClubState extends State<RequestBudget> {
  TextStyle ts = const TextStyle(
      fontFamily: 'almarai', fontWeight: FontWeight.bold, fontSize: 20);
  OutlineInputBorder outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: primary, width: 2));
  TextEditingController clubName = TextEditingController(),
      topic = TextEditingController(),
      budget = TextEditingController(),
      agenda = TextEditingController();
  bool load = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
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
                text: 'Request Budget | طلب ميزانية',
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
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                child: Column(
                  children: [
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
                            prefixIcon: const Icon(Icons.apps_sharp),
                            enabledBorder: outline,
                            focusedBorder: outline)),
                    const SizedBox(height: 20),
                    TextField(
                        style: ts,
                        controller: topic,
                        decoration: InputDecoration(
                            hintText: 'عنوان الفعالية',
                            hintStyle: ts,
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                            prefixIcon: const Icon(Icons.topic),
                            enabledBorder: outline,
                            focusedBorder: outline)),
                    const SizedBox(height: 20),
                    TextField(
                        style: ts,
                        controller: budget,
                        decoration: InputDecoration(
                            hintText: 'الميزانية المطلوبة',
                            hintStyle: ts,
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                            prefixIcon: const Icon(Icons.money),
                            enabledBorder: outline,
                            focusedBorder: outline)),
                    const SizedBox(height: 20),
                    TextField(
                        style: ts,
                        controller: agenda,
                        maxLines: 5,
                        decoration: InputDecoration(
                            hintText: 'التفاصيل',
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
                          onPressed: () => load ? null : requestBudget(),
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
      ),
    );
  }

  requestBudget() async {
    String id =
        DateTime.now().microsecondsSinceEpoch.toString().substring(3, 9);
    if (clubName.text.isEmpty ||
        topic.text.isEmpty ||
        budget.text.isEmpty ||
        agenda.text.isEmpty) {
      Alert().show(context, 'الرجاء إدخال جميع البيانات');
    } else {
      setState(() => load = true);
      FirebaseFirestore.instance.collection("RequestBudget").doc(id).set({
        "club": clubName.text,
        "topic": topic.text,
        "budget": budget.text,
        "agenda": agenda.text,
        "accept": 0,
        "id": id
      }).then((value) {
        clubName.clear();
        topic.clear();
        budget.clear();
        agenda.clear();
        setState(() => load = false);
        Alert().show(context, 'تم إرسال الطلب بنجاح');
      }).catchError((e) {
        setState(() => load = false);
        Alert().show(context, e.toString());
      });
    }
  }
}
