import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mytiktokcloneapp/controllers/profile_controller.dart';
import 'package:mytiktokcloneapp/screens/add_video_screen.dart';
import 'package:mytiktokcloneapp/screens/my_chats_screen.dart';
import 'package:mytiktokcloneapp/screens/my_profile_screen.dart';
import 'package:mytiktokcloneapp/screens/search_screen.dart';
import 'package:mytiktokcloneapp/screens/video_screen.dart';
import 'controllers/authentication_controller.dart';

List pages = [
  VideoScreen(),
  SearchScreen(),
  const AddVideoScreen(),
  MyChatsScreen(),
  ProfileScreen(uid:authController.user.uid),
];

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;



// CONTROLLER
var authController = AuthController.instance;
var profileController = ProfileController.instance;

