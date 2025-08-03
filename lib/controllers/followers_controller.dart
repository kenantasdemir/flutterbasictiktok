import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../colors.dart';
import '../models/MyUser.dart';

class FollowersController extends GetxController {
  var followers = <MyUser>[].obs;
  var filteredFollowers = <MyUser>[].obs;
  var isLoading = false.obs;


  Future<void> getFollowers(String userID) async {
    try {
      isLoading.value = true;

      // followers koleksiyonundaki belge ID'lerini çek
      final snapshot = await firestore
          .collection("users")
          .doc(userID)
          .collection("followers")
          .get(const GetOptions(source: Source.server));


      final followerIDs = snapshot.docs.map((doc) => doc.id).toList();

      // her bir follower ID için ana 'users' koleksiyonundan user verisini al
      List<MyUser> followerList = [];

      for (String id in followerIDs) {
        final userDoc = await firestore.collection("users").doc(id).get();
        if (userDoc.exists) {
          followerList.add(MyUser.fromMap(userDoc.data()!));
        }
      }

      followers.assignAll(followerList);
      filteredFollowers.assignAll(followerList);
    } catch (e) {
      print("Takipçiler alınırken hata: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterFollowers(String query) {
    if (query.isEmpty) {
      filteredFollowers.value = followers;
    } else {
      final filtered = followers.where((user) {
        final nameLower = user.name?.toLowerCase() ?? '';
        final emailLower = user.email?.toLowerCase() ?? '';
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower) || emailLower.contains(queryLower);
      }).toList();

      filteredFollowers.value = filtered;
    }
  }
}
