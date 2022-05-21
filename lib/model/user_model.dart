class UserModel {
  String? uid;
  String? name;
  String? email;
  String? password;
  String? phone;
  List<String>? club;
  UserModel({this.uid,this.name,this.email,this.club,this.phone});
  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
      club: List.from(map['club']),
    );
  }
  //send data
 Map<String, dynamic> toMap(){
    return {
      'uid':uid,
      'email':email,
      'name':name,
      'phone':phone,
      'club':club
      };
}

}