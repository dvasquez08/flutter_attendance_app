import 'package:attendance/main.dart';
import 'package:attendance/ready_testing_north.dart';
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
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: testingNorth()));
}

class testingNorth extends StatefulWidget {
  const testingNorth({Key? key}) : super(key: key);

  @override
  State<testingNorth> createState() => _testingNorthState();
}

class _testingNorthState extends State<testingNorth> {
  String scanResult = " ";

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Student Testing Check-in", style: GoogleFonts.openSans()),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/testing2.jpg"),
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
            // Section for how the scan button properties button properties
            GestureDetector(
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
            ),
          // End of section for the scan button properties
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
                MaterialButton(
                  shape: Border.all(color: Colors.black),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => readyTestNorth(),
                      ),
                    );
                  },
                  child: const Text(
                    "Ready for Testing",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                MaterialButton(
                  shape: Border.all(color: Colors.black),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Attendance(),
                      ),
                    );
                  },
                  child: const Text(
                    "Class Attendance",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
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

    // Telling the app what data to save. This is saving the timestamp of when a studeng checked in for testing
    // and the string for paper received. 
    Map<String, dynamic> dataToSend = {
      'Attended': DateTime.now(),
      'Paper': paper,
    };

    Map<String, dynamic> dataToSave = {
      'timestamp': DateTime.now(),
    };

    code = scanResult;
    
    // Two Firebase instances where it adds the info to the student's name which was added by
    // the ready_test page confirming that they attended testing and also puts a timestamp
    // on the student's personal profile under the main students collection

    FirebaseFirestore.instance
        .collection('testing')
        .doc('north')
        .collection('TestDay')
        .doc(code)
        .collection('info')
        .add(dataToSend);

    FirebaseFirestore.instance
        .collection('students')
        .doc(code)
        .collection('testing')
        .add(dataToSave);
  }
}
