import "package:cloud_firestore/cloud_firestore.dart";

class Guncelleme{

  late final String name;
  late final Timestamp uploaded_time;
  late final String url;
  late final bool is_onseen;

  Guncelleme({ required this.name, required this.uploaded_time,required this.url,required this.is_onseen});


  Map<String,dynamic> toMap(){
    return {
      "name":this.name,
      "uploaded_time":this.uploaded_time,
      "url":this.url,
      "is_onseen":this.is_onseen
    };
  }

  Guncelleme.fromMap(Map<String,dynamic> map)
      : name = map["name"],
        uploaded_time = map["uploaded_time"],
        url = map["url"],
        is_onseen = map["is_onseen"];



  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }

}