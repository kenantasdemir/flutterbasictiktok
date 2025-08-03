import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String? name;
  String profilePhotoUrl;
  String? email;
  String uid;
 // List<String> followers = [];
  //List<String> followings = [];

  MyUser({
    required this.uid,
    required this.name,
    required this.email,

    required this.profilePhotoUrl,
    //required this.followers,
    //required this.followings,
  });

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "email": email,
    "profilePhotoUrl": profilePhotoUrl,
   // "followers": followers,
    //"followings": followings,
  };

  MyUser.fromMap(Map<String, dynamic> map)
    : uid = map['uid'],
      name = map['name'],
      email = map['email'],
      profilePhotoUrl = map['profilePhotoUrl'];
  //followers = map["followers"],
      //followings = map["followings"];

  static MyUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return MyUser(
      uid: snapshot['uid'],
      name: snapshot['name'],
      email: snapshot['email'],
      profilePhotoUrl: snapshot['profilePhotoUrl']
      //followers: List<String>.from(snapshot["followers"] ?? []),
      //followings: List<String>.from(snapshot["followings"] ?? []),
    );
  }

  MyUser.idveResim({required this.uid, required this.profilePhotoUrl});

  MyUser.essential({required this.uid, required this.name,required this.profilePhotoUrl});
}
