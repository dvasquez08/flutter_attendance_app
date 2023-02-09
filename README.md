# Attendance

## Attendance app for Taegeuk Taekwondo

This app is used for tracking the attendance of students at a Taekwondo school. Students will enter the school and scan their ID cards using an Android
device and its camera. The student will tap the button to scan which activates the camera of the device, then reads that barcode. Once the barcode is 
scanned, the app then sends the timestamp and the code to a database using Firestore. The Students and their codes are in a data collection in Firestore
and the timestamps of each student is tracked. This process is much more time efficient than the old system of physically writing the names down for attenance
as it prevents human error or disagreements on who attended on a certain day. The number of times a student attneded in a month is easily tracked and provides
accurate data which will avoid problems, saving time for the business. 

## Screenshots

Below are some screenshots of the app in action:

First, A selection is selected. Each location has its own barcode scanner function that sends the data to each location's respective collection in Firestore.
That way, the student list and their data is organized by location.

![Screenshot_20221220_093011](https://user-images.githubusercontent.com/99619761/217783891-d917a1fd-87e8-46f9-af02-6306bc89eaa1.jpg)

After the selection is selected, the user is presented with the screen where they need to press a button to scan their card. This is the screen for the 
page while the device in idling and the app isn't being used. 

![Screenshot_20221220_093030](https://user-images.githubusercontent.com/99619761/217783873-e108e7f0-a691-417c-b24b-de4f0683bd5d.jpg)

When the button on the previous screen is tapped, the camera is activated and then the user can scan their card in front of the camera which
reads their data and then sends it to Firestore. 

![Screenshot_20221220_093103](https://user-images.githubusercontent.com/99619761/217783878-cfbe2948-c916-43e8-b511-2e3945c2b67e.jpg)
