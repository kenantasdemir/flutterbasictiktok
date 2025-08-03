import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytiktokcloneapp/controllers/video_controller.dart';
import 'package:mytiktokcloneapp/routes/route_manager.dart';

import 'colors.dart';
import 'controllers/authentication_controller.dart';
import 'controllers/profile_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then((value) {
    Get.put(AuthController());
    Get.put(ProfileController());
    Get.put(VideoController());
  });

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );




  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: RouteManager.getPages,
      initialRoute: RouteManager.loginMethods,
      debugShowCheckedModeBanner: false,
      title: 'TikTok Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
    );
  }
}
