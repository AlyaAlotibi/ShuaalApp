import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuaal/Pages/suggest_club.dart';
import 'package:shuaal/utils/alert.dart';
import 'package:shuaal/utils/colors.dart';
import 'package:shuaal/utils/text.dart';

class Clubs extends StatefulWidget {
  const Clubs({Key? key}) : super(key: key);

  @override
  State<Clubs> createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> {
  List clubs = [];
  bool load = false;

  getEvents() async {
    setState(() => load = true);
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("Clubs").get();
    setState(() => load = false);
    return qs.docs;
  }

  listenScoreboard() {
    FirebaseFirestore.instance.collection("Clubs").snapshots().listen((_) {
      setState(() {
        getEvents().then((data) => setState(() => clubs = data));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    listenScoreboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bg,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
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
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SuggestClub())),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: text(
                                    text: 'اقتراح نادي',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    size: 18.0)),
                          )
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
            text(
                text: 'الأندية | Clubs',
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
            Expanded(
                child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    itemCount: clubs.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 1 / 1.5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 0),
                    itemBuilder: (_, index) {
                      return Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            margin: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: clubs[index]['logo'] == null
                                  ? const Icon(Icons.image)
                                  : Image(
                                      image: NetworkImage(clubs[index]['logo']),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          text(
                              text: clubs[index]['club'],
                              size: 18.0,
                              fontWeight: FontWeight.bold),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              width: double.infinity,
                              child: FlatButton(
                                  color: primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: () async {
                                    bool found = false;
                                    SharedPreferences sp =
                                        await SharedPreferences.getInstance();

                                    QuerySnapshot qs = await FirebaseFirestore
                                        .instance
                                        .collection("Users")
                                        .doc(sp.getString('uid'))
                                        .collection("clubs")
                                        .get();

                                    for (int i = 0; i < qs.docs.length; i++) {
                                      if (qs.docs[i]['club'] ==
                                          clubs[index]['club']) {
                                        setState(() {
                                          found = true;
                                        });
                                      }
                                    }

                                    if (found) {
                                      Alert().show(
                                          context, 'انضممت الى النادي مسبقاً');
                                    } else {
                                      await FirebaseFirestore.instance
                                          .collection("Users")
                                          .doc(sp.getString('uid'))
                                          .collection("clubs")
                                          .add({
                                        "club": clubs[index]['club'],
                                        "logo": clubs[index]['logo'],
                                      }).then((value) => Alert().show(context,
                                              'تم الإنضمام إلى نادي ${clubs[index]["club"]}'));
                                    }
                                  },
                                  child: text(
                                      text: 'انضمام | Join',
                                      size: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          )
                        ],
                      );
                    }))
          ],
        ));
  }
}
