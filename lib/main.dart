import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_core/firebase_core.dart';
import 'components.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Attendance());
}

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  String scanResult = " ";
  String code = " ";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("Taegeuk Taekwondo Attendance",
              style: GoogleFonts.openSans()),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/new-logo.png"),
              SizedBox(height: 15.0),
              SansText(
                "Welcome to Taegeuk Taekwondo!",
                40.0,
              ),
              SizedBox(
                height: 15.0,
              ),
              SansText("Please scan your ID card to check-in:", 20.0),
              SizedBox(height: 15.0),

              // section for the button to press for scanning
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.black,
                ),
                icon: Icon(Icons.camera_alt_outlined),
                label: Text("Start Scan"),
                onPressed: scanBarcode,
              ),
              SizedBox(height: 15.0),
              // The text that appears after scanning a barcode
              Text(
                scanResult == null ? "Scan a code!" : "Thank you for checking in!",
                style: TextStyle(fontSize: 25.0, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Function for the barcode scanner
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
    
    // Telling the app what data to save
    Map<String, dynamic> dataToSend = {
      'timestamp': DateTime.now(),
    };
    
    // Code that sends the data to Firestore using the saved data
    code = scanResult;

    FirebaseFirestore.instance
        .collection('students')
        .doc(code)
        .collection('Attendance')
        .add(dataToSend);
  }
}
