import 'package:attendance/Terwilliger/attendance_terwilliger.dart';
import 'package:attendance/Terwilliger/testing_terwilliger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_core/firebase_core.dart';
import '../components.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false, home: readyTestTerwilliger()));
}

class readyTestTerwilliger extends StatefulWidget {
  const readyTestTerwilliger({Key? key}) : super(key: key);

  @override
  State<readyTestTerwilliger> createState() => _readyTestTerwilligerState();
}

class _readyTestTerwilligerState extends State<readyTestTerwilliger> {
  String scanResult = " ";
  String code = " ";
  String readyTest = "Ready for Testing";
  String info = "info";

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: Text("Student Ready for Testing Terwilliger",
            style: GoogleFonts.openSans(fontWeight: FontWeight.w300)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/class4.png"), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/new-logo.png"),
            SizedBox(height: 15.0),
            SansText("Student Ready For Testing", 40.0),
            SizedBox(height: 15.0),
            SansText(
                "Scan student ID card to add them to list of students that are ready for testing",
                20.0),
            SizedBox(height: 15.0),
            ScanButton()
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: SansText("menu", 30.0),
            ),
            Column(
              children: [
                NavButton("Testing Check-in", testingTerwilliger()),
                SizedBox(height: 15.0),
                NavButton("Class Attendance", AttendanceTerwilliger())
              ],
            )
          ],
        ),
      ),
    );
  }

  // The function that makes the barcode scanner work
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
    Map<String, String> dataToSave = {
      'Status': readyTest,
    };

    code = scanResult;
    // The Firebase instance that sends the student's code into a list for
    // students that are ready for testing, then the testing check-in page
    //will update that same list when they scan in.

    FirebaseFirestore.instance
        .collection('testing')
        .doc('terwilliger')
        .collection('TestDay')
        .doc(code)
        .collection('info')
        .add(dataToSave);
  }
}
