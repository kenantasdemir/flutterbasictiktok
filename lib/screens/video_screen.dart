
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytiktokcloneapp/models/MyUser.dart';
import 'package:mytiktokcloneapp/screens/preview_profile_screen.dart';
import '../colors.dart';
import '../controllers/video_controller.dart';
import '../controllers/profile_controller.dart';
import '../models/Video.dart';
import '../widgets/circle_animation.dart';
import '../widgets/video_player_item.dart';
import 'comment_screen.dart';

class VideoScreen extends StatefulWidget {
  final Video? video;

  const VideoScreen({Key? key, this.video}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final VideoController videoController = Get.put(VideoController());
  final ProfileController profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          itemCount: videoController.videoList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = videoController.videoList[index];

            return FutureBuilder<MyUser?>(
              future: profileController.getUserById(data.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final myUser = snapshot.data!;

                return Stack(
                  children: [
                    VideoPlayerItem(videoUrl: data.videoUrl),
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
                                  padding: const EdgeInsets.only(left: 20, bottom: 30),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => PreviewProfileScreen(myUser: myUser),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          data.username,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        data.caption,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.music_note, size: 15, color: Colors.white),
                                          Text(
                                            data.songName,
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
                                    buildProfile(data.profilePhoto, context, myUser),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () => videoController.likeVideo(data.id),
                                          child: Icon(
                                            Icons.favorite,
                                            size: 40,
                                            color: data.likes.contains(authController.user.uid)
                                                ? Colors.red
                                                : Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 7),
                                        Text(
                                          data.likes.length.toString(),
                                          style: const TextStyle(fontSize: 20, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => CommentScreen(
                                                commentId: data.id,
                                                myUser: myUser,
                                              ),
                                            ),
                                          ),
                                          child: const Icon(Icons.comment, size: 40, color: Colors.white),
                                        ),
                                        const SizedBox(height: 7),
                                        Text(
                                          data.commentCount.toString(),
                                          style: const TextStyle(fontSize: 20, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    // Bookmark butonu ve sayacı (stream ile anlık)
                                    StreamBuilder<bool>(
                                      stream: videoController.isBookmarkedStream(data.id, authController.user.uid),
                                      builder: (context, snapshot) {
                                        final isBookmarked = snapshot.data ?? false;
                                        return Column(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                if (isBookmarked) {
                                                  await videoController.unbookmarkVideo(data.id, authController.user.uid);
                                                } else {
                                                  await videoController.bookmarkVideo(data.id, authController.user.uid);
                                                }
                                              },
                                              child: Icon(
                                                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                                size: 40,
                                                color: isBookmarked ? Colors.amber : Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 7),
                                            StreamBuilder<int>(
                                              stream: videoController.bookmarkCountStream(data.id),
                                              builder: (context, countSnapshot) {
                                                final count = countSnapshot.data ?? 0;
                                                return Text(
                                                  count.toString(),
                                                  style: const TextStyle(fontSize: 20, color: Colors.white),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: const Icon(Icons.reply, size: 40, color: Colors.white),
                                        ),
                                        const SizedBox(height: 7),
                                        Text(
                                          data.shareCount.toString(),
                                          style: const TextStyle(fontSize: 20, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    CircleAnimation(
                                      child: buildMusicAlbum(data.profilePhoto),
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
          },
        );
      }),
    );
  }
  Widget buildProfile(String profilePhoto, BuildContext context, MyUser myUser) {
    final currentUid = authController.user.uid;
    final isMe = currentUid == myUser.uid;

    if (!profileController.isFollowingMap.containsKey(myUser.uid)) {
      profileController.checkIsFollowing(currentUid, myUser.uid);
    }

    return Obx(() {
      // Eğer bilgi yüklenmediyse hiç buton gösterme
      if (!profileController.isFollowingMap.containsKey(myUser.uid)) {
        return const SizedBox.shrink();
      }
      final isFollowing = profileController.isFollowingMap[myUser.uid] ?? false;

      return InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PreviewProfileScreen(myUser: myUser),
            ),
          );
        },
        child: SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                child: Container(
                  width: 70,
                  height: 70,
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Image(
                      image: NetworkImage(profilePhoto),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              /// FOLLOW (+) BUTONU - AnimatedSwitcher ile animasyonlu şekilde kaybolur
              if (!isMe)
                Positioned(
                  bottom: 0,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: isFollowing
                        ? const SizedBox.shrink(
                      key: ValueKey('empty'),
                    )
                        : GestureDetector(
                      key: const ValueKey('followButton'),
                      onTap: () => profileController.followUser(currentUid, myUser.uid),
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }



  Widget buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.grey, Colors.white]),
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
}
