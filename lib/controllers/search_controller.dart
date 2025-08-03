import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../colors.dart';
import '../models/MyUser.dart';


class CustomSearchController extends GetxController {
  final Rx<List<MyUser>> _searchedUsers = Rx<List<MyUser>>([]);

  List<MyUser> get searchedUsers => _searchedUsers.value;

 searchUser(String typedUser) async {
    _searchedUsers.bindStream(firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: typedUser)
        .snapshots()
        .map((QuerySnapshot query) {
      List<MyUser> retVal = [];
      for (var elem in query.docs) {
        retVal.add(MyUser.fromSnap(elem));
      }
      return retVal;
    }));
  }
}