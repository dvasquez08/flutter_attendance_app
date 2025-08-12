// Import necessary packages and files for the application.
// These include pages for different locations, Flutter's material design library,
// Google Fonts for custom text styles, and a custom components file.
import 'package:attendance/North/attendance_north.dart';
import 'package:attendance/Windermere/attendance_windermere.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Terwilliger/attendance_terwilliger.dart';
import 'West/attendance_west.dart';
import 'components.dart';

// The main entry point for the Flutter application.
void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false, home: location_selection())); // Setting the home screen of the app to be the location selector
}

class location_selection extends StatefulWidget {
  const location_selection({Key? key}) : super(key: key);

  @override
  State<location_selection> createState() => _location_selectionState();
}

class _location_selectionState extends State<location_selection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // The title section of the app. The background color of the app bar is transparent with black26.
      // Text is customized with Google Fonts
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Text("Taeguek Taekwondo Attendance",
            style: GoogleFonts.openSans(fontWeight: FontWeight.w300)),
        centerTitle: true,
      ),

      // The body of the scaffold contains the main content of the screen.
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/mats2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // The logos of the three Taekwondo organizations that the school represents
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset("assets/kukkiwon_logo.png"),
                Image.asset("assets/new-logo.png"),
                Image.asset("assets/wt_logo.png"),
              ],
            ),

            // The title of the screen and app
            // Text indicating to choose the location from here
            SizedBox(height: 15.0),
            SansText("Taeguek Taekwondo Attendance", 50.0),
            SizedBox(height: 15.0),
            SansText("Please select location below to begin", 25.0),
            SizedBox(height: 15.0),

            // Button section. The buttons are listed here in a row of the different locations
            // They are broken up into North, West, Terwillegar, and Windermere
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                // North school section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(40.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.indigo,
                        blurRadius: 12.0,
                        offset: Offset(4, 4),
                      )
                    ],
                  ),
                  child: MaterialButton(
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceNorth(), // Redirected to the attendance screen for the North location
                        ),
                      );
                    },
                    child: Text(
                      "North",
                      style: GoogleFonts.openSans(
                          fontSize: 30.0, fontWeight: FontWeight.w300),
                    ),
                  ),
                ),

                // West school section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(40.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.indigo,
                        blurRadius: 12.0,
                        offset: Offset(4, 4),
                      )
                    ],
                  ),
                  child: MaterialButton(
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => attendanceWest(), // Redirected to the attendance screen for the West location
                        ),
                      );
                    },
                    child: Text(
                      "West",
                      style: GoogleFonts.openSans(
                          fontSize: 30.0, fontWeight: FontWeight.w300),
                    ),
                  ),
                ),

                // Terwillegar school section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(40.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.indigo,
                        blurRadius: 12.0,
                        offset: Offset(4, 4),
                      )
                    ],
                  ),
                  child: MaterialButton(
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceTerwilliger(), // Redirected to the attendance screen for the Terwillegar location
                        ),
                      );
                    },
                    child: Text(
                      "Terwillegar",
                      style: GoogleFonts.openSans(
                          fontSize: 30.0, fontWeight: FontWeight.w300),
                    ),
                  ),
                ),

                // Windermere school section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(40.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.indigo,
                        blurRadius: 12.0,
                        offset: Offset(4, 4),
                      )
                    ],
                  ),
                  child: MaterialButton(
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => attendanceWindermere(), // Redirected to the attendance screen for the Windermere location
                        ),
                      );
                    },
                    child: Text(
                      "Windermere",
                      style: GoogleFonts.openSans(
                          fontSize: 30.0, fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

