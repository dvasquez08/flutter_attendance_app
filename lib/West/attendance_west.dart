// Imports of other pages for the West location and to the main page
import 'package:attendance/West/ready_testing_west.dart';
import 'package:attendance/West/testing_west.dart';
import 'package:attendance/location_selection.dart';
// Firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Package imports such as Google fonts and the barcode scanner package
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// Importing reusable code from the components dart file
import '../components.dart';

// Initializing Firebase. This function is async because Firebase initialization must be completed before the app runs
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MaterialApp(debugShowCheckedModeBanner: false, home: attendanceWest()));
}

// A StatefulWidget that manages the attendance check-in process for the Terwilliger location.
class attendanceWest extends StatefulWidget {
  const attendanceWest({Key? key}) : super(key: key);

  @override
  State<attendanceWest> createState() => _attendanceWestState();
}

class _attendanceWestState extends State<attendanceWest> {
  
  // State variables to hold the timestamp, the result of the barcode scan, and the student's code.
  String timestamp = " ";
  String scanResult = " ";
  String code = " ";
  String todayDate = " ";

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
        title: Text("Taegeuk Taekwondo Attendance West",
            style: GoogleFonts.openSans(fontWeight: FontWeight.w300)),
        centerTitle: true,
      ),

      // Main content of the screen, also sets the background image
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/class9.png"),
            fit: BoxFit.cover,
          ),
        ),

        // Column arranges the content in a vertical array.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // Welcome section that contains the logo and directs the user to scan their barcode
          children: [
            Image.asset("assets/new-logo.png"),
            SizedBox(height: 15.0),
            SansText("Welcome to Taegeuk Taekwondo!", 50.0),
            SizedBox(height: 15.0),
            SansText("Please scan your ID card to check-in:", 25.0),
            SizedBox(height: 15.0),

            // Pulling the ScanButton component from the components file. This takes
            // The Gesture detector used in the North pages and condenses it to just
            // this single line here.
            ScanButton(),
            SizedBox(height: 15.0),
            // What will appear when scanning the barcode
            Text(
              scanResult == null ? "Scan a code!" : "Thank you",
              style: TextStyle(fontSize: 25.0, color: Colors.white),
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
                child: SansText('Menu', 30.0)),
            Column(
              // Same navigation layout as the north location. This is using
              // the button widget that I created to make the code look cleaner
              // and more readable. All widgets made are found in components.dart
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NavButton("Ready for Testing", readyTestWest()), // The page to add students to the list that are ready for testing
                SizedBox(height: 15.0),
                NavButton("Testing Check-in", testingWest()), // To the attendance page for testing day
                SizedBox(height: 15.0),
                NavButton("Select Another Location", location_selection()) // Takes user to app's main location selector page
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
        "#ff6677", // Sets the color of the line across the scanner
        "Cancel", // Adds the cancel button
        true, // Boolean value to enable the flash
        ScanMode.BARCODE, // Set  to Barcode mode, other option is QR mode for QR scanner,
      );
    } on PlatformException {
      scanResult = "Failed to get platform version.";
    }
    // A check to ensure the widget is still in the widget tree before updating state.
    // This prevents errors if the user navigates away while scanning is in progress.
    if (!mounted) return; 

    setState(() => this.scanResult = scanResult); // Update the state with the result of the scan

    // Telling the app what data to save which is the timestamp and prepare it for Firestore
    Map<String, dynamic> dataToSend = {'timestamp': DateTime.now()};
    Map<String, dynamic> dataToSave = {'date': DateTime.now(), 'code': code};

    code = scanResult; // Assign the scanned result to the 'code' variable.

    // Send the attendance timestamp to the student's own specific record in Firestore
    FirebaseFirestore.instance
        .collection('studentsWest')
        .doc(code)
        .collection('Attendance')
        .add(dataToSend);

    // Save the timestamp to a different list, showing all the student's timestamp 
    // together for that day
    FirebaseFirestore.instance
        .collection('studentsWest')
        .doc('all')
        .collection('attended')
        .add(dataToSave);
  }
}

