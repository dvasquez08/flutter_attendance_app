// Imports for other West location pages
import 'package:attendance/West/attendance_west.dart';
import 'package:attendance/West/testing_west.dart';
// Firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// Package imports which are Google fonts and the barcode scanner package
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// Importing reusable code from the components file
import '../components.dart';

// Initializing Firebase. This function is async because Firebase initialization must be completed before the app runs
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: readyTestWest()));
}

// This stateful widget manages the check-in process for students who are ready for testing at the West location.
class readyTestWest extends StatefulWidget {
  const readyTestWest({Key? key}) : super(key: key);

  @override
  State<readyTestWest> createState() => _readyTestWestState();
}

class _readyTestWestState extends State<readyTestWest> {
  // State variables that show confirmation that the student is ready for testing and tracks their info.
  String scanResult = " ";
  String code = " "; // Barcode scan result
  String readyTest = "Ready for Testing";
  String info = "info";

  @override
  Widget build(BuildContext context) {
    // These variables capture the device's screen dimensions.
    // They are used here for adjusting the size of containers and adding responsiveness.
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      //App bar section that contains the screen title
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: Text("Student Ready for Testing West",
            style: GoogleFonts.openSans(fontWeight: FontWeight.w300)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),

      // Main content of the screen, also sets the background image
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/class5.png"), fit: BoxFit.cover),
        ),

        // Column arranges the content in a vertical array.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // Main screen header that contains the logo shows instructions to add student to ready list
          children: [
            Image.asset("assets/new-logo.png"),
            SizedBox(height: 15.0),
            SansText("Student Ready For Testing", 40.0),
            SizedBox(height: 15.0),
            SansText(
                "Scan student ID card to add them to list of students that are ready for testing",
                20.0),
            SizedBox(height: 15.0),
            ScanButton() // Condensed ScanButton function from the reusable code found in components.dart
          ],
        ),
      ),
      // Drawer for the slide-out menu for navigation.
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // The header for the drawer.
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: SansText("menu", 30.0),
            ),
            // This column holds the navigation buttons inside the drawer.
            Column(
              children: [
                NavButton("Testing Check-in", testingWest()), // Using the NavButton component, takes user to the attendance page for testing day
                SizedBox(height: 15.0),
                NavButton("Class Attendance", attendanceWest()) // Using the NavButton component, this takes the suer to the main attendance page for this location
              ],
            )
          ],
        ),
      ),
    );
  }

  // The function for the barcode scanner
  Future scanBarcode() async {
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6677", // Sets the color of the line across the scanner
        "Cancel", // Adds the cancel button
        true, // Boolean value to enable the flash
        ScanMode.BARCODE, // Set  to Barcode mode, other option is QR mode for QR scanner
      );
    } on PlatformException {
      scanResult = "Failed to get platform version."; // Error handling
    }
    // A check to ensure the widget is still in the widget tree before updating state.
    // This prevents errors if the user navigates away while scanning is in progress.
    if (!mounted) return;

    setState(() => this.scanResult = scanResult); // Update the state with the result of the scan

    // Telling the app what data to save which is the student that is ready for testing and prepare it for Firestore
    Map<String, String> dataToSave = {
      'Status': readyTest,
    };

    code = scanResult; // Assign the scanned result to the 'code' variable.
    
    // Saves the student info to the collection and document for the North, the sub-collection
    // For testing day, indicating that the student is ready
    FirebaseFirestore.instance
        .collection('testing')
        .doc('west')
        .collection('TestDay')
        .doc(code)
        .collection('info')
        .add(dataToSave);
  }
}

