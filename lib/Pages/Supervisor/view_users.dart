import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shuaal/utils/colors.dart';
import '../../utils/text.dart';
import 'view_details.dart';

class ViewUsers extends StatefulWidget {
  const ViewUsers({Key? key}) : super(key: key);

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  List users = [];
  bool load = true;
  getUsers() async {
    setState(() => load = true);
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Users")
        .where('isAdmin', isEqualTo: false)
        .where('isSupervisor', isEqualTo: false)
        .get();
    setState(() => load = false);
    return qs.docs;
  }

  listenUsers() {
    FirebaseFirestore.instance.collection("Users").snapshots().listen((_) {
      getUsers().then((data) => setState(() => users = data));
    });
  }

  @override
  void initState() {
    super.initState();
    listenUsers();
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
          text(text: 'المستخدمين', size: 25.0, fontWeight: FontWeight.bold),
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
                  : users.isEmpty
                      ? Center(
                          child: text(
                              text: 'لا يوجد مستخدمين',
                              fontWeight: FontWeight.bold,
                              size: 20.0))
                      : ListView.builder(
                          itemCount: users.length,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ViewDetails(users[index]['id']))),
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
                                          users[index]['avatar'] != ''
                                              ? Image(
                                                  image: NetworkImage(
                                                      users[index]['avatar']))
                                              : Image.asset(
                                                  'assets/images/male_icon.png',
                                                  width: 45,
                                                ),
                                          Column(
                                            children: [
                                              text(
                                                  text: users[index]['name'],
                                                  fontWeight: FontWeight.bold),
                                              text(text: users[index]['email']),
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
}
