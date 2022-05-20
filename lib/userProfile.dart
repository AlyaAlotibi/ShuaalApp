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
  late File _pickedImage;



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
          child: Stack(children: [ Container(
            margin: EdgeInsets.symmetric(vertical: 30,horizontal:30 ),
            child: CircleAvatar(radius: 71,backgroundColor: Colors.grey,
            child: CircleAvatar(
              radius: 65,
              backgroundImage:  _pickedImage==null?null:FileImage( _pickedImage) ,
            ),)
            ,
          ),Positioned(
            top: 120,
              left: 110,

              child:RawMaterialButton(
                elevation: 10,
                child: Icon(Icons.add),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),



                onPressed: () {showDialog(context: context, builder:(BuildContext context){
    return AlertDialog(
    title: Text("Choose option",style: TextStyle(fontWeight: FontWeight.w600),
    ),
    content: SingleChildScrollView(
    child: ListBody(children: [
    InkWell(
    onTap:(){} ,
    splashColor: Colors.black,
    child:Row(children: [
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: Icon(Icons.camera_alt_outlined,color: Colors.black,),
    ),Text("Camera",style:TextStyle(fontSize: 18,fontWeight: FontWeight.w500) ,)
    ],
    ) ,
    ),InkWell(
    onTap:(){} ,
    splashColor: Colors.black,
    child:Row(children: [
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: Icon(Icons.image,color: Colors.black,),
    ),Text("Gallery",style:TextStyle(fontSize: 18,fontWeight: FontWeight.w500) ,)
    ],
    ) ,
    ),InkWell(
    onTap:(){} ,
    splashColor: Colors.black,
    child:Row(children: [
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: Icon(Icons.highlight_remove_outlined,color: Colors.black,),
    ),Text("Remove",style:TextStyle(fontSize: 18,fontWeight: FontWeight.w500) ,)
    ],
    ) ,
    )

    ],),
    ),

    );
    });

                }
                )
                  ),
    ]),
    ),
                ])

    );

  }



                     //onPressed: () {  },




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
