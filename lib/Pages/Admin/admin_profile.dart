import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuaal/Pages/Admin/view_supervisors.dart';
import 'package:shuaal/Pages/Admin/view_users.dart';
import 'package:shuaal/Pages/Auth/login.dart';
import 'package:shuaal/utils/alert.dart';
import 'package:shuaal/utils/colors.dart';
import 'package:shuaal/utils/text.dart';

class AdminProfle extends StatefulWidget {
  const AdminProfle({Key? key}) : super(key: key);

  @override
  State<AdminProfle> createState() => _AdminProfleState();
}

class _AdminProfleState extends State<AdminProfle> {
  TextStyle ts = const TextStyle(
      fontFamily: 'almarai', fontWeight: FontWeight.bold, fontSize: 20);
  OutlineInputBorder outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: primary, width: 2));
  TextEditingController name = TextEditingController(),
      email = TextEditingController(),
      major = TextEditingController(),
      bio = TextEditingController();
  bool load = false,
      visName = false,
      visEmail = false,
      visMajor = false,
      visBio = false;

  String _name = '', _email = '', _major = '', _bio = '';

  getUserData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(sp.getString('uid'))
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        _name = ds['name'];
        _email = ds['email'];
        _major = ds['major'];
        _bio = ds['bio'];
        url = ds['avatar'];
        name.text = _name;
        email.text = _email;
        major.text = _major;
        bio.text = _bio;
      });
    });
  }

  listen() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(sp.getString('uid'))
        .snapshots()
        .listen((_) {
      setState(() {
        getUserData();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    listen();
  }

  var url;

  var image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/logo_text.png',
                  width: 100,
                ),
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
          Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: image == null
                      ? Image.asset(
                          'assets/images/male_icon.png',
                          width: 80,
                        )
                      : url != null
                          ? Image(image: NetworkImage(url))
                          : Image.file(File(image!.path!)),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();

                  await FilePicker.platform.pickFiles().then((value) {
                    if (value == null) return;
                    print(value.files.first);
                    image = value.files.first;

                    FirebaseStorage.instance
                        .ref()
                        .child("Avatar/${image.name}")
                        .putFile(File(image.path))
                        .then((v) {
                      setState(() {
                        url = v.ref.getDownloadURL();

                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(sp.getString('uid'))
                            .update({"avatar": url});
                      });
                    });
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 60),
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  children: [
                    SizedBox(
                        width: double.infinity,
                        child: text(
                            text: 'الاسم | Name',
                            fontWeight: FontWeight.bold,
                            align: TextAlign.start,
                            size: 18.0)),
                    const SizedBox(height: 10),
                    TextField(
                        style: ts,
                        controller: name,
                        decoration: InputDecoration(
                          hintText: 'الاسم',
                          hintStyle: ts,
                          fillColor: Colors.white,
                          filled: true,
                          suffix: Visibility(
                              visible: visName,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (name.text.isEmpty) {
                                      Alert()
                                          .show(context, 'الرجاء إدخال الاسم');
                                    } else {
                                      SharedPreferences sp =
                                          await SharedPreferences.getInstance();
                                      FirebaseFirestore.instance
                                          .collection("Users")
                                          .doc(sp.getString('uid'))
                                          .update({"name": name.text}).then(
                                              (value) {
                                        Alert().show(
                                            context, 'تم تعديل الاسم بنجاح');
                                        setState(() {
                                          visName = false;
                                          getUserData();
                                        });
                                      }).catchError((e) => Alert()
                                              .show(context, e.toString()));
                                    }
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: primary),
                                      child: const Icon(
                                        Icons.check,
                                        size: 20,
                                        color: Colors.white,
                                      )),
                                ),
                              )),
                          contentPadding: EdgeInsets.zero,
                          prefixIcon: const Icon(Icons.person),
                          enabledBorder: outline,
                          focusedBorder: outline,
                        ),
                        onChanged: (v) {
                          setState(() {
                            if (name.text != _name) {
                              visName = true;
                            } else {
                              visName = false;
                            }
                          });
                        }),
                    const SizedBox(height: 20),
                    SizedBox(
                        width: double.infinity,
                        child: text(
                            text: 'البريد الإلكتروني | Email',
                            fontWeight: FontWeight.bold,
                            align: TextAlign.start,
                            size: 18.0)),
                    const SizedBox(height: 10),
                    TextField(
                        style: ts,
                        controller: email,
                        decoration: InputDecoration(
                            hintText: 'البريد الإلكتروني | Email',
                            hintStyle: ts,
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                            prefixIcon: const Icon(Icons.email),
                            enabledBorder: outline,
                            focusedBorder: outline,
                            suffix: Visibility(
                                visible: visEmail,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (email.text.isEmpty) {
                                        Alert().show(
                                            context, 'الرجاء إدخال الايميل');
                                      } else {
                                        SharedPreferences sp =
                                            await SharedPreferences
                                                .getInstance();
                                        FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(sp.getString('uid'))
                                            .update({"email": email.text}).then(
                                                (value) {
                                          Alert().show(context,
                                              'تم تعديل الإيميل بنجاح');
                                          setState(() {
                                            visEmail = false;
                                            getUserData();
                                          });
                                        }).catchError((e) => Alert()
                                                .show(context, e.toString()));
                                      }
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: primary),
                                        child: const Icon(
                                          Icons.check,
                                          size: 20,
                                          color: Colors.white,
                                        )),
                                  ),
                                ))),
                        onChanged: (v) {
                          setState(() {
                            if (email.text != _email) {
                              visEmail = true;
                            } else {
                              visEmail = false;
                            }
                          });
                        }),
                    const SizedBox(height: 15),
                    SizedBox(
                        width: double.infinity,
                        child: text(
                            text: 'التخصص | Major',
                            fontWeight: FontWeight.bold,
                            align: TextAlign.start,
                            size: 18.0)),
                    const SizedBox(height: 10),
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
                            focusedBorder: outline,
                            suffix: Visibility(
                                visible: visMajor,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (major.text.isEmpty) {
                                        Alert().show(
                                            context, 'الرجاء إدخال التخصص');
                                      } else {
                                        SharedPreferences sp =
                                            await SharedPreferences
                                                .getInstance();
                                        FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(sp.getString('uid'))
                                            .update({"major": major.text}).then(
                                                (value) {
                                          Alert().show(
                                              context, 'تم تعديل التخصص بنجاح');
                                          setState(() {
                                            visMajor = false;
                                            getUserData();
                                          });
                                        }).catchError((e) => Alert()
                                                .show(context, e.toString()));
                                      }
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: primary),
                                        child: const Icon(
                                          Icons.check,
                                          size: 20,
                                          color: Colors.white,
                                        )),
                                  ),
                                ))),
                        onChanged: (v) {
                          setState(() {
                            if (major.text != _major) {
                              visMajor = true;
                            } else {
                              visMajor = false;
                            }
                          });
                        }),
                    const SizedBox(height: 15),
                    SizedBox(
                        width: double.infinity,
                        child: text(
                            text: 'الوصف المختصر | Bio',
                            fontWeight: FontWeight.bold,
                            align: TextAlign.start,
                            size: 18.0)),
                    const SizedBox(height: 10),
                    TextField(
                        style: ts,
                        controller: bio,
                        maxLines: 5,
                        decoration: InputDecoration(
                            hintText: 'وصف مختصر',
                            hintStyle: ts,
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                            prefixIcon:
                                const Icon(Icons.document_scanner_outlined),
                            enabledBorder: outline,
                            focusedBorder: outline,
                            suffix: Visibility(
                                visible: visBio,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (bio.text.isEmpty) {
                                        Alert().show(context,
                                            'الرجاء إدخال الوصف المختصر');
                                      } else {
                                        SharedPreferences sp =
                                            await SharedPreferences
                                                .getInstance();
                                        FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(sp.getString('uid'))
                                            .update({"bio": bio.text}).then(
                                                (value) {
                                          Alert().show(context,
                                              'تم تعديل الوصف المختصر بنجاح');
                                          setState(() {
                                            visBio = false;
                                            getUserData();
                                          });
                                        }).catchError((e) => Alert()
                                                .show(context, e.toString()));
                                      }
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: primary),
                                        child: const Icon(
                                          Icons.check,
                                          size: 20,
                                          color: Colors.white,
                                        )),
                                  ),
                                ))),
                        onChanged: (v) {
                          setState(() {
                            if (bio.text != _bio) {
                              visBio = true;
                            } else {
                              visBio = false;
                            }
                          });
                        }),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ViewSupervisors()));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.admin_panel_settings),
                              text(
                                  text: 'عرض جميع المشرفين',
                                  size: 18.0,
                                  fontWeight: FontWeight.bold),
                              const Icon(Icons.arrow_back_ios_new)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ViewUsers()));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.person),
                              text(
                                  text: 'عرض جميع المستخدمين',
                                  size: 18.0,
                                  fontWeight: FontWeight.bold),
                              const Icon(Icons.arrow_back_ios_new)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.podcasts),
                            text(
                                text: 'عرض جميع الفعاليات',
                                size: 18.0,
                                fontWeight: FontWeight.bold),
                            const Icon(Icons.arrow_back_ios_new)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.apps_outlined),
                            text(
                                text: 'عرض جميع الأندية',
                                size: 18.0,
                                fontWeight: FontWeight.bold),
                            const Icon(Icons.arrow_back_ios_new)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FlatButton(
                          color: Colors.red[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          onPressed: () async {
                            SharedPreferences sp =
                                await SharedPreferences.getInstance();
                            sp.remove('uid');
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                                (route) => false);
                          },
                          child: text(
                              text: 'تسجيل الخروج',
                              size: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
