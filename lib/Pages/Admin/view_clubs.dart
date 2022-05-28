import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuaal/utils/colors.dart';

import '../../utils/alert.dart';
import '../../utils/text.dart';

class ViewClubs extends StatefulWidget {
  const ViewClubs({Key? key}) : super(key: key);

  @override
  State<ViewClubs> createState() => _ViewClubsState();
}

class _ViewClubsState extends State<ViewClubs> {
  List clubs = [];
  bool load = true;
  getClubs() async {
    setState(() => load = true);
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("Clubs").get();
    setState(() => load = false);

    return qs.docs;
  }

  listenClubs() {
    FirebaseFirestore.instance.collection("Clubs").snapshots().listen((_) {
      getClubs().then((data) => setState(() => clubs = data));
    });
  }

  @override
  void initState() {
    super.initState();
    listenClubs();
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
          text(text: 'الأندية', size: 25.0, fontWeight: FontWeight.bold),
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
                    : clubs.isEmpty
                        ? Center(
                            child: text(
                                text: 'لا يوجد أندية',
                                fontWeight: FontWeight.bold,
                                size: 20.0))
                        : GridView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            itemCount: clubs.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 1 / 1.7,
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 0),
                            itemBuilder: (_, index) {
                              return Column(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    margin: const EdgeInsets.all(10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: clubs[index]['logo'] == ''
                                          ? Image.asset(
                                              'assets/images/add_clubs.png',
                                            )
                                          : Image(
                                              image: NetworkImage(
                                                  clubs[index]['logo']),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 40,
                                    child: text(
                                        text: clubs[index]['club'],
                                        size: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: FlatButton(
                                          color: primary,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          onPressed: () => details(
                                              clubs[index]['id'],
                                              clubs[index]['club'],
                                              clubs[index]['logo']),
                                          child: text(
                                              text: 'عرض التفاصيل',
                                              size: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ),
                                  )
                                ],
                              );
                            })),
          ),
        ],
      ),
    );
  }

  details(id, name, logo) {
    TextStyle ts = const TextStyle(
        fontFamily: 'almarai', fontWeight: FontWeight.bold, fontSize: 20);
    OutlineInputBorder outline = OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primary, width: 2));

    TextEditingController _name = TextEditingController();
    _name.text = name;
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
                const SizedBox(height: 30),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: logo == null
                        ? const Icon(Icons.image)
                        : Image(
                            image: NetworkImage(logo),
                            width: 200,
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  style: ts,
                  enabled: false,
                  controller: _name,
                  decoration: InputDecoration(
                      hintText: 'الاسم',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.apps_sharp),
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
                            .collection("Posts")
                            .doc(id)
                            .delete()
                            .then((value) {
                          Navigator.pop(context);
                          Alert().show(context, 'تم إزالة النادي بنجاح');
                        });
                      },
                      child: text(
                          text: 'إزالة النادي',
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
