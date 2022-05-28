import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuaal/Pages/Auth/login.dart';
import 'package:shuaal/utils/alert.dart';
import 'package:shuaal/utils/colors.dart';
import 'package:shuaal/utils/text.dart';

class ViewDetails extends StatefulWidget {
  String id = '';
  ViewDetails(this.id, {Key? key}) : super(key: key);

  @override
  State<ViewDetails> createState() => _ViewDetailsState(id);
}

class _ViewDetailsState extends State<ViewDetails> {
  String id = '';
  _ViewDetailsState(this.id);
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

  List clubs = [], badges = [], tasks = [];

  getClubs() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() => load = true);
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .collection("clubs")
        .get();
    setState(() => load = false);
    return qs.docs;
  }

  getTasks() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() => load = true);
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .collection("tasks")
        .get();
    setState(() => load = false);
    return qs.docs;
  }

  getBadges() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() => load = true);
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .collection("badges")
        .get();
    setState(() => load = false);
    return qs.docs;
  }

  listenClubs() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .collection("clubs")
        .snapshots()
        .listen((_) {
      setState(() {
        getClubs().then((data) => setState(() => clubs = data));
      });
    });
  }

  listenTasks() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .collection("tasks")
        .snapshots()
        .listen((_) {
      setState(() {
        getTasks().then((data) => setState(() => tasks = data));
      });
    });
  }

  listenBadges() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .collection("badges")
        .snapshots()
        .listen((_) {
      setState(() {
        getBadges().then((data) => setState(() => badges = data));
      });
    });
  }

  getUserData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
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

  @override
  void initState() {
    super.initState();
    getUserData();
    listenClubs();
    listenBadges();
    listenTasks();
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
                            .doc(id)
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
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: 'الاسم',
                          hintStyle: ts,
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.zero,
                          prefixIcon: const Icon(Icons.person),
                          disabledBorder: outline,
                        )),
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
                        enabled: false,
                        decoration: InputDecoration(
                            hintText: 'البريد الإلكتروني | Email',
                            hintStyle: ts,
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                            prefixIcon: const Icon(Icons.email),
                            disabledBorder: outline)),
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
                        enabled: false,
                        decoration: InputDecoration(
                            hintText: 'التخصص',
                            hintStyle: ts,
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                            prefixIcon: const Icon(Icons.adjust),
                            disabledBorder: outline)),
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
                        enabled: false,
                        decoration: InputDecoration(
                            hintText: 'وصف مختصر',
                            hintStyle: ts,
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                            prefixIcon:
                                const Icon(Icons.document_scanner_outlined),
                            disabledBorder: outline)),
                    const SizedBox(height: 15),
                    SizedBox(
                        width: double.infinity,
                        child: text(
                            text: 'أندية مسجلة | Clubs Enrolled',
                            fontWeight: FontWeight.bold,
                            align: TextAlign.start,
                            size: 18.0)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 230,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: clubs.isEmpty
                            ? Center(
                                child: text(
                                    text: 'لا يوجد أندية مسجلة',
                                    fontWeight: FontWeight.bold),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: clubs.length,
                                itemBuilder: (_, index) {
                                  return Column(
                                    children: [
                                      Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        margin: const EdgeInsets.all(10),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: clubs[index]['logo'] == null
                                              ? const Icon(Icons.image)
                                              : Image(
                                                  image: NetworkImage(
                                                      clubs[index]['logo']),
                                                  width: 150,
                                                ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      text(
                                          text: clubs[index]['club'],
                                          size: 18.0,
                                          fontWeight: FontWeight.bold)
                                    ],
                                  );
                                }),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text(
                            text: 'شارات | Badges',
                            fontWeight: FontWeight.bold,
                            align: TextAlign.start,
                            size: 18.0),
                        FlatButton.icon(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: primary,
                            onPressed: () => addBadges(),
                            icon: const Icon(
                              Icons.add_moderator_outlined,
                              color: Colors.white,
                            ),
                            label: text(
                                text: 'منح شارة',
                                fontWeight: FontWeight.bold,
                                color: Colors.white))
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: badges.isEmpty
                            ? Center(
                                child: text(
                                    text: 'لا يوجد شارات',
                                    fontWeight: FontWeight.bold),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(top: 5),
                                scrollDirection: Axis.horizontal,
                                itemCount: badges.length,
                                itemBuilder: (_, index) {
                                  return Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/badges.png',
                                        width: 120,
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: 150,
                                        child: text(
                                            height: 1.5,
                                            text: badges[index]['text'],
                                            size: 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  );
                                }),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text(
                            text: 'مهام | Tasks',
                            fontWeight: FontWeight.bold,
                            align: TextAlign.start,
                            size: 18.0),
                        FlatButton.icon(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: primary,
                            onPressed: () => addTask(),
                            icon: const Icon(
                              Icons.add_task,
                              color: Colors.white,
                            ),
                            label: text(
                                text: 'إضافة مهم',
                                fontWeight: FontWeight.bold,
                                color: Colors.white))
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 420,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: tasks.isEmpty
                            ? Center(
                                child: text(
                                    text: 'لا يوجد مهام',
                                    fontWeight: FontWeight.bold),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(
                                    top: 5, right: 10, left: 10),
                                itemCount: tasks.length,
                                itemBuilder: (_, index) {
                                  return GestureDetector(
                                    onTap: () => viewTask(tasks[index]['text'],
                                        tasks[index]['date']),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            text(
                                                text: tasks[index]['text'],
                                                size: 20.0,
                                                fontWeight: FontWeight.bold),
                                            const SizedBox(height: 5),
                                            text(
                                                text: tasks[index]['date'],
                                                size: 17.0),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20),
                                                        color:
                                                            tasks[index]['done'] == 1
                                                                ? primary
                                                                : Colors.white,
                                                        border: Border.all(
                                                            width: 1,
                                                            color: primary)),
                                                    child: FlatButton.icon(
                                                        onPressed: () async {
                                                          Alert().show(context,
                                                              'لا يمكنك التعديل على هذه المهمة');
                                                        },
                                                        icon: Icon(Icons.check,
                                                            color: tasks[index]['done'] == 1
                                                                ? Colors.white
                                                                : primary),
                                                        label: text(
                                                            text: 'مكتمل',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            size: 16.0,
                                                            color: tasks[index]
                                                                        ['done'] ==
                                                                    1
                                                                ? Colors.white
                                                                : primary))),
                                                const SizedBox(width: 10),
                                                Container(
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: tasks[index]
                                                                  ['done'] ==
                                                              2
                                                          ? primary
                                                          : Colors.white,
                                                      border: Border.all(
                                                          color: primary,
                                                          width: 1)),
                                                  child: FlatButton.icon(
                                                      onPressed: () async {
                                                        Alert().show(context,
                                                            'لا يمكنك التعديل على هذه المهمة');
                                                      },
                                                      icon: Icon(Icons.close,
                                                          color: tasks[index][
                                                                      'done'] ==
                                                                  2
                                                              ? Colors.white
                                                              : primary),
                                                      label: text(
                                                          text: 'غير مكتمل',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          size: 16.0,
                                                          color: tasks[index][
                                                                      'done'] ==
                                                                  2
                                                              ? Colors.white
                                                              : primary)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  addBadges() {
    TextEditingController badges = TextEditingController();
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 80,
                  height: 6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black45),
                ),
                const SizedBox(height: 30),
                SizedBox(
                    width: double.infinity,
                    child: text(
                        text: 'نص الشارة',
                        align: TextAlign.start,
                        fontWeight: FontWeight.bold,
                        size: 20.0)),
                const SizedBox(height: 20),
                TextField(
                  style: ts,
                  enabled: true,
                  controller: badges,
                  decoration: InputDecoration(
                      hintText: 'نص الشارة',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.admin_panel_settings),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: outline,
                      focusedBorder: outline),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: FlatButton(
                      color: primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(id)
                            .collection("badges")
                            .add({"text": badges.text}).then((value) {
                          Navigator.pop(context);
                          Alert().show(context, 'تم منح المستخدم شارة');
                        });
                      },
                      child: text(
                          text: 'منح',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          size: 23.0)),
                ),
                const SizedBox(height: 30),
              ]));
        });
  }

  addTask() {
    TextEditingController task = TextEditingController();
    TextEditingController date = TextEditingController();
    DateTime dateTime = DateTime.now();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 80,
                  height: 6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black45),
                ),
                const SizedBox(height: 30),
                SizedBox(
                    width: double.infinity,
                    child: text(
                        text: 'نص المهمة',
                        align: TextAlign.start,
                        fontWeight: FontWeight.bold,
                        size: 20.0)),
                const SizedBox(height: 20),
                TextField(
                  style: ts,
                  enabled: true,
                  controller: task,
                  decoration: InputDecoration(
                      hintText: 'نص المهمة',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.admin_panel_settings),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: outline,
                      focusedBorder: outline),
                ),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    child: text(
                        text: 'موعد التسليم',
                        align: TextAlign.start,
                        fontWeight: FontWeight.bold,
                        size: 20.0)),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    ).then((d) => setState(
                        (() => date.text = DateFormat.yMMMEd().format(d!))));
                  },
                  child: TextField(
                    style: ts,
                    enabled: false,
                    controller: date,
                    decoration: InputDecoration(
                        hintText: 'اختر موعد التسليم',
                        hintStyle: ts,
                        prefixIcon: const Icon(Icons.date_range),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15),
                        disabledBorder: outline),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: FlatButton(
                      color: primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(id)
                            .collection("tasks")
                            .add({
                          "text": task.text,
                          "date": date.text,
                          "done": 0
                        }).then((value) {
                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(id)
                              .collection("tasks")
                              .doc(value.id)
                              .update({'id': value.id});
                          Navigator.pop(context);
                          Alert().show(context, 'تم إضافة مهمة جديدة');
                        });
                      },
                      child: text(
                          text: 'إضافة',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          size: 23.0)),
                ),
                const SizedBox(height: 30),
              ]));
        });
  }

  viewTask(_task, _date) {
    TextEditingController task = TextEditingController();
    TextEditingController date = TextEditingController();

    task.text = _task;
    date.text = _date;

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 80,
                  height: 6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black45),
                ),
                const SizedBox(height: 30),
                SizedBox(
                    width: double.infinity,
                    child: text(
                        text: 'نص المهمة',
                        align: TextAlign.start,
                        fontWeight: FontWeight.bold,
                        size: 20.0)),
                const SizedBox(height: 20),
                TextField(
                  style: ts,
                  enabled: false,
                  controller: task,
                  maxLines: 5,
                  decoration: InputDecoration(
                      hintText: 'نص المهمة',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.admin_panel_settings),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      disabledBorder: outline),
                ),
                const SizedBox(height: 15),
                SizedBox(
                    width: double.infinity,
                    child: text(
                        text: 'موعد التسليم',
                        align: TextAlign.start,
                        fontWeight: FontWeight.bold,
                        size: 20.0)),
                const SizedBox(height: 20),
                TextField(
                  style: ts,
                  enabled: false,
                  controller: date,
                  decoration: InputDecoration(
                      hintText: 'اختر موعد التسليم',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.date_range),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      disabledBorder: outline),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: FlatButton(
                      color: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: text(
                          text: 'رجوع',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          size: 23.0)),
                ),
                const SizedBox(height: 30),
              ]));
        });
  }
}
