import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shuaal/utils/colors.dart';
import '../../utils/alert.dart';
import '../../utils/text.dart';
import '../Supervisor/view_details.dart';

class ViewRequestBudget extends StatefulWidget {
  const ViewRequestBudget({Key? key}) : super(key: key);

  @override
  State<ViewRequestBudget> createState() => _ViewRequestBudgetState();
}

class _ViewRequestBudgetState extends State<ViewRequestBudget> {
  List requestBudget = [];
  bool load = true;
  getRequestBudget() async {
    setState(() => load = true);
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("RequestBudget").get();
    setState(() => load = false);
    return qs.docs;
  }

  listenRequestBudget() {
    FirebaseFirestore.instance
        .collection("RequestBudget")
        .snapshots()
        .listen((_) {
      getRequestBudget().then((data) => setState(() => requestBudget = data));
    });
  }

  @override
  void initState() {
    super.initState();
    listenRequestBudget();
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
          text(
              text: 'الميزانيات المطلوبة',
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
            child: Card(
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: load
                  ? SpinKitThreeBounce(color: primary)
                  : requestBudget.isEmpty
                      ? Center(
                          child: text(
                              text: 'لا يوجد ميزانيات مطلوبة',
                              fontWeight: FontWeight.bold,
                              size: 20.0))
                      : ListView.builder(
                          itemCount: requestBudget.length,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () => details(
                                  requestBudget[index]['id'],
                                  requestBudget[index]['club'],
                                  requestBudget[index]['topic'],
                                  requestBudget[index]['budget'],
                                  requestBudget[index]['agenda']),
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
                                          Image.asset(
                                            'assets/images/add_clubs.png',
                                            width: 45,
                                          ),
                                          Column(
                                            children: [
                                              text(
                                                  text: requestBudget[index]
                                                      ['club'],
                                                  fontWeight: FontWeight.bold),
                                              const SizedBox(height: 10),
                                              text(
                                                  text:
                                                      'المزاينة المطلوبة: ${requestBudget[index]['budget']}'),
                                              const SizedBox(height: 5),
                                              text(
                                                  text:
                                                      'الحالة: ${requestBudget[index]['accept'] == 0 ? "قيد الإنتظار" : requestBudget[index]['accept'] == 1 ? "مقبول" : "مرفوض"}'),
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

  details(id, club, topic, budget, agenda) {
    TextStyle ts = const TextStyle(
        fontFamily: 'almarai', fontWeight: FontWeight.bold, fontSize: 20);
    OutlineInputBorder outline = OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primary, width: 2));

    TextEditingController _club = TextEditingController();
    TextEditingController _topic = TextEditingController();
    TextEditingController _budget = TextEditingController();
    TextEditingController _agenda = TextEditingController();
    _club.text = club;
    _topic.text = topic;
    _budget.text = budget;
    _agenda.text = agenda;
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 80,
                  height: 6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black45),
                ),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    child: text(
                        text: 'اسم النادي',
                        fontWeight: FontWeight.bold,
                        align: TextAlign.start,
                        size: 18.0)),
                const SizedBox(height: 10),
                TextField(
                  style: ts,
                  enabled: false,
                  controller: _club,
                  decoration: InputDecoration(
                      hintText: 'اسم النادي',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.apps_sharp),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      disabledBorder: outline),
                ),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    child: text(
                        text: 'عنوان الفعالية',
                        fontWeight: FontWeight.bold,
                        align: TextAlign.start,
                        size: 18.0)),
                const SizedBox(height: 10),
                TextField(
                  style: ts,
                  enabled: false,
                  controller: _topic,
                  decoration: InputDecoration(
                      hintText: 'عنوان الفعالية',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.apps_sharp),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      disabledBorder: outline),
                ),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    child: text(
                        text: 'الميزانية المطلوبة',
                        fontWeight: FontWeight.bold,
                        align: TextAlign.start,
                        size: 18.0)),
                const SizedBox(height: 10),
                TextField(
                  style: ts,
                  enabled: false,
                  controller: _budget,
                  maxLines: 3,
                  decoration: InputDecoration(
                      hintText: 'الميزانية المطلوبة',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.apps_sharp),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      disabledBorder: outline),
                ),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    child: text(
                        text: 'التفاصيل',
                        fontWeight: FontWeight.bold,
                        align: TextAlign.start,
                        size: 18.0)),
                const SizedBox(height: 10),
                TextField(
                  style: ts,
                  enabled: false,
                  controller: _agenda,
                  maxLines: 5,
                  decoration: InputDecoration(
                      hintText: 'التفاصيل',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.apps_sharp),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      disabledBorder: outline),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Colors.grey)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: text(
                          text: 'رجوع',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          size: 23.0)),
                ),
                const SizedBox(height: 15),
              ],
            ),
          );
        });
  }
}
