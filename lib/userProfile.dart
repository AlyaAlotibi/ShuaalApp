import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shuaalapp/model/user_model.dart';


class userProfile  extends StatefulWidget {
  const userProfile({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>_userProfileState( );

  }

class _userProfileState extends State<userProfile>{
  File?image;
  Future pickImage() async{
    final image=await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image==null) return;
    final imageTemporary=File(image.path);
     setState(() =>this.image=imageTemporary);
  }
  User? user =FirebaseAuth.instance.currentUser;
  UserModel loggedInUser =UserModel();
  @override
  void initState(){
  super.initState();
  FirebaseFirestore.instance.collection("users").doc(user!.uid).get()
      .then((value){
        this.loggedInUser=UserModel.fromMap(value.data());
        setState(() {

        });
  });
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController Name=  TextEditingController();
    TextEditingController Major=  TextEditingController();
    TextEditingController about=  TextEditingController();
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {Navigator.pop(context,true);},
        ),
        actions: [IconButton(icon: Icon(Icons.edit), onPressed: () {})],

      ),
      body:
      Stack(children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 80.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.white70,
                    Color(0xFFFF8952),
                  ],
                )),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 80.0,
                ),
                Container(
                  padding: EdgeInsets.only(top: 80.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                          controller: Name,
                          decoration: InputDecoration(
                            labelText: 'first name',
                            prefixIcon: Icon(Icons.person),
                            border: myInputBorder(),
                            enabledBorder: myInputBorder(),
                            focusedBorder: myFoucsBorder(),
                          )),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                          controller: Major,
                          decoration: InputDecoration(
                            labelText: 'Major',
                            prefixIcon: Icon(Icons.school),
                            border: myInputBorder(),
                            enabledBorder: myInputBorder(),
                            focusedBorder: myFoucsBorder(),
                          )),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                          controller: about,
                          decoration: InputDecoration(
                            labelText: 'about',
                            prefixIcon: Icon(Icons.article),
                            border: myInputBorder(),
                            enabledBorder: myInputBorder(),
                            focusedBorder: myFoucsBorder(),
                          )),

                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                )
              ],
            )
        ),

        Align(
          alignment: Alignment.topCenter,
          child: Stack(
            children: <Widget>[
              ClipOval(


                  child: Image.asset(
                    'images/profile.jpg',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  )),
              Positioned(
                bottom: 5,
                right: 15.5,
                child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child:  Container(
                      child: IconButton(
                         icon: Icon(
                        Icons.add_a_photo_outlined,
                        size: 30.0,

                      ), onPressed: () {  },
                      ),
                    ),
              )

              )],
          ),
        ),
      ])
      ,

    );

  }


  OutlineInputBorder myInputBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(color: Color(0x6F6E6A), width: 3));
  }

  OutlineInputBorder myFoucsBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(color: Color(0xFFFFFF), width: 3));
  }
}