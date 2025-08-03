import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:mytiktokcloneapp/controllers/profile_controller.dart";
import "package:mytiktokcloneapp/models/MyUser.dart";
import "package:mytiktokcloneapp/screens/preview_profile_screen.dart";
import "package:mytiktokcloneapp/screens/my_profile_screen.dart";

import "../colors.dart";
import "../controllers/video_controller.dart";
import "../models/Video.dart";
import "../widgets/circle_animation.dart";
import "../widgets/video_player_item.dart";
import "comment_screen.dart";




class PreviewLikedVideosScreen extends StatelessWidget {
  final Video? video;

  PreviewLikedVideosScreen({super.key, this.video});
  final VideoController videoController = Get.put(VideoController());

  late MyUser myUser;



  buildProfile(String profilePhoto, BuildContext context) {
    return InkWell(
      onTap: () async {
        final myUser = await profileController.getUserById(video!.uid);
        if (myUser != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PreviewProfileScreen(myUser: myUser),
            ),
          );
        } else {
          // Hata mesajı göstermek istersen buraya yazabilirsin
        }
      },
      child: SizedBox(
        width: 60,
        height: 60,
        child: Stack(
          children: [
            Positioned(
              left: 5,
              child: Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image(
                    image: NetworkImage(profilePhoto),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(11),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.grey, Colors.white],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  var profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Geri gel"),
      ),
      body: Obx(() {
        return PageView.builder(
          itemCount: profileController.likedVideos.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
          //  final data = videoController.videoList[index];
            return Stack(
              children: [
                VideoPlayerItem(videoUrl: video!.videoUrl),
                Column(
                  children: [
                    const SizedBox(height: 100),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 20,
                                bottom: 30,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: ()async{
                                      myUser =(await profileController.getUserById(video!.uid))!;
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context)=>PreviewProfileScreen(myUser:myUser ))
                                      );
                                    },
                                    child: Text(
                                      video!.username,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    video!.caption,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.music_note,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        video!.songName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            margin: EdgeInsets.only(top: size.height / 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildProfile(video!.profilePhoto, context),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap:
                                          () => videoController.likeVideo(
                                        video!.id,
                                      ),
                                      child: Icon(
                                        Icons.favorite,
                                        size: 40,
                                        color:
                                        video!.likes.contains(
                                          authController.user.uid,
                                        )
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      video!.likes.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap:
                                          () => Navigator.of(
                                        context,
                                        rootNavigator: false,
                                      ).push(
                                        MaterialPageRoute(
                                          builder:
                                              (context) => CommentScreen(
                                            commentId: video!.id,
                                                myUser: myUser,
                                          ),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.comment,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      video!.commentCount.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.reply,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      video!.shareCount.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                CircleAnimation(
                                  child: buildMusicAlbum(video!.profilePhoto),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
