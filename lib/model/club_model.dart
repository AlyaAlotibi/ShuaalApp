class ClubModel {
  String? cid;
  String? name;
  String? desc;

  ClubModel({this.cid,this.name,this.desc});
  factory ClubModel.fromMap(map){
    return ClubModel(
      cid: map['cid'],
      name: map['name'],
      desc: map['desc'],
    );
  }
  //send data
  Map<String, dynamic> toMap(){
    return {
      'cid':cid,
      'name':name,
      'desc':desc,
    };
  }

}