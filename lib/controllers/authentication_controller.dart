import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../colors.dart';
import '../models/MyUser.dart';
import '../screens/home_screen.dart';
import '../screens/login_methods_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  late Rx<File?> _pickedImage = Rx<File?>(null);

  File? get profilePhoto => _pickedImage.value;

  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginMethodsScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }




  Future<MyUser?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData(fields: "email,name,picture");
        final email = userData['email'] ?? '';
        final name = userData['name'] ?? '';
        final pictureUrl = userData['picture'] != null && userData['picture']['data'] != null ? userData['picture']['data']['url'] : '';

        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.tokenString);
        final userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

        await firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': name,
          'email': email,
          'profilePhotoUrl': pictureUrl,
        });
        return MyUser(
          name: name,
          email: email,
          uid: userCredential.user!.uid,
          profilePhotoUrl: pictureUrl,
        );
      } else {
        print('Facebook login failed: ${result.status}');
        return null;
      }
    } catch (e) {
      print('Facebook sign in error: $e');
      return null;
    }
  }


  Future<MyUser?> signInWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );

      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': userCredential.user!.displayName ?? '',
        'email': userCredential.user!.email ?? '',
        'profilePhotoUrl': userCredential.user!.photoURL ?? '',
      });

      return MyUser(
        name: userCredential.user!.displayName,
        email: userCredential.user!.email,
        uid: userCredential.user!.uid,
        profilePhotoUrl: userCredential.user!.photoURL ?? "",
      );
    } catch (e) {
      debugPrint("${e.toString()} GOOGLE ILE GIRIS HATASI");
    }
  }

  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      Get.snackbar(
        'Profile Picture',
        'You have successfully selected your profile picture!',
      );
      _pickedImage.value = File(pickedImage.path); // ✅ doğru kullanım
    }
  }

  void takeImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedImage != null) {
      Get.snackbar(
        'Profile Picture',
        'You have successfully took your profile picture!',
      );
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  // upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

 Future<void> registerUser(String username, String email, String password, File? image,) async {

    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty) {

        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        String downloadUrl = "";
        if (image != null) {
          downloadUrl = await _uploadToStorage(image);
        } else {
          downloadUrl = 'https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg';
        }


        MyUser user = MyUser(
          name: username,
          email: email,
          uid: cred.user!.uid,
          profilePhotoUrl: downloadUrl,
        );



        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

      } else {
        Get.snackbar('Error Creating Account', 'Please enter all the fields');
      }
    } catch (e) {
      Get.snackbar('Error Creating Account', e.toString());
      print("❌ Hata: $e");
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        Get.snackbar('Error Logging in', 'Please enter all the fields');
      }
    } catch (e) {
      Get.snackbar('Error Loggin gin', e.toString());
    }
  }

  void signOut() async {
    await firebaseAuth.signOut();
  }
}
