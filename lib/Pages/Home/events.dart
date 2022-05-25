import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../utils/colors.dart';
import '../../utils/text.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List events = [];
  bool load = false;
  DateTime dateTime = DateTime.now();

  var ranking = 'ترتيب تصاعدي';
  final _ranking = ['ترتيب تصاعدي', 'ترتيب تنازلي'];

  getEvents() async {
    setState(() => load = true);
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Events")
        .orderBy('sTime', descending: ranking == 'ترتيب تصاعدي' ? false : true)
        .get();
    setState(() => load = false);
    events.clear();
    for (int i = 0; i < qs.docs.length; i++) {
      if (DateFormat.yMMMEd().format(dateTime) ==
          DateFormat.yMMMEd().format(
              DateTime.parse(qs.docs[i]['sTime'].toDate().toString()))) {
        events.add(qs.docs[i]);
      }
    }
    return qs.docs;
  }

  listenEvents() {
    FirebaseFirestore.instance.collection("Events").snapshots().listen((_) {
      setState(() {
        getEvents();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    listenEvents();
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DatePicker(
                  DateTime.now(),
                  daysCount: 30,
                  initialSelectedDate: dateTime,
                  selectionColor: primary,
                  selectedTextColor: Colors.white,
                  onDateChange: (date) {
                    // New date selected
                    setState(() {
                      dateTime = date;
                      listenEvents();
                    });
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  text(text: 'الوقت', size: 18.0, fontWeight: FontWeight.bold),
                  const SizedBox(
                    height: 30,
                    child: VerticalDivider(
                      thickness: 2,
                      width: 10,
                    ),
                  ),
                  text(text: 'النشاط', size: 18.0, fontWeight: FontWeight.bold),
                  const Spacer(),
                  PopupMenuButton(
                    color: primary,
                    icon: const Icon(Icons.filter_list,
                        color: Colors.black, size: 30),
                    offset: const Offset(0, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    itemBuilder: (BuildContext context) => List.generate(
                      _ranking.length,
                      (index) => PopupMenuItem(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        value: _ranking[index],
                        onTap: () {
                          setState(() {
                            ranking = _ranking[index];
                            listenEvents();
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              _ranking[index],
                              style: const TextStyle(
                                fontFamily: 'almarai',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: events.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: text(
                            text: 'لا يوجد أحداث في التاريخ المحدد',
                            size: 20.0,
                            height: 1.5,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : load
                      ? SpinKitThreeBounce(color: primary)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          itemCount: events.length,
                          itemBuilder: (_, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: [
                                          text(
                                              text: DateFormat.Hm().format(
                                                  DateTime.parse(events[index]
                                                          ['sTime']
                                                      .toDate()
                                                      .toString())),
                                              size: 18.0,
                                              fontWeight: FontWeight.bold),
                                          const SizedBox(height: 10),
                                          Container(
                                            height: 15,
                                            width: 15,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: primary),
                                          ),
                                          Container(
                                            height: 70,
                                            color: primary,
                                            width: 2,
                                          ),
                                          Container(
                                            height: 15,
                                            width: 15,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: primary),
                                          ),
                                          const SizedBox(height: 10),
                                          text(
                                              text: DateFormat.Hm().format(
                                                  DateTime.parse(events[index]
                                                          ['eTime']
                                                      .toDate()
                                                      .toString())),
                                              size: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              text(
                                                  text: events[index]['club'],
                                                  size: 20.0,
                                                  fontWeight: FontWeight.bold),
                                              text(
                                                  text: events[index]['course'],
                                                  size: 16.0,
                                                  height: 2.0,
                                                  fontWeight: FontWeight.w300),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  text(
                                                      text: events[index]
                                                          ['location'],
                                                      size: 14.0)
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.person,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  text(
                                                      text: events[index]
                                                          ['speaker'],
                                                      size: 14.0)
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.link,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  text(
                                                      text: events[index]
                                                          ['link'],
                                                      size: 14.0)
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                              ],
                            );
                          }),
            )
          ],
        ));
  }
}
