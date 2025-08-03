import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytiktokcloneapp/colors.dart';
import 'package:mytiktokcloneapp/screens/my_profile_screen.dart';
import 'package:mytiktokcloneapp/screens/preview_profile_screen.dart';
import '../controllers/following_controller.dart';

class FollowingScreen extends StatelessWidget {
  final String userID;

  FollowingScreen({super.key, required this.userID});

  final FollowingController followingController = Get.put(
    FollowingController(),
  );

  final RxBool isSearchButtonActive = true.obs;

  Icon get iconToBeShowed =>
      isSearchButtonActive.value ? Icon(Icons.search) : Icon(Icons.close);

  final TextEditingController searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    followingController.getFollowings(
      userID,
    ); // ekran açıldığında takip edilenleri getir

    var currentUser = authController.user.uid;
    var text =
    userID == currentUser ? Text("Takip ettiklerim") : Text("Takip edenler");
    var noFollowingText =
    userID == currentUser
        ? Text("Hiç kimseyi takip etmiyorsunuz ")
        : Text("ahaiç kimse sizi takip etmiyor.");

    return Scaffold(
      appBar: AppBar(
        title: Obx(
              () =>
          isSearchButtonActive.value
              ? text
              : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: searchBarController,
              decoration: InputDecoration(
                hintText: "Takip edilen ara...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white60),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                followingController.filterFollowings(value);
              },
            ),
          ),
        ),
        actions: [
          Obx(
                () => IconButton(
              onPressed: () {
                isSearchButtonActive.value = !isSearchButtonActive.value;
              },
              icon: Icon(iconToBeShowed.icon),
            ),
          ),
        ],
      ),

      body: Obx(() {
        if (followingController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final followings = followingController.filteredFollowings;

        if (followings.isEmpty) {
          return Center(child: noFollowingText);
        }

        return ListView.builder(
          itemCount: followings.length,
          itemBuilder: (context, index) {
            final user = followings[index];
            return ListTile(
              onTap: (){
                Get.to(()=>PreviewProfileScreen(myUser: user,));
              },
              leading: CircleAvatar(
                backgroundImage:
                user.profilePhotoUrl.isNotEmpty
                    ? NetworkImage(user.profilePhotoUrl)
                    : null,
                child:
                user.profilePhotoUrl.isEmpty
                    ? Text(user.name?.substring(0, 1).toUpperCase() ?? "?")
                    : null,
              ),
              title: Text(user.name ?? "İsimsiz"),
              subtitle: Text(user.email ?? ""),
            );
          },
        );
      }),
    );
  }
}
