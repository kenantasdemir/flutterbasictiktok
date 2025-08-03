import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../colors.dart';
import '../models/MyUser.dart';

class FollowingController extends GetxController {
  var followings = <MyUser>[].obs;
  var filteredFollowings = <MyUser>[].obs;
  var isLoading = false.obs;


  Future<void> getFollowings(String userID) async {
    try {
      isLoading.value = true;

      // followings koleksiyonundaki belge ID'lerini çek
      final snapshot = await firestore
          .collection("users")
          .doc(userID)
          .collection("followings")
          .get(const GetOptions(source: Source.server));

      final followingIDs = snapshot.docs.map((doc) => doc.id).toList();

      // her bir following ID için ana 'users' koleksiyonundan user verisini al
      List<MyUser> followingList = [];

      for (String id in followingIDs) {
        final userDoc = await firestore.collection("users").doc(id).get();
        if (userDoc.exists) {
          followingList.add(MyUser.fromMap(userDoc.data()!));
        }
      }

      followings.assignAll(followingList);
      filteredFollowings.assignAll(followingList);
    } catch (e) {
      print("Takip edilenler alınırken hata: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterFollowings(String query) {
    if (query.isEmpty) {
      filteredFollowings.value = followings;
    } else {
      final filtered = followings.where((user) {
        final nameLower = user.name?.toLowerCase() ?? '';
        final emailLower = user.email?.toLowerCase() ?? '';
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower) || emailLower.contains(queryLower);
      }).toList();

      filteredFollowings.value = filtered;
    }
  }
}
