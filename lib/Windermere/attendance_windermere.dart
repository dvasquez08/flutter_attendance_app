import 'package:attendance/Windermere/ready_testing_windermere.dart';
import 'package:attendance/Windermere/testing_windermere.dart';
import 'package:attendance/location_selection.dart';
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
      debugShowCheckedModeBanner: false, home: attendanceWindermere()));
}

class attendanceWindermere extends StatefulWidget {
  const attendanceWindermere({Key? key}) : super(key: key);

  @override
  State<attendanceWindermere> createState() => _attendanceWindermereState();
}

class _attendanceWindermereState extends State<attendanceWindermere> {
  String timestamp = " ";
  String scanResult = " ";
  String code = " ";
  String todayDate = " ";

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Text("Taegeuk Taekwondo Attendance Windermere",
            style: GoogleFonts.openSans(fontWeight: FontWeight.w300)),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/class8.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/new-logo.png"),
            SizedBox(height: 15.0),
            SansText("Welcome to Taegeuk Taekwondo!", 50.0),
            SizedBox(height: 15.0),
            SansText("Please scan your ID card to check-in:", 25.0),
            SizedBox(height: 15.0),

            // Here, I made a widget called ScanButton which takes the Gesture
            // detector used from the North pages and condenses it to just one
            // line of code here. This too is added in components.
            ScanButton(),
            SizedBox(height: 15.0),
            Text(
              scanResult == null ? "Scan a code!" : "Thank you",
              style: TextStyle(fontSize: 25.0, color: Colors.white),
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
                child: SansText('Menu', 30.0)),
            Column(
              // Same navigation layout as the north location. This is using
              // the button widget that I created to make the code look cleaner
              // and more readable. All widgets made are found in components.dart
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NavButton("Ready for Testing", readyTestWindermere()),
                SizedBox(height: 15.0),
                NavButton("Testing Check-in", testingWindermere()),
                SizedBox(height: 15.0),
                NavButton("Select Another Location", location_selection())
              ],
            )
          ],
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

    // Telling the app what data to save. This is saving the timestamp and the code
    // which sends data to two different docimemts
    Map<String, dynamic> dataToSend = {'timestamp': DateTime.now()};
    Map<String, dynamic> dataToSave = {'date': DateTime.now(), 'code': code};

    // This part sends the timestamp of the scanned barcode and sends it to
    // Firestore.
    code = scanResult;

    FirebaseFirestore.instance
        .collection('studentsWindermere')
        .doc(code)
        .collection('Attendance')
        .add(dataToSend);

    FirebaseFirestore.instance
        .collection('studentsWindermere')
        .doc('all')
        .collection('attended')
        .add(dataToSave);
  }
}
