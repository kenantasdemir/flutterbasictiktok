import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mytiktokcloneapp/models/MyUser.dart';
import 'package:mytiktokcloneapp/models/Video.dart';

import '../colors.dart';

class ProfileController extends GetxController {


  static ProfileController instance = Get.find();

  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});

  Map<String, dynamic> get user => _user.value;

  final RxList<Video> likedVideos = <Video>[].obs;

  final RxMap<String, bool> isFollowingMap = <String, bool>{}.obs;



  Rx<String> _uid = "".obs;

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    List<String> thumbnails = [];


    var myVideos =
        await firestore
            .collection('videos')
            .where('uid', isEqualTo: _uid.value)
            .get();

    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }


    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(_uid.value).get();

    final userData = userDoc.data() as Map<String, dynamic>? ?? {};

    String name = userData['name'] ?? '';

    String email = userData["email"] ?? '';
    String uid = userData["uid"];

    String profilePhoto = userData['profilePhotoUrl'] ?? '';


    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    for (var item in myVideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }

    // Takipçi sayısını alırken profili görüntülenen kullanıcının takipçi koleksiyonunu kullan

    var followerDoc =
        await firestore
            .collection('users')
            .doc(_uid.value)
            .collection('followers')
            .get();

    // Takip edilen sayısını alırken profili görüntülenen kullanıcının takip edilen koleksiyonunu kullan

    var followingDoc =
        await firestore
            .collection('users')
            .doc(_uid.value)
            .collection('followings')
            .get();

    followers = followerDoc.docs.length;

    following = followingDoc.docs.length;


    final followDoc =
        await firestore
            .collection('users')
            .doc(_uid.value)
            .collection('followers')
            .doc(authController.user.uid)
            .get();

    isFollowing = followDoc.exists;

    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profilePhotoUrl': profilePhoto,
      'name': name,
      "email": email,
      'thumbnails': thumbnails,
      "uid": uid,
    };

    update();
  }

  Future<void> followUser(String currentUserId, String targetUserId) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection("users").doc(currentUserId).collection("followings").doc(targetUserId).set({});

    await firestore.collection("users").doc(targetUserId).collection("followers").doc(currentUserId).set({});
    isFollowingMap[targetUserId] = true;
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    final firestore = FirebaseFirestore.instance;

    // currentUser'ın followings'inden targetUser'ı sil
    await firestore
        .collection("users")
        .doc(currentUserId)
        .collection("followings")
        .doc(targetUserId)
        .delete();

    // targetUser'ın followers'ından currentUser'ı sil
    await firestore
        .collection("users")
        .doc(targetUserId)
        .collection("followers")
        .doc(currentUserId)
        .delete();
    isFollowingMap[targetUserId] = false;
  }


  Future<void> checkIsFollowing(String currentUserId, String targetUserId) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('followings')
        .doc(targetUserId)
        .get();

    // Eğer doküman varsa, takip ediyordur
    isFollowingMap[targetUserId] = doc.exists;
  }



  Future<void> fetchLikedVideos(String uid) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('videos')
          .where('likes', arrayContains: uid)
          .get();

      likedVideos.value =
          querySnapshot.docs.map((doc) => Video.fromSnap(doc)).toList();
    } catch (e) {
      print("Beğenilen videolar alınamadı: $e");
    }
  }

  MyUser toMyUser(Map<String, dynamic> map) {
    return MyUser(
      uid: map['uid'] ?? '',
      name: map['name'],
      email: map['email'],
      profilePhotoUrl: map['profilePhotoUrl'] ?? '',
     // followers: List<String>.from(map['followers'] ?? []),
      //followings: List<String>.from(map['followings'] ?? []),
    );
  }

  Future<MyUser?> getUserById(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists) {
      return toMyUser(doc.data()!); // daha önce yazdığımız toMyUser fonksiyonu
    } else {
      return null;
    }
  }




  Future<bool> blockUser(String currentUserID, sohbetEdilenUserID) async {
    try {
      firestore.collection("users").doc(currentUserID).update({
        "blockedUsers": FieldValue.arrayUnion([sohbetEdilenUserID]),
      });
      return true;
    } catch (err) {
      print("KULLANICI ENGELLENIRKEN HATA OLUSTU.");
    }
    return false;
  }

  Future<bool> isUserBlocked(String currentUserID, sohbetEdilenUserID) async {
    try {
      final docSnapshot =
          await firestore.collection("users").doc(currentUserID).get();

      if (!docSnapshot.exists) return false;

      final blockedUsers = List<String>.from(
        docSnapshot.data()?["blockedUsers"] ?? [],
      );
      return blockedUsers.contains(sohbetEdilenUserID);
    } catch (e) {}
    return false;
  }

  Future<bool> unblockUser(String currentUserID, sohbetEdilenUserID) async {
    try {
      firestore.collection("users").doc(currentUserID).update({
        "blockedUsers": FieldValue.arrayRemove([sohbetEdilenUserID]),
      });
      return true;
    } catch (err) {
      debugPrint("KULLANICI ENGELI KALDILIRKEN HATA OLUSTU");
      return false;
    }
  }






}
