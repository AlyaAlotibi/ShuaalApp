import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:shuaalapp/model/club_model.dart';

import 'DatabaseManager/databaseManager.dart';

class ClubScreen extends StatefulWidget {
  @override
  State<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {

  ClubModel clubdata =ClubModel();
  List userList=[];
  @override
  void initState(){
    super.initState();
    fetchDataList();
    FirebaseFirestore.instance.collection("users").doc().get()
        .then((value){
      this.clubdata=ClubModel.fromMap(value.data());
      setState(() {

      });
    });
  }
  fetchDataList() async{
    dynamic result=await databaseManager().getClubsList();
    if(result==null){
      print(result);
    }
    else{
      setState(() {
        userList=result;
        print(result);
      });

    }
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: new Container(
        color: new Color(0xEEEEEEEE),
        child: new Column(
          children: <Widget>[
            Image.asset(
              "images/appClub.png",
              height: 300,
              width: 420,),
            Text('${clubdata.name}')

          ],
        ),

      ),

    );

  }
}
