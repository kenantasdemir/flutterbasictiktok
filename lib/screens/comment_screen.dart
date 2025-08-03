import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytiktokcloneapp/models/MyUser.dart';
import 'package:mytiktokcloneapp/screens/preview_profile_screen.dart';
import 'package:timeago/timeago.dart' as time;
import '../colors.dart';
import '../controllers/comment_sontroller.dart';
import '../controllers/profile_controller.dart';
import '../models/comment.dart';

class CommentScreen extends StatelessWidget {
  final String commentId;
  MyUser myUser;

  CommentScreen({Key? key, required this.commentId,required this.myUser}) : super(key: key);

  final TextEditingController textEditingController = TextEditingController();
  CommentController commentController = Get.put(CommentController());
  final ProfileController profileController = Get.find<ProfileController>();


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentController.updatePostId(commentId);


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: commentController.comments.length,
                  itemBuilder: (context, index) {
                    final comment = commentController.comments[index];
                    return GestureDetector(
                      onLongPress: () {
                        openModalBottomSheet(context, commentId, comment);
                      },
                      child: ListTile(
                        leading: InkWell(
                          onTap: () async{
                             myUser = (await profileController.getUserById(comment.uid))!;

                             Navigator.of(context).push(
                               MaterialPageRoute(
                                 builder: (context) => PreviewProfileScreen(myUser: myUser),
                               ),
                             );
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(
                              comment.profilePhoto,
                            ),
                          ),
                        ),
                        title: GestureDetector(
                          onLongPress: () {
                            openModalBottomSheet(
                              context,
                              comment.id,
                              comment,
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  " ${comment.username}  ",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                comment.comment,

                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              time.format(comment.datePublished.toDate()),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              ' ${comment.likes.length} beğeni',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            commentController.likeComment(comment.id);
                          },
                          icon: Icon(Icons.favorite),
                          iconSize: 25,
                          color:
                              comment.likes.contains(authController.user.uid)
                                  ? Colors.red
                                  : Colors.white,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            const Divider(),
            ListTile(
              title: TextFormField(
                controller: textEditingController,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              trailing: TextButton(
                onPressed: () {
                  commentController.postComment(
                    authController.user.uid,
                    textEditingController.text,
                  );
                  textEditingController.text = "";
                },
                child: const Text(
                  'Gönder',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openModalBottomSheet(BuildContext context, String id, Comment comment) {
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
                'Aksiyonlar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              if (firebaseAuth.currentUser!.uid == comment.commentOwnerID)
                ElevatedButton(
                  onPressed: () {
                    commentController.deleteComment(
                      comment.id,
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text("Sil"),
                ),
              ElevatedButton(
                onPressed: () {},
                child: Text("Bildir"),
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
