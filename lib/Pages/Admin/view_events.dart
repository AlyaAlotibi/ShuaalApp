import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shuaal/utils/colors.dart';

import '../../utils/alert.dart';
import '../../utils/text.dart';

class ViewEvents extends StatefulWidget {
  const ViewEvents({Key? key}) : super(key: key);

  @override
  State<ViewEvents> createState() => _ViewEventsState();
}

class _ViewEventsState extends State<ViewEvents> {
  List supervisors = [];
  bool load = true;
  getsupervisors() async {
    setState(() => load = true);
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("Events").get();
    setState(() => load = false);

    return qs.docs;
  }

  listensupervisors() {
    FirebaseFirestore.instance.collection("Events").snapshots().listen((_) {
      getsupervisors().then((data) => setState(() => supervisors = data));
    });
  }

  @override
  void initState() {
    super.initState();
    listensupervisors();
  }

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
          text(text: 'المشرفين', size: 25.0, fontWeight: FontWeight.bold),
          SizedBox(
            width: 200,
            child: Divider(
              thickness: 2,
              height: 50,
              color: primary,
            ),
          ),
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: ListView.builder(
                  itemCount: supervisors.length,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () => details(
                          supervisors[index]['id'],
                          supervisors[index]['avatar'],
                          supervisors[index]['name'],
                          supervisors[index]['email'],
                          supervisors[index]['major'],
                          supervisors[index]['bio']),
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  supervisors[index]['avatar'] != ''
                                      ? Image(
                                          image: NetworkImage(
                                              supervisors[index]['avatar']))
                                      : Image.asset(
                                          'assets/images/male_icon.png',
                                          width: 45,
                                        ),
                                  Column(
                                    children: [
                                      text(
                                          text: supervisors[index]['name'],
                                          fontWeight: FontWeight.bold),
                                      text(text: supervisors[index]['email']),
                                    ],
                                  ),
                                  const Icon(Icons.visibility_outlined),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  details(
    id,
    avatar,
    name,
    email,
    major,
    bio,
  ) {
    TextStyle ts = const TextStyle(
        fontFamily: 'almarai', fontWeight: FontWeight.bold, fontSize: 20);
    OutlineInputBorder outline = OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primary, width: 2));

    TextEditingController _name = TextEditingController();
    TextEditingController _email = TextEditingController();
    TextEditingController _major = TextEditingController();
    TextEditingController _bio = TextEditingController();
    _name.text = name;
    _email.text = email;
    _major.text = major;
    _bio.text = bio;
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 80,
                  height: 6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black45),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: avatar == ''
                          ? Image.asset(
                              'assets/images/male_icon.png',
                              width: 80,
                            )
                          : Image(image: NetworkImage(avatar))),
                ),
                const SizedBox(height: 20),
                TextField(
                  style: ts,
                  enabled: false,
                  controller: _name,
                  decoration: InputDecoration(
                      hintText: 'الاسم',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.person),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      disabledBorder: outline),
                ),
                const SizedBox(height: 10),
                TextField(
                  style: ts,
                  enabled: false,
                  controller: _email,
                  decoration: InputDecoration(
                      hintText: 'البريد الإلكتروني',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.person),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      disabledBorder: outline),
                ),
                const SizedBox(height: 10),
                TextField(
                  style: ts,
                  enabled: false,
                  controller: _major,
                  decoration: InputDecoration(
                      hintText: 'التخصص',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.person),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      disabledBorder: outline),
                ),
                const SizedBox(height: 20),
                TextField(
                  enabled: false,
                  maxLines: 5,
                  controller: _bio,
                  decoration: InputDecoration(
                      hintText: 'الوصف المختصر',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.text_snippet_outlined),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      disabledBorder: outline),
                ),
                const SizedBox(height: 30),
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
                            .update({"isSupervisor": false}).then((value) {
                          Navigator.pop(context);
                          Alert().show(
                              context, 'تم إزالة الإشراف من المشرف $name');
                        });
                      },
                      child: text(
                          text: 'إزالة الإشراف',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          size: 23.0)),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: FlatButton(
                      color: Colors.red[900],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(id)
                            .delete()
                            .then((value) {
                          Navigator.pop(context);
                          Alert().show(context, 'تم حذف المشرف $name بنجاح');
                        });
                      },
                      child: text(
                          text: 'حذف المشرف',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          size: 23.0)),
                ),
                const SizedBox(height: 15),
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
                )
              ],
            ),
          );
        });
  }
}
