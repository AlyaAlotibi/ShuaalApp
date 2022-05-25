import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuaal/Pages/Admin/admin_profile.dart';
import 'package:shuaal/Pages/Home/clubs.dart';
import 'package:shuaal/Pages/Home/events.dart';
import 'package:shuaal/Pages/Home/scoreboard.dart';
import 'package:shuaal/utils/colors.dart';

import 'home.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int index = 0;
  bool isAdmin = false;

  getUserData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(sp.getString('uid'))
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        isAdmin = ds['isAdmin'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
        backgroundColor: bg,
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          height: 60,
          decoration: BoxDecoration(
            color: bottom_bar,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() => index = 0);
                    _pageController.jumpToPage(index);
                  },
                  icon: SvgPicture.asset(
                    'assets/images/home_icon.svg',
                    color: index == 0 ? primary : bottom_bar_icon,
                  )),
              IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() => index = 1);
                    _pageController.jumpToPage(index);
                  },
                  icon: SvgPicture.asset(
                    'assets/images/events_icon.svg',
                    color: index == 1 ? primary : bottom_bar_icon,
                  )),
              IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() => index = 2);
                    _pageController.jumpToPage(index);
                  },
                  icon: Image.asset('assets/images/clubs_icon.png')),
              IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() => index = 3);
                    _pageController.jumpToPage(index);
                  },
                  icon: SvgPicture.asset(
                    'assets/images/scoreboard_icon.svg',
                    color: index == 3 ? primary : bottom_bar_icon,
                  )),
              IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() => index = 4);
                    _pageController.jumpToPage(index);
                  },
                  icon: SvgPicture.asset(
                    'assets/images/profile_icon.svg',
                    color: index == 4 ? primary : bottom_bar_icon,
                  )),
            ],
          ),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (_index) {
            setState(() => index = _index);
            _pageController.jumpToPage(_index);
          },
          children: [
            const Home(),
            const Events(),
            const Clubs(),
            const Scoreboard(),
            !isAdmin ? const Profile() : const AdminProfle(),
          ],
        ));
  }
}
