import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:get/get.dart";


import "../colors.dart";
import "../widgets/social_login_button.dart";
import "home_screen.dart";
import "login_screen.dart";

class LoginMethodsScreen extends StatelessWidget {
  const LoginMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialLoginButton(
            butonText: "Email ile giriş yap",
            textColor: Colors.black,
            butonIcon: Image.asset("assets/person.png"),
            onPressed: () {
                Get.to(()=>LoginScreen());
            },
      ),
            SocialLoginButton(
              butonText: "Facebook ile giriş yap",
              textColor: Colors.black,
              butonIcon: Image.asset("assets/face.png",),
              onPressed: () async {

               var sonuc =await authController.signInWithFacebook();
               if(sonuc != null){
                 Get.to(()=>HomeScreen());
               }


              },
            ),

            SocialLoginButton(
              butonText: "Google ile giriş yap",
              textColor: Colors.black,
              butonIcon: Image.asset("assets/google.png"),
              onPressed: () async{

                await authController.signInWithGoogle();
              },
            ),


          ],
        ),
      ),
    );
  }
}
