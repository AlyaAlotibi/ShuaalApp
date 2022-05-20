import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shuaalapp/signup_screen.dart';
import 'package:shuaalapp/userProfile.dart';

void main() {
  runApp(SplashScreen());
}
class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => StartState();

}

class StartState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = Duration(seconds: 4);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => userProfile()
    ));
  }

  @override
  Widget build(BuildContext context) {
    return initWidget(context);
  }

  Widget initWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: new Color(0xEEEEEEEE),
                gradient: LinearGradient(colors: [(new  Color(0xEEEEEEEE)), new Color(0xEEEEEEEE)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                )
            ),
          ),
          Center(
            child: Container(
              child: Image.asset("images/logoboth.png"),
              height: 250,
              width: 250,
            ),
          )
          ,
          Container(
                child: Image.asset("images/conner.png"),
            height: 250,
            width: 220,
            ),
          ],
      ),
    );
  }
}