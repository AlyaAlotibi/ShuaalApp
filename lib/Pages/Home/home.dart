import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuaal/utils/colors.dart';
import 'package:shuaal/utils/text.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = '';

  List posts = [];

  bool load = false;

  getPosts() async {
    setState(() => load = true);
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Posts")
        .orderBy('time', descending: true)
        .get();
    setState(() => load = false);
    return qs.docs;
  }

  getUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(sp.getString('uid'))
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        name = ds['name'];
      });
    });
  }

  listenPosts() {
    FirebaseFirestore.instance.collection("Posts").snapshots().listen((_) {
      setState(() {
        getPosts().then((data) => setState(() => posts = data));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
    listenPosts();
  }

  ScreenshotController screenshot = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bg,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => addEvent(),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                  Expanded(
                      child: text(
                          text: 'أحدث الفعاليات',
                          size: 25.0,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ),
            Expanded(
              child: posts.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: text(
                            text:
                                'لا يوجد فعاليات أضغط على علامة + لإضافة فعالية جديدة',
                            size: 20.0,
                            height: 1.5,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : load
                      ? SpinKitThreeBounce(color: primary)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          itemCount: posts.length,
                          itemBuilder: (_, index) {
                            return Screenshot(
                              controller: ScreenshotController(),
                              child: Card(
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            'assets/images/male_icon.png',
                                            width: 50,
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 5),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: text(
                                                      text: posts[index]
                                                          ['name'],
                                                      align: TextAlign.start,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      size: 17.0),
                                                ),
                                                const SizedBox(height: 5),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: text(
                                                      text: posts[index]
                                                          ['clubName'],
                                                      size: 12.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      align: TextAlign.start),
                                                )
                                              ],
                                            ),
                                          ),
                                          text(
                                              text: DateFormat.Hm().format(
                                                  DateTime.parse(posts[index]
                                                          ['time']
                                                      .toDate()
                                                      .toString())))
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                          width: double.infinity,
                                          child: text(
                                              text: posts[index]['twitte'],
                                              align: TextAlign.start)),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Share.share(
                                                  "${posts[index]['name']}\n${posts[index]['twitte']}");
                                            },
                                            child: const Icon(Icons.ios_share),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
            )
          ],
        ));
  }

  addEvent() {
    TextStyle ts = const TextStyle(
        fontFamily: 'almarai', fontWeight: FontWeight.bold, fontSize: 20);
    OutlineInputBorder outline = OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primary, width: 2));
    TextEditingController clubName = TextEditingController(),
        twitte = TextEditingController();
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
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
                TextField(
                  style: ts,
                  controller: clubName,
                  decoration: InputDecoration(
                      hintText: 'اسم النادي',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.apps_sharp),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: outline,
                      focusedBorder: outline),
                ),
                const SizedBox(height: 20),
                TextField(
                  style: ts,
                  controller: twitte,
                  maxLines: 5,
                  decoration: InputDecoration(
                      hintText: 'نص التغريدة',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.text_snippet_outlined),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: outline,
                      focusedBorder: outline),
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
                        FirebaseFirestore.instance.collection("Posts").add({
                          "name": name,
                          "clubName": clubName.text,
                          "twitte": twitte.text,
                          "time": DateTime.now(),
                        }).then((value) {
                          clubName.clear();
                          twitte.clear();
                          Navigator.pop(context);
                        });
                      },
                      child: text(
                          text: 'نشر',
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
