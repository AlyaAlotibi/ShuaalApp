import 'package:flutter/material.dart';

class userProfile extends StatelessWidget {
  const userProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController Name = TextEditingController();
    TextEditingController Major = TextEditingController();
    TextEditingController about = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [IconButton(icon: Icon(Icons.edit), onPressed: () {})],
        backgroundColor: Colors.transparent,
      ),
      body: Stack(children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 80.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xC0654D),
                Color(0xDCE3CF),
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
            )),
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
                        color: Colors.grey, shape: BoxShape.circle),
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      size: 30.0,
                    )),
              )
            ],
          ),
        ),
      ]),
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