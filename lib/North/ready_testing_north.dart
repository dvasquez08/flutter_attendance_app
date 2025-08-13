// Imports for other North location pages
import 'package:attendance/North/attendance_north.dart';
import 'package:attendance/North/testing_north.dart';
// Firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// Other Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// Package imports
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// Importing the reusable code from components
import '../components.dart';

// Initializing Firebase. This function is async because Firebase initialization must be completed before the app runs
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MaterialApp(debugShowCheckedModeBanner: false, home: readyTestNorth()));
}

// This stateful widget manages the check-in process for students who are ready for testing at the North location.
class readyTestNorth extends StatefulWidget {
  const readyTestNorth({Key? key}) : super(key: key);

  @override
  State<readyTestNorth> createState() => _readyTestNorthState();
}

class _readyTestNorthState extends State<readyTestNorth> {
  // State variables that show confirmation that the student is ready for testing and tracks their info
  String scanResult = " ";
  String code = " ";
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
        title: Text("Student Ready for Testing North",
            style: GoogleFonts.openSans(fontWeight: FontWeight.w300)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      // Main content of the screen, also sets the background image
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/class4.png"), fit: BoxFit.cover),
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

            // Section for the button to press for scanning
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
            // end of button section
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

                // Senders user to the 'Testing Check-in' page
                // This will add the student to the attendance list for testing day
                MaterialButton(
                  shape: Border.all(color: Colors.black),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => testingNorth(),
                      ),
                    );
                  },
                  child: const Text(
                    "Testing Check-in",
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                ),
                SizedBox(height: 15.0),

                // Routest the user back to the main page for the North school
                // Which is the main class attendance page
                MaterialButton(
                  shape: Border.all(color: Colors.black),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AttendanceNorth(),
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
        .doc('north')
        .collection('TestDay')
        .doc(code)
        .collection('info')
        .add(dataToSave);
  }
}



