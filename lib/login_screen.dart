import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:shuaalapp/profile/user_profile.dart';
import 'package:shuaalapp/signup_screen.dart';
//import 'package:login_ui_design/signup_screen.dart';
import 'package:shuaalapp/home_screen.dart';
import 'package:shuaalapp/userProfile.dart';
class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();

}

class StartState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return initWidget();
  }
final _formKey=GlobalKey<FormState>();
  final TextEditingController emailController=new TextEditingController();
  final TextEditingController passwordController=new TextEditingController();
  //Firebase
  final _auth =FirebaseAuth.instance;
  initWidget() {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  color: new Color(0xEEEEEEEE),
                  gradient: LinearGradient(colors: [(new  Color(0xEEEEEEEE)), new Color(0xEEEEEEEE)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  )
              ),

              child: Column(
                children: [
                  Container(

                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Image.asset(
                                "images/topimg.png",
                                height: 300,
                                width: 420,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 20, top: 20),
                              alignment: Alignment.bottomRight,
                              child: Center(
                                child: Text(
                                  "Welcome back",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                  ),
                  Form(
                      key: _formKey,
                      child: Column(children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 20, right: 20, top: 70),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[200],
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 10),
                                  blurRadius: 50,
                                  color: Color(0xffEEEEEE)
                              ),
                            ],
                          ),

                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator:(value){
                              if(value!.isEmpty)
                              {
                                return ("Please inter your Email");
                              }
                              if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                                return ("Please inter valid Email");
                              }
                              return null;
                            },
                            onSaved: (value){
                              emailController.text=value!;
                            },
                            cursorColor: Color(0xffF5591F),
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.email,
                                color: Color(0xffF5591F),
                              ),
                              hintText: "Enter Email",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),


                        ),

                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xffEEEEEE),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 20),
                                  blurRadius: 100,
                                  color: Color(0xffEEEEEE)
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            validator:(value){
                              RegExp regex=new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                              if(value!.isEmpty)
                              {
                                return ("Please inter your Password");
                              }
                              if(!regex.hasMatch(value)){
                                return ("Please inter valid Password at least one \n (upper case,lower case,digit,Special character)\n and at least 8 characters in length");
                              }
                              return null;
                            },

                            onSaved: (value){
                              passwordController.text=value!;
                            },
                            cursorColor: Color(0xffF5591F),
                            decoration: InputDecoration(
                              focusColor: Color(0xffF5591F),
                              icon: Icon(
                                Icons.vpn_key,
                                color: Color(0xffF5591F),
                              ),
                              hintText: "Enter Password",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ],)),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Write Click Listener Code Here
                      },
                      child: Text("Forget Password?"),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      // Write Click Listener Code Here.
                    },
                    child: MaterialButton(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 20, right: 20, top: 70),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [(new  Color(0xffF5591F)), new Color(0xffF2861E)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight
                          ),

                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 10),
                                blurRadius: 50,
                                color: Color(0xffEEEEEE)
                            ),
                          ],
                        ),
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                      onPressed: (){
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          print(passwordController.text);
                          signIn(emailController.text, passwordController.text);
                        }

                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't Have Any Account?  "),
                        GestureDetector(
                          child: Text(
                            "Register Now",
                            style: TextStyle(
                                color: Color(0xffF5591F)
                            ),
                          ),
                          onTap: () {
                            // Write Tap Code Here.
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                )
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
        )
    );
  }
  void signIn(String email, String password) async{
    if(_formKey.currentState!.validate()){
      await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) => {
        Fluttertoast.showToast(msg: "Login Successful"),
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>userProfile()))
      }).catchError((e){
        Fluttertoast.showToast(msg: e!.message);
      });
      
    }
  }
}