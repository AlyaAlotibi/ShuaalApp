import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shuaal/utils/colors.dart';
import 'package:shuaal/utils/text.dart';

class Scoreboard extends StatefulWidget {
  const Scoreboard({Key? key}) : super(key: key);

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  List scoreboard = [];
  bool load = false;

  getEvents() async {
    setState(() => load = true);
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Scoreboard")
        .orderBy('rate', descending: true)
        .get();
    setState(() => load = false);
    return qs.docs;
  }

  listenScoreboard() {
    FirebaseFirestore.instance.collection("Scoreboard").snapshots().listen((_) {
      setState(() {
        getEvents().then((data) => setState(() => scoreboard = data));
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                width: double.infinity,
                child: text(
                    text: 'المتصدرين',
                    size: 20.0,
                    fontWeight: FontWeight.bold,
                    align: TextAlign.start),
              ),
            ),
            Expanded(
                child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.all(15),
              child: scoreboard.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: text(
                            text: 'لا يوجد متصدرين',
                            size: 20.0,
                            height: 1.5,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : load
                      ? SpinKitThreeBounce(color: primary)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          itemCount: scoreboard.length,
                          itemBuilder: (_, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: scoreboard_card,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/star.png'))),
                                      child: Center(
                                        child: text(
                                            text: '${index + 1}',
                                            fontWeight: FontWeight.bold,
                                            size: 16.0),
                                      ),
                                    ),
                                    text(
                                        text: scoreboard[index]['club'],
                                        fontWeight: FontWeight.bold,
                                        size: 18.0),
                                    text(
                                        text: scoreboard[index]['rate'],
                                        size: 16.0,
                                        fontWeight: FontWeight.bold)
                                  ],
                                ),
                              ),
                            );
                          }),
            ))
          ],
        ));
  }
}
