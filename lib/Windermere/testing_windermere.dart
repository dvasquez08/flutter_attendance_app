import 'package:attendance/Windermere/attendance_windermere.dart';
import 'package:attendance/Windermere/ready_testing_windermere.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_core/firebase_core.dart';
import '../components.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false, home: testingWindermere()));
}

class testingWindermere extends StatefulWidget {
  const testingWindermere({Key? key}) : super(key: key);

  @override
  State<testingWindermere> createState() => _testingWindermereState();
}

class _testingWindermereState extends State<testingWindermere> {
  String scanResult = " ";
  String code = " ";
  String paper = "received";

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Text("Student Testing Check-in Windermere",
            style: GoogleFonts.openSans(fontWeight: FontWeight.w300)),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/testing7.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/new-logo.png"),
            SizedBox(height: 15.0),
            TextBlack("Belt Promotion Testing", 50.0),
            SizedBox(height: 15.0),
            TextBlack("Scan your ID card below to checkin for testing", 25.0),
            SizedBox(height: 15.0),
            GestureDetector(
              onTap: scanBarcode,
              child: Container(
                height: widthDevice / 17,
                width: heightDevice / 10,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.red,
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
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: SansText("Menu", 30.0),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NavButton("Class Attendance", attendanceWindermere()),
                SizedBox(height: 15.0),
                NavButton("Ready for Testing", readyTestWindermere())
              ],
            )
          ],
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

    // Telling the app what data to save
    Map<String, dynamic> dataToSend = {
      'Attended': DateTime.now(),
      'Paper': paper,
    };

    Map<String, dynamic> dataToSave = {
      'timestamp': DateTime.now(),
    };

    code = scanResult;

    FirebaseFirestore.instance
        .collection('testing')
        .doc('Windermere')
        .collection('TestDay')
        .doc(code)
        .collection('info')
        .add(dataToSend);

    FirebaseFirestore.instance
        .collection('studentsWindermere')
        .doc(code)
        .collection('testing')
        .add(dataToSave);
  }
}
