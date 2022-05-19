

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsAndConditions  extends StatefulWidget {
  const TermsAndConditions ({Key? key}) : super(key: key);

  @override
  _TermsAndConditionsState createState() =>_TermsAndConditionsState( );

}

class _TermsAndConditionsState extends State<TermsAndConditions>{
  @override
  void _doSomething(
      ) {
    // Do something
  }
  Widget build(BuildContext context)
 {  Size size= MediaQuery.of(context).size;
 bool agree = false;
  return Scaffold(
     appBar: AppBar(
     backgroundColor: Colors.transparent,
   leading: IconButton(
   icon: Icon(Icons.arrow_back),
   onPressed: () {Navigator.pop(context,true);},
   )),
    body: SingleChildScrollView(
      child: Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/BackG TC.jpg"),
          fit: BoxFit.cover)),
        child: SafeArea( child: Container(
          margin: EdgeInsets.only(right: 70, top: 290,left:70,),
          child: Column(children: <Widget> [
                    Column(children: [Text("1.The student should be enrolled full time at a college in the University.\n"
                        "2.The student should be enrolled in the University for two semesters\n"
                        "3. The student must participate in club activities\n"
                        "I confirm that I have read and agree to the terms and conditions as stated above."
            ,textAlign: TextAlign.justify,style: TextStyle(
                      height:1.5)
                    ),
                      Container(
                        padding: EdgeInsets.only(top: 25,right: 230),
                        child: Material(

                          child: Checkbox(
                            shape: CircleBorder(),

                            value: agree,
                            checkColor: Colors.deepOrangeAccent,
                            onChanged: (value) {
                              setState(() {
                                agree = value ?? false;

                              });
                            },
                          ),
                        ),
                      ),
                      Container(padding: EdgeInsets.only(right: 230),
                        child: const Text(
                          'Agree',
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                    ),
            Container( padding: EdgeInsets.only(top: 25 ),
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
                  onPressed: agree ? _doSomething : null,
                  child: const Text('Join')),
            )
          ]
          ),
  ),
        )),
    ));
 }
}