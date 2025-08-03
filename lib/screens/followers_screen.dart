import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytiktokcloneapp/colors.dart';
import 'package:mytiktokcloneapp/models/MyUser.dart';
import 'package:mytiktokcloneapp/screens/preview_profile_screen.dart';
import '../controllers/followers_controller.dart';

class FollowersScreen extends StatelessWidget {
  final String userID;
  final MyUser user;

  FollowersScreen({super.key, required this.userID,required this.user});

  final FollowersController followersController = Get.put(
    FollowersController(),
  );

  final RxBool isSearchButtonActive = true.obs;

  Icon get iconToBeShowed =>
      isSearchButtonActive.value ? Icon(Icons.search) : Icon(Icons.close);

  final TextEditingController searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    followersController.getFollowers(
      userID,
    ); // ekran açıldığında takipçileri getir

    var currentUser = authController.user.uid;
    var text =
        userID == currentUser ? Text("Takipçilerim") : Text("Takipçiler");
    var noFollowerText =
        userID == currentUser
            ? Text("Hiç takipçiniz yok")
            : Text("Takipçi Yok");

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () =>
              isSearchButtonActive.value
                  ? Text(userID == currentUser ? "Takipçilerim" : "Takipçiler")
                  : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: searchBarController,
                      decoration: InputDecoration(
                        hintText: "Takipçi ara...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white60),
                      ),
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        followersController.filterFollowers(value);
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
        if (followersController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final followers = followersController.filteredFollowers;

        if (followers.isEmpty) {
          return Center(child: noFollowerText);
        }

        return ListView.builder(
          itemCount: followers.length,
          itemBuilder: (context, index) {
            final user = followers[index];
            return ListTile(
              onTap: (){
                Get.to(()=>PreviewProfileScreen(myUser: user));
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
