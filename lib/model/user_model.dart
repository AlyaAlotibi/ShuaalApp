class UserModel {
  String? uid;
  String? name;
  String? email;
  String? password;
  String? phone;
  UserModel({this.uid,this.name,this.email,this.password,this.phone});
  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
    );
  }
  //send data
 Map<String, dynamic> toMap(){
    return {
      'uid':uid,
      'email':email,
      'name':name,
      'phone':phone,
      };
}

}