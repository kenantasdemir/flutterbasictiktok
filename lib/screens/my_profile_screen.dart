import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:mytiktokcloneapp/models/MyUser.dart';
import 'package:mytiktokcloneapp/screens/followers_screen.dart';
import 'package:mytiktokcloneapp/screens/following_screen.dart';
import 'package:mytiktokcloneapp/screens/preview_liked_videos_screen.dart';
import '../colors.dart';
import '../controllers/profile_controller.dart';
import 'image_preview_screen.dart';
import 'package:mytiktokcloneapp/models/Video.dart';
import '../controllers/video_controller.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());
  final VideoController videoController = Get.put(VideoController());

  late TabController _tabController = TabController(
    length: 4,
    vsync: ScrollableState(),
  );

  late MyUser myUser;

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(authController.user.uid);
    profileController.fetchLikedVideos(authController.user.uid);
    getUserBYID();
  }

  void getUserBYID() async {
    myUser = (await profileController.getUserById(authController.user.uid))!;
  }

  Widget _buildThumbnailGrid(List thumbnails) {
    return GridView.builder(
      padding: const EdgeInsets.all(4),
      itemCount: thumbnails.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: thumbnails[index],
          fit: BoxFit.cover,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      //  init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black12,
            leading: const Icon(Icons.person_add_alt_1_outlined),
            actions: const [Icon(Icons.more_horiz)],
            title: Text(
              "Profilim",

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
                                              imageUrl:
                                                  controller
                                                      .user['profilePhotoUrl'] ??
                                                  "",
                                            ),
                                      ),
                                    );
                                  },
                                  child: Hero(
                                    tag:
                                        controller.user['profilePhotoUrl'] ??
                                        "",
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            controller
                                                .user['profilePhotoUrl'] ??
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

                                // Kamera ikonu - sağ alt köşe
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
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 18,
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey[700],
                                      ),
                                      onPressed: () {

                                        // Fotoğraf değiştirme işlemi
                                        openModalBottomSheet(context);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: Text(controller.user["name"] ?? "")),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: Text(controller.user["email"] ?? "")),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                var currentUserUID = authController.user.uid;

                                Get.to(
                                  () => FollowingScreen(userID: currentUserUID),
                                );
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
                              onTap: () async {
                                var currentUserUID = authController.user.uid;

                                Get.to(
                                  () => FollowersScreen(
                                    userID: currentUserUID,
                                    user: myUser,
                                  ),
                                );
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Column(
                                children: [
                                  Text(
                                    controller.user['followers'] ?? "",
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
                            ElevatedButton(
                              onPressed: () {
                                authController.signOut();
                              },
                              child: Text(
                                "Çıkış yap",

                                style: const TextStyle(
                                  fontSize: 15,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 5),


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
                                child: TabBarView(
                                  children: [
                                    // Kullanıcının kendi yüklediği videoların küçük resimleri
                                    _buildThumbnailGrid(
                                      controller.user['thumbnails'] ?? [],
                                    ),
                                    const Center(child: Text("Gizli Videolar")), // Henüz uygulanmadı
                                    
                                    // Kaydedilen Videolar Sekmesi
                                    FutureBuilder<List<Video>>(
                                      future: videoController.getBookmarkedVideos(authController.user.uid),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const Center(child: CircularProgressIndicator());
                                        }
                                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                          return const Center(child: Text("Henüz kaydedilen video yok."));
                                        }
                                        final bookmarkedVideos = snapshot.data!;
                                        return GridView.builder(
                                          padding: const EdgeInsets.all(4),
                                          itemCount: bookmarkedVideos.length,
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 5,
                                          ),
                                          itemBuilder: (context, index) {
                                            final video = bookmarkedVideos[index];
                                            return CachedNetworkImage(
                                              imageUrl: video.thumbnail,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    
                                    GridView.builder(
                                      padding: const EdgeInsets.all(4),
                                      itemCount:
                                          profileController.likedVideos.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 5,
                                          ),
                                      itemBuilder: (context, index) {
                                        final video =
                                            profileController
                                                .likedVideos[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        PreviewLikedVideosScreen(
                                                          video: video,
                                                        ),
                                              ),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.network(
                                              video.thumbnail,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void openModalBottomSheet(BuildContext context) {
    showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Text(
                'Bir resim seç',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  authController.pickImage();
                },
                child: Text("Galeri"),
              ),
              ElevatedButton(
                onPressed: () {
                  authController.takeImage();
                },
                child: Text("Kamera"),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("İptal"),
              ),
            ],
          ),
        );
      },
    );
  }
}
