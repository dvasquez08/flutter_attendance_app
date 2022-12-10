import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SansText extends StatelessWidget {
  final text;
  final size;
  const SansText(this.text, this.size, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.openSans(
          fontSize: size, fontWeight: FontWeight.w300, color: Colors.white),
    );
  }
}

class TextBlack extends StatelessWidget {
  final text;
  final size;
  const TextBlack(this.text, this.size, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.openSans(
          fontSize: size, fontWeight: FontWeight.w300, color: Colors.black),
    );
  }
}

class NavButton extends StatelessWidget {
  final text;
  final page;
  const NavButton(this.text, this.page, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: Border.all(color: Colors.black),
      color: Colors.white,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 20.0, color: Colors.black),
      ),
    );
  }
}
