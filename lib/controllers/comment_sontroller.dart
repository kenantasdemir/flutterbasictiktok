import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../colors.dart';
import '../models/comment.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);

  List<Comment> get comments => _comments.value;

  String _postId = "";

  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {
    _comments.bindStream(
      firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .snapshots(source: ListenSource.defaultSource)
          .map((QuerySnapshot query) {
            List<Comment> retValue = [];
            for (var element in query.docs) {
              retValue.add(Comment.fromSnap(element));
            }
            return retValue;
          }),
    );
    debugPrint("AUTH CONTROLLER USER ID : ${authController.user!.uid}");
  }

  //ÇALIŞIYOR ELLEME SAKIN
  postComment(String commentOwnerID,String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc =
            await firestore
                .collection('users')
                .doc(authController.user.uid)
                .get();
        var allDocs =
            await firestore
                .collection('videos')
                .doc(_postId)
                .collection('comments')
                .get();

        int len = allDocs.docs.length;

        Comment comment = Comment(
          commentOwnerID: commentOwnerID,
          username: (userDoc.data()! as dynamic)['name'],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          profilePhoto: (userDoc.data()! as dynamic)['profilePhotoUrl'],
          uid: authController.user.uid,
          id: "Video $len",
        );

        await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc(comment.id)
            .set(comment.toJson());

        DocumentSnapshot doc =
            await firestore.collection('videos').doc(_postId).get();
        await firestore.collection('videos').doc(_postId).update({
          'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
        });
      }
    } catch (e) {
      /*
      Get.snackbar(
        'Error While Commenting',
        e.toString(),
      );

       */
    }
  }

  //ÇALIŞIYOR ELLEME SAKIN
  likeComment(String id) async {
    var uid = authController.user.uid;
    DocumentSnapshot doc =
        await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc(id)
            .get();
    debugPrint("COMMENT CONTROLLER DOC ${doc.data()}");

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
            'likes': FieldValue.arrayRemove([uid]),
          });
    } else {
      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
            'likes': FieldValue.arrayUnion([uid]),
          });
    }
  }

  //ÇALIŞIYOR ELLEME SAKIN
  deleteComment(String commentId) async {
    try {
      // Yorumu sil
      await firestore
          .collection("videos")
          .doc(_postId)
          .collection("comments")
          .doc(commentId)
          .delete();

      // Video dokümanını al
      DocumentSnapshot doc = await firestore.collection('videos').doc(_postId).get();

      int currentCount = (doc.data()! as dynamic)['commentCount'] ?? 0;

      // 0'ın altına düşmesini önle
      int updatedCount = currentCount > 0 ? currentCount - 1 : 0;

      await firestore.collection('videos').doc(_postId).update({
        'commentCount': updatedCount,
      });
    } catch (e) {
      // Hataları burada loglamak faydalı olabilir
      print("Yorum silme hatası: $e");
    }
  }

}
