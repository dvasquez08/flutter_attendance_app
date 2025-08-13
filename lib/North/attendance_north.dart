// Import to go back to Location selection import when needed to choose a different school
import 'package:attendance/location_selection.dart';
// Imports for testing pages for this specific location
// One is to track which students are ready for testing, the other for who attended testing day
import 'package:attendance/North/testing_north.dart';
import 'package:attendance/North/ready_testing_north.dart';
// Firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Other packages imports
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// Importing the re-usable code from the components file
import '../components.dart';

// Initializing Firebase. This function is async because Firebase initialization must be completed before the app runs
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MaterialApp(debugShowCheckedModeBanner: false, home: AttendanceNorth()));
}

// A StatefulWidget that manages the attendance check-in process for the North location.
class AttendanceNorth extends StatefulWidget {
  const AttendanceNorth({Key? key}) : super(key: key);

  @override
  State<AttendanceNorth> createState() => _AttendanceNorthState();
}

// The state class for the AttendanceNorth widget. It holds the mutable state
// and the logic for barcode scanning and data submission.
class _AttendanceNorthState extends State<AttendanceNorth> {

  // State variables to hold the timestamp, the result of the barcode scan, and the student's code.
  String timestamp = " ";
  String scanResult = " ";
  String code = " ";

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
        title: Text("Taegeuk Taekwondo Attendance North",
            style: GoogleFonts.openSans(fontWeight: FontWeight.w300)),
        centerTitle: true,
      ),

      // Main content of the screen, also sets the background image
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/class3.png"),
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

            // Section for the button to press for scanning
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
            // This column holds the navigation buttons inside the drawer.
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Senders user to the 'Ready for Testing' page
                // This puts the students in the list of students who are ready for testing today
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
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                ),
                SizedBox(height: 15.0),

                // Sends the user to the 'Testing Check-in' page.
                // This track the students who attended testing day
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
                
                // This sends the user back to the home page which is the location selector
                MaterialButton(
                  shape: Border.all(color: Colors.black),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => location_selection(),
                      ),
                    );
                  },
                  child: const Text(
                    "Select Another Location",
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                ),
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
        ScanMode.BARCODE, // Set  to Barcode mode, other option is QR mode for QR scanner
      );
    } on PlatformException {
      scanResult = "Failed to get platform version."; // Error handling
    }
    if (!mounted) return;

    setState(() => this.scanResult = scanResult); // Update the state with the result of the scan

    // Telling the app what data to save which is the timestamp and prepare it for Firestore
    Map<String, dynamic> dataToSend = {'timestamp': DateTime.now()};
    Map<String, dynamic> dataToSave = {'date': DateTime.now(), 'code': code};

    code = scanResult; // Assign the scanned result to the 'code' variable.

    // Send the attendance timestamp to the student's own specific record in Firestore
    FirebaseFirestore.instance
        .collection('studentsNorth')
        .doc(code)
        .collection('Attendance')
        .add(dataToSend);

    // Save the timestamp to a different list, showing all the student's timestamp 
    // together for that day
    FirebaseFirestore.instance
        .collection('studentsNorth')
        .doc('all')
        .collection('attended')
        .add(dataToSave);
  }
}





