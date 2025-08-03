import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String butonText;
  final Color butonColor;
  final Color textColor;
  final double radius;
  final double yukseklik;
  final Widget butonIcon;
  final VoidCallback onPressed;

  const SocialLoginButton({
    Key? key,
    required this.butonText,
    this.butonColor = Colors.white,
    required this.textColor,
    this.radius = 25,
    this.yukseklik = 40,
    required this.butonIcon,
    required this.onPressed,
  })  : assert(butonText != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: yukseklik,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: butonColor, // Eskiden 'color' idi
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(radius),
              ),
            ),
            padding: EdgeInsets.zero, // İç boşluğu sıfırladık
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (butonIcon != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: butonIcon,
                ),
                Text(
                  butonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor),
                ),
                Opacity(
                  opacity: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: butonIcon,
                  ),
                ),
              ],
              if (butonIcon == null) ...[
                const SizedBox(width: 16),
                Text(
                  butonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor),
                ),
                const SizedBox(width: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}