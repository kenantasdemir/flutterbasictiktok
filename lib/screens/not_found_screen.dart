import "package:flutter/material.dart";

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // Ana container'ı merkezliyoruz
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // İçeriği sıkıştırıyoruz
          children: [
            const Text(
              "Aradığınız sayfayı bulamadık efendim.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontFamily: "Everytime"),
            ),
            const SizedBox(height: 10), // Text ile resim arasına 20 piksel boşluk
            Image.asset(
              "assets/space.webp",
              height: MediaQuery.of(context).size.height * 0.6, // Ekran yüksekliğinin %60'ı
              fit: BoxFit.contain, // Resmi orantılı sığdır
            ),
          ],
        ),
      ),
    );
  }
}