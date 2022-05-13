import 'package:flutter/material.dart';
import 'package:shuaalapp/profile/user_profile.dart';
import 'package:shuaalapp/profile/appbar_widget.dart';
import 'package:shuaalapp/profile/user_file.dart';
import 'package:shuaalapp/profile/user_pref.dart';




import 'ProfileWidget.dart';class UserProfileWidget extends StatefulWidget {
  @override
  _UserProfileState creatState () => _UserProfileState();
  @override
  State<StatefulWidget> createState() {

  }
}
class _UserProfileState extends State<UserProfileWidget> {
  @override
  Widget build(BuildContext context) {
    final user = UserPre.myUser;
    return Scaffold(
        appBar: buildAppBar(context),
        body: ListView(
            physics: BouncingScrollPhysics(),
            children: [ProfileWidget(
              imagePath: user.imagePath,
              onClicked: () async {},
            )
            ]
        )
    );
  }}