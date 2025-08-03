import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:get/get_core/src/get_main.dart";
import "package:get/get_state_manager/src/simple/get_state.dart";
import "package:mytiktokcloneapp/models/MyUser.dart";
import "package:mytiktokcloneapp/screens/preview_liked_videos_screen.dart";
import "../colors.dart";
import "../controllers/profile_controller.dart";
import "followers_screen.dart";
import "following_screen.dart";
import "image_preview_screen.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:mytiktokcloneapp/models/Video.dart";
import "package:mytiktokcloneapp/controllers/video_controller.dart";


class PreviewProfileScreen extends StatefulWidget {

  final MyUser myUser;
  const PreviewProfileScreen({super.key,required this.myUser});

  @override
  State<PreviewProfileScreen> createState() => _PreviewProfileScreenState();
}

class _PreviewProfileScreenState extends State<PreviewProfileScreen> {
  List<Video> uploadedVideos = [];
  List<Video> bookmarkedVideos = [];
  List<Video> likedVideos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllVideos();
  }

  Future<void> fetchAllVideos() async {
    final videoController = Get.find<VideoController>();
    final profileController = Get.find<ProfileController>();
    final uid = widget.myUser.uid;
    // Yüklediği videolar
    final uploaded = await FirebaseFirestore.instance
        .collection('videos')
        .where('uid', isEqualTo: uid)
        .get();
    uploadedVideos = uploaded.docs.map((doc) => Video.fromSnap(doc)).toList();
    // Kaydettiği videolar
    bookmarkedVideos = await videoController.getBookmarkedVideos(uid);
    // Beğendiği videolar
    await profileController.fetchLikedVideos(uid);
    likedVideos = profileController.likedVideos;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      //  init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black12,
            actions: const [Icon(Icons.more_horiz)],
            title: Text(
              authController.user.uid == widget.myUser.uid
                  ? "Profilim"
                  : widget.myUser.name!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  SizedBox(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (_) => ImagePreviewScreen(
                                          imageUrl: widget.myUser.profilePhotoUrl

                                        ),
                                      ),
                                    );
                                  },
                                  child: Hero(
                                    tag:
                                    widget.myUser.profilePhotoUrl ??
                                        "",
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl:
                                        widget.myUser.profilePhotoUrl
                                            ??
                                            "",
                                        height: 100,
                                        width: 100,
                                        placeholder:
                                            (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget:
                                            (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                              if(  authController.user.uid == widget.myUser.uid )

                                Positioned(
                                  bottom: 0,
                                  right: 4,
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child:  IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 18,
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey[700],
                                      ),
                                      onPressed: () {
                                        // Fotoğraf değiştirme işlemi

                                      },
                                    )
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: Text(widget.myUser.name ?? "")),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: Text(widget.myUser.email ?? "")),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                var currentUser = authController.user.uid;

                                var uid = widget.myUser.uid == currentUser ? currentUser : widget.myUser.uid;

                                Get.to(() => FollowingScreen(userID: widget.myUser.uid));
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Column(
                                children: [
                                  Text(
                                    controller.user['following'] ?? "",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Takip',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.black54,
                              width: 1,
                              height: 15,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                var currentUser = authController.user.uid;

                                var uid = widget.myUser.uid == currentUser ? currentUser : widget.myUser.uid;

                                Get.to(() => FollowersScreen(userID: widget.myUser.uid,user: widget.myUser,));
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Column(
                                children: [
                                  Text(

                                    "0",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Takipçi',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.black54,
                              width: 1,
                              height: 15,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  controller.user['likes'] ?? "",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Beğenme',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() {
                              final isSelf = widget.myUser.uid == authController.user.uid;
                              final isFollowing = profileController.isFollowingMap[widget.myUser.uid] ?? false;
                              return ElevatedButton(
                                onPressed: () {
                                  if (isSelf) {
                                    authController.signOut();
                                  } else {
                                    if (isFollowing) {
                                      controller.unfollowUser(authController.user.uid, widget.myUser.uid);
                                    } else {
                                      controller.followUser(authController.user.uid, widget.myUser.uid);
                                    }
                                  }
                                },
                                child: Text(
                                  isSelf ? 'Çıkış yap' : (isFollowing ? 'Takipten çık' : 'Takip et'),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }),
                            SizedBox(width: 5),

                            if (authController.user.uid != widget.myUser.uid)
                              ElevatedButton(
                                onPressed: () {



                                },
                                child: Text("Mesaj gönder"),
                              ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        DefaultTabController(
                          length: 4,
                          child: Column(
                            children: [
                              const TabBar(
                                indicatorColor: Colors.black,
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.grey,
                                tabs: [
                                  Tab(icon: Icon(Icons.grid_on)),
                                  Tab(icon: Icon(Icons.lock_outline)),
                                  Tab(icon: Icon(Icons.bookmark_border)),

                                  Tab(icon: Icon(Icons.favorite_border)),
                                ],
                              ),
                              SizedBox(
                                height: 300,
                                child: isLoading
                                    ? const Center(child: CircularProgressIndicator())
                                    : TabBarView(
                                        children: [
                                          // 1. Yüklediği videolar
                                          buildVideoGrid(uploadedVideos),
                                          // 2. Gizli videolar (şimdilik boş)
                                          Center(child: Text("Gizli Videolar")),
                                          // 3. Kaydettiği videolar
                                          buildVideoGrid(bookmarkedVideos),
                                          // 4. Beğendiği videolar
                                          buildVideoGrid(likedVideos),
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildVideoGrid(List<Video> videos) {
    if (videos.isEmpty) {
      return const Center(child: Text("Hiç video yok"));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(4),
      itemCount: videos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        final video = videos[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PreviewLikedVideosScreen(video: video),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              video.thumbnail,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
