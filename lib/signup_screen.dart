import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shuaalapp/login_screen.dart';
import 'package:shuaalapp/model/user_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) => initWidget();
  final _auth =FirebaseAuth.instance;
  final _formKey=GlobalKey<FormState>();
  final TextEditingController nameController=new TextEditingController();
  final TextEditingController emailController=new TextEditingController();
  final TextEditingController phoneController=new TextEditingController();
  final TextEditingController passwordController=new TextEditingController();
  final TextEditingController confirmPasswordController=new TextEditingController();
  String name='';
  String email='';
  String password='';
  String Conpassword='';
  String phone='';

  Widget initWidget() {
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
                      child: Image.asset(
                        "images/topimg.png",
                        height: 300,
                        width: 420,
                      ),
                    ),
                    Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(

                                margin: EdgeInsets.only(right: 20, top: 20),
                                alignment: Alignment.bottomRight,
                                child: Center(
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Or sign in to your account  "),
                                    GestureDetector(
                                      child: Text(
                                        "Login Now",
                                        style: TextStyle(
                                            color: Color(0xffF5591F)
                                        ),
                                      ),
                                      onTap: () {
                                        // Write Tap Code Here.

                                        Navigator.pushReplacement(context, MaterialPageRoute(
                                            builder: (context) => LoginScreen()
                                        ));

                                      },
                                    )
                                  ],
                                ),
                              )

                            ],
                          )
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
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            onChanged: (val){
                              setState(() {
                                name=val;
                              });
                            },
                            validator:(value){
                              RegExp regex=new RegExp(r'^.{3,}$');
                              if(value!.isEmpty)
                              {
                                return ("Please inter your name");
                              }
                              if((regex.hasMatch(value))==false){
                                return ("Please inter name more than 3 character");
                              }
                              return null;
                            },
                            //onSaved: (value){
                            // nameController.text=value!;
                            //  },
                            cursorColor: Color(0xffF5591F),
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: Color(0xffF5591F),
                              ),
                              hintText: "Full Name",
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
                            onChanged: (val){
                              setState(() {
                                email=val;
                              });
                            },
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
                            //onSaved: (value){
                            //  emailController.text=value!;
                            //},
                            cursorColor: Color(0xffF5591F),
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.email,
                                color: Color(0xffF5591F),
                              ),
                              hintText: "Email",
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
                            onChanged: (val){
                              setState(() {
                                phone=val;
                              });
                            },
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value){
                              if(value!.isEmpty)
                              {
                                return ("Please inter your phone");
                              }

                            },
                            cursorColor: Color(0xffF5591F),
                            decoration: InputDecoration(
                              focusColor: Color(0xffF5591F),
                              icon: Icon(
                                Icons.phone,
                                color: Color(0xffF5591F),
                              ),
                              hintText: "Phone Number",
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
                            onChanged: (val){
                              setState(() {
                                password=val;
                              });
                            },
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
                            //onSaved: (value){
                            //  passwordController.text=value!;
                            // },
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
                        ),Container(
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
                            onChanged: (val){
                              setState(() {
                                Conpassword=val;
                              });
                            },
                            controller: confirmPasswordController,
                            obscureText: true,
                            validator: (value){
                              if(value!.isEmpty)
                              {
                                return ("Please inter your password");
                              }
                              if(Conpassword != password ){
                                return "password do not match";
                              }
                              return null;
                            },
                            //onSaved: (value){
                            // Conpassword=value!;
                            // },
                            cursorColor: Color(0xffF5591F),
                            decoration: InputDecoration(
                              focusColor: Color(0xffF5591F),
                              icon: Icon(
                                Icons.vpn_key,
                                color: Color(0xffF5591F),
                              ),
                              hintText: "confirm Password",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
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
                                  "REGISTER",
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              ),
                              onPressed: () async{

                                // try{
                                //  final user=await _auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                                //  }catch(e){
                                //  print(e);
                                //  }
                                if (_formKey.currentState!.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  //print(passwordController.text);

                                  signUp(email, password);
                                }}

                          ),
                        ),
                      ],)
                ),
              ]),),),


    );
  }
  postDetailsToFirestore() async{
    FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
    User? user=_auth.currentUser;
    UserModel userModel=UserModel();
    userModel.email=user!.email;
    userModel.uid=user.uid;
    userModel.name=name;
    userModel.phone=phone;
    await firebaseFirestore.collection("users").doc(user.uid).set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);


  }
  //User _userFromFirebaseUser (User user){
  //  return user != null ? User(uid: user.uid) : null;
 // }
  Future signUp(String email,String password) async {
    if(_formKey.currentState!.validate()){
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) => {
        postDetailsToFirestore()
      }).catchError((e){
        Fluttertoast.showToast(msg: e!.message);
      });
      //UserCredential result= await _auth.createUserWithEmailAndPassword(email: email, password: password);
      //User? user  =result.user;
      //return _userFromFirebaseUser(user);

    }

  }
}