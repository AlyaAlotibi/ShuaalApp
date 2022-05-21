import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_button/animated_button.dart';
import 'package:flutter/widgets.dart';
class SuggestClub extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InitState();

}

class InitState extends State<SuggestClub> {
  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    TextEditingController Name = TextEditingController();
    TextEditingController Major = TextEditingController();
    TextEditingController Club = TextEditingController();
    TextEditingController Des = TextEditingController();

    return Scaffold(
      body:
      SingleChildScrollView(
        child: Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/backGround.jpg"),fit: BoxFit.cover)),
        child: Stack(children: <Widget>[
              SizedBox(
                height: 20.0, child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(

                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10,0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              //color: Color(0xFFEEEEEE),
                            ),


                          ),
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional(1, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 40),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                              child: Text(
                                'ٍSuggest a club',
                                textAlign: TextAlign.center,
                                //style: FlutterFlowTheme.of(context).bodyText1,
                              ),),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),

              ),
              Container(
                margin: EdgeInsets.only(top: 80.0, left: 20.0, right: 20.0),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                decoration: BoxDecoration(
                 //   color: const Color(0xff7c94b6),
             ),

                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 80.0,
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            top: 0.0, left: 20.0, right: 20.0),
                        child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 0.0,
                              ),Container(
                                  padding: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                                  child: Column(

                                   children: <Widget>[SizedBox(
                                     height: 0.0,
                                   ),
                              TextField(
                                  controller: Name,
                                  decoration: InputDecoration(
                                    labelText: 'Student  name',
                                    prefixIcon: Icon(Icons.assignment_ind_outlined),
                                    border: myInputBorder(),
                                    enabledBorder: myInputBorder(),
                                    focusedBorder: myFoucsBorder(),
                                  )),
                              SizedBox(
                                height: 60.0,
                              ),
                              TextField(
                                  controller: Major,
                                  decoration: InputDecoration(
                                    labelText: 'Major',
                                    prefixIcon: Icon(Icons.auto_stories_outlined),
                                    border: myInputBorder(),
                                    enabledBorder: myInputBorder(),
                                    focusedBorder: myFoucsBorder(),
                                  )),
                              SizedBox(
                                height: 35.0,
                              ),
                              TextField(
                                  controller: Club,
                                  decoration: InputDecoration(
                                    labelText: 'seggested club name ',
                                    prefixIcon: Icon(
                                        Icons.assured_workload_outlined),
                                    border: myInputBorder(),
                                    enabledBorder: myInputBorder(),
                                    focusedBorder: myFoucsBorder(),
                                  )
                              ), SizedBox(
                                       height: 80.0,
                                     ),
                              TextField(
                                  controller: Des,
                                  decoration: InputDecoration(
                                    labelText: 'A brief descripition of the club',
                                    prefixIcon: Icon(Icons.article_outlined),
                                    border: myInputBorder(),
                                    enabledBorder: myInputBorder(),
                                    focusedBorder: myFoucsBorder(),
                                  ))
                              ,   Container(
                                       padding: EdgeInsets.only(top: 80),
                                child: ElevatedButton(

                                         style: ElevatedButton.styleFrom(
                                           primary: Colors.deepOrangeAccent,
                                           onPrimary: Colors.white,
                                           shadowColor: Colors.grey,
                                           elevation: 20,
                                           shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(32.0)),
                                           minimumSize: Size(70, 40), //////// HERE
                                         ),
                                         onPressed: () {},
                                         child: Text('Submet'),
                                       ),
                              )

                                    ],
                                  )
                              )
                            ]
                        )

                    )
                  ],),)
            ]
        ),
          ),
      ),

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


 // return Scaffold(body:  Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/backGround.jpg"),fit: BoxFit.cover) )));}}}
