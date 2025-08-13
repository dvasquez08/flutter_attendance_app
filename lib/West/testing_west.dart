// Import for the other pages for the West location
import 'package:attendance/West/attendance_west.dart';
import 'package:attendance/West/ready_testing_west.dart';
// Firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Package imports that include Google fonts and the barcode scanner package
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// Importing the reuusable code from the components file
import '../components.dart';

// Initializing Firebase. This function is async because Firebase initialization must be completed before the app runs
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: testingWest()));
}
// The StatefulWidget that manages the check-in process for students attending testing at the West location.
class testingWest extends StatefulWidget {
  const testingWest({Key? key}) : super(key: key);

  @override
  State<testingWest> createState() => _testingWestState();
}

class _testingWestState extends State<testingWest> {
  // State variables to hold the testing attendance and if the form was submitted.
  String scanResult = " ";
  String code = " ";
  String paper = "received";

  @override
  Widget build(BuildContext context) {
    // These variables capture the device's screen dimensions.
    // They are used here for adjusting the size of containers and adding responsiveness.
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      //App bar section that contains the screen title
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Text("Student Testing Check-in West",
            style: GoogleFonts.openSans(fontWeight: FontWeight.w300)),
        centerTitle: true,
      ),

      // Main content of the screen, also sets the background image
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/testing4.png"),
            fit: BoxFit.cover,
          ),
        ),

        // Column arranges the content in a vertical array.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // The page header, the logo, and instructions that directs the user to scan their barcode
          children: [
            Image.asset("assets/new-logo.png"),
            SizedBox(height: 15.0),
            SansText("Belt Promotion Testing", 50.0),
            SizedBox(height: 15.0),
            SansText("Scan your ID card below to checkin for testing", 25.0),
            SizedBox(height: 15.0),

            // Button section for checking in students who attended testing
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
                // The barcode logo placed inside the button
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

      // Drawer for the slide-out menu for navigation.
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // The header for the drawer.
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: SansText("Menu", 30.0),
            ),
            // This column holds the navigation buttons inside the drawer.
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NavButton("Class Attendance", attendanceWest()), // Using the NavButton component, takes the user to the main attendance page for this location
                SizedBox(height: 15.0),
                NavButton("Ready for Testing", readyTestWest()) // Using the the NavButton component, this takes the user back to the 'Ready for Testing' screen
              ],
            )
          ],
        ),
      ),
    );
  }

  // Initiates the barcode scanning process and handles the result.
  Future scanBarcode() async {
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6677", // The color of the line across the scanner
        "Cancel", // Shows the cancel button
        true, // Boolean for enabling flash
        ScanMode.BARCODE, // Specifying Barcode mode, QR sets to scan QR codes
      );
    } on PlatformException {
      scanResult = "Failed to get platform version."; // Error handling
    }
    // A check to ensure the widget is still in the widget tree before updating state.
    // This prevents errors if the user navigates away while scanning is in progress.
    if (!mounted) return; 

    setState(() => this.scanResult = scanResult); // Update the state with the result of the scan

    // Telling the app what data to send to Firestore which is indicating that the student
    // submitted the form and attended testing
    Map<String, dynamic> dataToSend = {
      'Attended': DateTime.now(),
      'Paper': paper,
    };

    Map<String, dynamic> dataToSave = {
      'timestamp': DateTime.now(), // A different timestamp used if the student passed
    };

    code = scanResult; // Assign the scanned result to the 'code' variable.

    // Save the attendance timestamp to the specific student's record in Firestore.
    FirebaseFirestore.instance
        .collection('testing')
        .doc('west')
        .collection('TestDay')
        .doc(code)
        .collection('info')
        .add(dataToSend);

    // Send the timestamp if the student passed to their specific record in Firestore
    FirebaseFirestore.instance
        .collection('studentsWest')
        .doc(code)
        .collection('testing')
        .add(dataToSave);
  }
}

