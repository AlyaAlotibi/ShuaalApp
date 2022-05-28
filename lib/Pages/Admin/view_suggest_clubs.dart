import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shuaal/utils/colors.dart';
import '../../utils/alert.dart';
import '../../utils/text.dart';
import '../Supervisor/view_details.dart';

class ViewSuggestClubs extends StatefulWidget {
  const ViewSuggestClubs({Key? key}) : super(key: key);

  @override
  State<ViewSuggestClubs> createState() => _ViewSuggestClubsState();
}

class _ViewSuggestClubsState extends State<ViewSuggestClubs> {
  List suggestClubs = [];
  bool load = true;
  getSuggestClubs() async {
    setState(() => load = true);
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("SuggestClub").get();
    setState(() => load = false);
    return qs.docs;
  }

  listenSuggestClubs() {
    FirebaseFirestore.instance
        .collection("SuggestClub")
        .snapshots()
        .listen((_) {
      getSuggestClubs().then((data) => setState(() => suggestClubs = data));
    });
  }

  @override
  void initState() {
    super.initState();
    listenSuggestClubs();
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
              text: 'الأندية المقترحة',
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
                  : suggestClubs.isEmpty
                      ? Center(
                          child: text(
                              text: 'لا يوجد أندية مقترحة',
                              fontWeight: FontWeight.bold,
                              size: 20.0))
                      : ListView.builder(
                          itemCount: suggestClubs.length,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () => details(
                                  suggestClubs[index]['id'],
                                  suggestClubs[index]['clubName'],
                                  suggestClubs[index]['major'],
                                  suggestClubs[index]['desc'],
                                  suggestClubs[index]['name'],
                                  suggestClubs[index]['logo']),
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
                                          suggestClubs[index]['logo'] != ''
                                              ? Image(
                                                  image: NetworkImage(
                                                      suggestClubs[index]
                                                          ['logo']))
                                              : Image.asset(
                                                  'assets/images/add_clubs.png',
                                                  width: 45,
                                                ),
                                          Column(
                                            children: [
                                              text(
                                                  text: suggestClubs[index]
                                                      ['clubName'],
                                                  fontWeight: FontWeight.bold),
                                              text(
                                                  text: suggestClubs[index]
                                                      ['major']),
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

  details(id, clubName, major, desc, name, logo) {
    TextStyle ts = const TextStyle(
        fontFamily: 'almarai', fontWeight: FontWeight.bold, fontSize: 20);
    OutlineInputBorder outline = OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primary, width: 2));

    TextEditingController _clubName = TextEditingController();
    TextEditingController _major = TextEditingController();
    TextEditingController _desc = TextEditingController();
    TextEditingController _name = TextEditingController();
    _clubName.text = clubName;
    _major.text = major;
    _desc.text = desc;
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: logo == ''
                        ? Image.asset(
                            'assets/images/add_clubs.png',
                            width: 100,
                          )
                        : Image(
                            image: NetworkImage(logo),
                            width: 200,
                          ),
                  ),
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
                  controller: _clubName,
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
                        text: 'التخصص',
                        fontWeight: FontWeight.bold,
                        align: TextAlign.start,
                        size: 18.0)),
                const SizedBox(height: 10),
                TextField(
                  style: ts,
                  enabled: false,
                  controller: _major,
                  decoration: InputDecoration(
                      hintText: 'التخصص',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.apps_sharp),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      disabledBorder: outline),
                ),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    child: text(
                        text: 'وصف النادي',
                        fontWeight: FontWeight.bold,
                        align: TextAlign.start,
                        size: 18.0)),
                const SizedBox(height: 10),
                TextField(
                  style: ts,
                  enabled: false,
                  controller: _desc,
                  maxLines: 3,
                  decoration: InputDecoration(
                      hintText: 'وصف النادي',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.apps_sharp),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      disabledBorder: outline),
                ),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    child: text(
                        text: 'اسم المقترِح',
                        fontWeight: FontWeight.bold,
                        align: TextAlign.start,
                        size: 18.0)),
                const SizedBox(height: 10),
                TextField(
                  style: ts,
                  enabled: false,
                  controller: _name,
                  decoration: InputDecoration(
                      hintText: 'اسم المقترِح',
                      hintStyle: ts,
                      prefixIcon: const Icon(Icons.apps_sharp),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      disabledBorder: outline),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: FlatButton(
                            color: primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("SuggestClub")
                                  .doc(id)
                                  .delete()
                                  .then((value) {
                                FirebaseFirestore.instance
                                    .collection("Clubs")
                                    .doc(id)
                                    .set({
                                  "club": clubName,
                                  "id": id,
                                  "logo": logo,
                                  "desc": desc,
                                  "major": major
                                }).then((value) {
                                  Navigator.pop(context);
                                  Alert().show(context, 'تم قبول النادي بنجاح');
                                });
                              });
                            },
                            child: text(
                                text: 'قبول النادي',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                size: 23.0)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: SizedBox(
                      height: 50,
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
                    ))
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          );
        });
  }
}
