import 'package:cloud_firestore/cloud_firestore.dart';
class databaseManager{
  final CollectionReference userlist=FirebaseFirestore.instance.collection("users");

  Future<void> createUserData(

  String name, String email,String password,int phone, String uid) async{
    return await userlist.doc(uid).set({
      'uid':uid,
      'email':email,
      'name':name,
      'phone':phone,

    });
  }
Future getUserList() async{
    List itemList=[];
    try{
      await userlist.get().then((QuerySnapshot){
        QuerySnapshot.docs.forEach((element) {
          itemList.add(element.data);
          //itemList.add("AA");
        });
      });
    } catch(e){
      print(e.toString());
    }
    return null;
}
}