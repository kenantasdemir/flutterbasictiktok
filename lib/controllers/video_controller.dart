import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../colors.dart';
import '../models/Video.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(
        firestore.collection('videos').snapshots().map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(
          Video.fromSnap(element),
        );
      }
      return retVal;
    }));
  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    var uid = authController.user.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  // --- YENİ BOOKMARK FONKSİYONLARI ---

  // Videoyu kaydet (bookmark ekle) - Sorgu için userId alanı eklendi
  Future<void> bookmarkVideo(String videoId, String userId) async {
    await firestore
        .collection('videos')
        .doc(videoId)
        .collection('bookmarks')
        .doc(userId)
        .set({
          'createdAt': FieldValue.serverTimestamp(),
          'userId': userId, // collectionGroup sorgusu için eklendi
    });
  }

  // Videoyu kaydetmekten çıkar (bookmark kaldır)
  Future<void> unbookmarkVideo(String videoId, String userId) async {
    await firestore
        .collection('videos')
        .doc(videoId)
        .collection('bookmarks')
        .doc(userId)
        .delete();
  }

  // Kullanıcı bu videoyu kaydetmiş mi? (anlık stream)
  Stream<bool> isBookmarkedStream(String videoId, String userId) {
    return firestore
        .collection('videos')
        .doc(videoId)
        .collection('bookmarks')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  // Bu video kaç kez kaydedilmiş? (anlık stream)
  Stream<int> bookmarkCountStream(String videoId) {
    return firestore
        .collection('videos')
        .doc(videoId)
        .collection('bookmarks')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Kullanıcının kaydettiği tüm videoları getir - Sorgu düzeltildi
  Future<List<Video>> getBookmarkedVideos(String userId) async {
    final List<Video> bookmarkedVideos = [];
    // Düzeltilmiş sorgu: `userId` alanına göre filtreleme
    final querySnapshot = await firestore
        .collectionGroup('bookmarks')
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in querySnapshot.docs) {
      // Videonun ana dokümanını bul
      final videoId = doc.reference.parent.parent!.id;
      final videoDoc = await firestore.collection('videos').doc(videoId).get();
      if (videoDoc.exists) {
        bookmarkedVideos.add(Video.fromSnap(videoDoc));
      }
    }
    return bookmarkedVideos;
  }
}