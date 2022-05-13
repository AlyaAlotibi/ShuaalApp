import 'package:flutter/material.dart';


class userProfile  extends StatelessWidget {
  const userProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController Name=  TextEditingController();
    TextEditingController Major=  TextEditingController();
    TextEditingController about=  TextEditingController();
    return Scaffold(
    body: Stack(
      children: <Widget> [

        Container( margin:EdgeInsets.only(top:80.0),
  width: MediaQuery.of(context).size.width,
  height: MediaQuery.of(context).size.height ,
  decoration: BoxDecoration(gradient: LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [ Colors.white70,
  Colors.redAccent,


  ],
  )
  ),
  child: Column(children:<Widget>[
    SizedBox(height:50.0,),
    Column(children:<Widget> [TextField(
      controller: Name,
      decoration: InputDecoration(labelText:'name',
      prefixIcon:Icon(Icons.person),
      border: myInputBorder(),
      enabledBorder:  myInputBorder(),
      focusedBorder: myFoucsBorder(),)

    )],)],))
        ,Align(
      alignment: Alignment.topCenter,
        child: Stack(
        children: <Widget>[
          ClipOval(
  child: Image.asset('images/profile.jpg',width:150,height: 150,
  fit: BoxFit.cover,)
  ),
          Positioned(
             bottom: 5,
            right: 15.5,
            child: Container(
  padding: EdgeInsets.all(5.0),
  decoration: BoxDecoration(color:Colors.grey,
  shape: BoxShape.circle),
  child: Icon(Icons.add_a_photo_outlined  ,size:30.0,)),
          )
  ],
        ),
      ),
       ]),

    );
  }
  OutlineInputBorder myInputBorder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
     color:Color(0x6F6E6A),
      width: 3)

    );
  }
  OutlineInputBorder myFoucsBorder(){
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
            color:Color(0xFFFFFF),
            width: 3)

    );
}}