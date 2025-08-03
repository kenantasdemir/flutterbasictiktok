import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/add_video_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_methods_screen.dart';
import '../screens/login_screen.dart';
import '../screens/not_found_screen.dart';
import '../screens/register_screen.dart';
import '../screens/search_screen.dart';

class RouteManager {
  // 1. Rotaları tanımla
  static const String home = '/';
  static const String profile = '/profile';
  static const String loginMethods = '/login-methods';
  static const String emailLogin = '/login-with-email';

  static const String register = '/register';
  static const String search = '/search';
  static const String postVideo = '/search';
  static const String notFoundScreen = '/not-found';

  // ... Diğer rotalar

  // 2. Route generator fonksiyonu
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _buildRoute(HomeScreen(), settings);
      case loginMethods:
        return _buildRoute(LoginMethodsScreen(), settings);
      case emailLogin:
        return _buildRoute(LoginScreen(), settings);

      case search:
        return _buildRoute(SearchScreen(), settings);
      case register:
        return _buildRoute(RegisterScreen(), settings);
      case postVideo:
        return _buildRoute(AddVideoScreen(), settings);

      case profile:
      /*
        var user = settings.arguments as MyUser; // Argument örneği
        return _buildRoute(ProfileScreen(user: user, uid: '2',), settings);

         */
      default:
        return _buildRoute(NotFoundScreen(), settings);
    }
  }

  // 3. Standart route oluşturma
  static PageRoute _buildRoute(Widget page, RouteSettings settings) {
    if (Platform.isAndroid) {
      return MaterialPageRoute(builder: (_) => page, settings: settings);
    } else if (Platform.isIOS) {
      return CupertinoPageRoute(builder: (_) => page, settings: settings);
    }
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          // ✨ Özel efekt
          opacity: animation,
          child: child,
        );
      },
    );
  }

  // 4. GetX için özel yönlendirme (opsiyonel)
  static List<GetPage> getPages = [
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: loginMethods, page: () => LoginMethodsScreen()), // ✅ Doğru ekran
    GetPage(name: emailLogin, page: () => LoginScreen()),          // ✨ Buraya taşı
    GetPage(name: register, page: () => RegisterScreen()),
    GetPage(name: search, page: () => SearchScreen()),
    GetPage(name: postVideo, page: () => AddVideoScreen()),
    GetPage(name: notFoundScreen, page: () => NotFoundScreen()),
  ];


}
