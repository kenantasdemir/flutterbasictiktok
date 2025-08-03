import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../colors.dart';
import '../widgets/text_input_field.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  var avatarImage = authController.profilePhoto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tiktok Clone',
              style: TextStyle(
                fontSize: 35,
                color: buttonColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text(
              'Kayıt ol',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 25),
            Obx(() {
              final avatarImage = authController.profilePhoto;

              return Stack(
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundImage:
                        avatarImage != null
                            ? FileImage(avatarImage!) as ImageProvider
                            : NetworkImage(
                              'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png',
                            ),
                    backgroundColor: Colors.black,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: () {
                       // openModalBottomSheet(context);
                        authController.pickImage();

                      },
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _usernameController,
                labelText: 'Username',
                icon: Icons.person,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _emailController,
                labelText: 'Email',
                icon: Icons.email,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _passwordController,
                labelText: 'Parola',
                icon: Icons.lock,
                isObscure: true,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 50,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: InkWell(
                onTap: () async{
                await  authController.registerUser(
                    _usernameController.text,
                    _emailController.text,
                    _passwordController.text,
                    authController.profilePhoto,
                  );
                },

                child: const Center(
                  child: Text(
                    'Kaydol',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Zaten bir hesabın var mı? ',
                  style: TextStyle(fontSize: 20),
                ),
                InkWell(
                  onTap: () => Get.to(() => LoginScreen()),
                  child: Text(
                    'Giriş yap',
                    style: TextStyle(fontSize: 20, color: buttonColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getBack(BuildContext context){
    if(avatarImage != null){
      Navigator.of(context).pop();
    }

  }

  void openModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
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
                child: Text("Gallery"),
              ),
              ElevatedButton(
                onPressed: () {
                  authController.takeImage();

                },
                child: Text("Camera"),
              ),

              ElevatedButton(
                onPressed: () {
                    Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
            ],
          ),
        );
      },
    );
  }
}
