import 'package:cloud_firestore/cloud_firestore.dart';
class databaseManager{
  final CollectionReference userlist=FirebaseFirestore.instance.collection("users");
  final CollectionReference clublist=FirebaseFirestore.instance.collection("Clubs");

  Future<void> createUserData(

  String name, String email,String password,int phone, String uid) async{
    return await userlist.doc(uid).set({
      'uid':uid,
      'email':email,
      'name':name,
      'phone':phone,

    });
  }
  Future<void> createClubData(

      String name, String desc, String cid) async{
    return await clublist.doc(cid).set({
      'cid':cid,
      'desc':desc,
      'name':name,

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
  Future getClubsList() async{
    List itemList=[];
    try{
      await clublist.get().then((QuerySnapshot){
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