import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String commentOwnerID;
  String username;
  String comment;
  final datePublished;
  List likes;
  String profilePhoto;
  String uid;
  String id;

  Comment({
    required this.commentOwnerID,
    required this.username,
    required this.comment,
    required this.datePublished,
    required this.likes,
    required this.profilePhoto,
    required this.uid,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
    "commentOwnerID":commentOwnerID,
    'username': username,
    'comment': comment,
    'datePublished': datePublished,
    'likes': likes,
    'profilePhoto': profilePhoto,
    'uid': uid,
    'id': id,
  };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
    commentOwnerID: snapshot["commentOwnerID"],
      username: snapshot['username'],
      comment: snapshot['comment'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
      profilePhoto: snapshot['profilePhoto'],
      uid: snapshot['uid'],
      id: snapshot['id'],
    );
  }

  @override
  String toString() {
    return 'Comment{\n'
        '  id: $id,\n'
        '  username: $username,\n'
        '  comment: $comment,\n'
        '  datePublished: $datePublished,\n'
        '  likes: $likes,\n'
        '  profilePhoto: $profilePhoto,\n'
        '  uid: $uid\n'
        '}';
  }

}