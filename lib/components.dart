import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// This file contains all the widgets that the other pages call.
// These widgets are for commonly used code such as text sections
// that use the same font, buttons that look the same on multiple
// pages, etc.

// Custom text widget used throughout the app
// This is used when white text is needed
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

// Replicate of the last cutom text widget
// This one is used when black text is needed
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

//The component for the navigation buttons on the Drawer menu on the side of the pages.
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

// The button component that initiates the barcode scanner.
// Upon pressing this button, the barcode scanner is activated.
// Being that there are multiple locations with their own barcode scanner, this component was created to keep the location's code base look neater
class ScanButton extends StatefulWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  State<ScanButton> createState() => _ScanButtonState();
}

class _ScanButtonState extends State<ScanButton> {
  String scanResult = " ";
  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: scanBarcode,
      child: Container(
        height: widthDevice / 17,
        width: heightDevice / 10,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.indigo,
              offset: Offset(2, 2),
              blurRadius: 25,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Image.asset("assets/barscan.png")],
        ),
      ),
    );
  }
  Future scanBarcode() async {
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6677",
        "Cancel",
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      scanResult = "Failed to get platform version.";
    }
    if (!mounted) return;

    setState(() => this.scanResult = scanResult);
  }
}
