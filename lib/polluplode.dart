import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'local_notifications.dart';

class polluplode extends StatefulWidget {
  final currentUser = FirebaseAuth.instance;

  @override
  _polluplode createState() => _polluplode();
}

class _polluplode extends State<polluplode> {
  String? selectedDropdown1;
  String? selectedDropdown2;
  String? selectedDropdown3;
  String? selectedDropdown4;

  void _handleNotificationButtonClick() {
    // Get the current time
    DateTime now = DateTime.now();

    // Check if the current time is within the specified time ranges (9 to 10 am or 7 to 8 pm)
    bool isWithinMorningRange =
        now.hour >= 9 && now.hour < 10 && now.minute >= 0 && now.minute < 60;
    bool isWithinEveningRange =
        now.hour >= 19 && now.hour < 20 && now.minute >= 0 && now.minute < 60;

    if (isWithinMorningRange || isWithinEveningRange) {
      // Cancel the periodic notifications for the current day
      LocalNotifications.cancel(1);
    } else {
      // Add logic for handling notifications outside the specified time ranges
    }
  }

  Widget buildDropdown(List<String> dropdownData, {
    String? selectedValue,
    required ValueChanged<String?> onChanged,
    required String hint,
  }) {
    selectedValue ??= dropdownData.isNotEmpty ? dropdownData[0] : null;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color.fromARGB( 255, 0, 77, 87),),
        color: Color.fromARGB( 64, 0, 77, 87),
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        onChanged: onChanged,
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text(
              hint,
              style: TextStyle(color: Color.fromARGB( 255, 0, 77, 87), fontSize: 16),
            ),
          ),
          ...dropdownData.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Color.fromARGB( 255, 0, 77, 87),),
                ),
              ),
            );
          }).toList(),
        ],
        style: TextStyle(
          fontSize: 16,
          color: Color.fromARGB( 255, 0, 77, 87),
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          color: Color.fromARGB( 255, 0, 77, 87),
        ),
        underline: Container(),
        isExpanded: true,
      ),
    );
  }

  Future<void> storeSelectedValues(DocumentReference userRef,
      String? dropdown1,
      String? dropdown2,
      String? dropdown3,
      String? dropdown4,) async {
    try {
      var myDataCollection = FirebaseFirestore.instance.collection('messvala').doc('messfooddetails').collection('messfoods');
      var uid=widget.currentUser.currentUser!.uid;

      await myDataCollection.doc(uid).set({
        'bhaji1': dropdown1,
        'bhaji2': dropdown2,
        'bhajioli1': dropdown3,
        'bhajioli2': dropdown4,
        'sukhibhaji1count': 0,
        'sukhibhaji2count': 0,
        'olibhaji1count': 0,
        'olibhaji2count': 0,
        'visit': 0,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Selected values stored successfully');
    } catch (e) {
      print('Error storing selected values: $e');
    }
  }

  Future<void> showConfirmationDialog(BuildContext context,
      String? dropdown1,
      String? dropdown2,
      String? dropdown3,
      String? dropdown4,
      DocumentReference userRef,) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:Colors.white,
          title: Text('Are you sure to Confirm ?',
            style: TextStyle(
              color: Color.fromARGB( 255, 0, 77, 87),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(

            child: ListBody(

              children: <Widget>[
                Text('Selected Oli Bhaji 1: $dropdown1',
                  style: TextStyle(
                    color: Color.fromARGB( 255, 0, 77, 87),
                    fontSize: 18,
                  ),
                ),
                Text('Selected Oli Bhaji 2: $dropdown2',
                  style: TextStyle(
                    color: Color.fromARGB( 255, 0, 77, 87),
                    fontSize: 18,
                  ),
                ),
                Text('Selected Sukhi Bhaji 1: $dropdown3',
                  style: TextStyle(
                    color: Color.fromARGB( 255, 0, 77, 87),
                    fontSize: 18,
                  ),
                ),
                Text('Selected Sukhi Bhaji 1: $dropdown4',
                  style: TextStyle(
                    color: Color.fromARGB( 255, 0, 77, 87),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                style: TextStyle(
                  color: Color.fromARGB( 255, 0, 77, 87),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                setState(() {
                  selectedDropdown1 = null;
                  selectedDropdown2 = null;
                  selectedDropdown3 = null;
                  selectedDropdown4 = null;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm',
                style: TextStyle(
                  color: Color.fromARGB( 255, 0, 77, 87),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                _handleNotificationButtonClick();
                Navigator.of(context).pop();
                await storeSelectedValues(
                  userRef,
                  dropdown1,
                  dropdown2,
                  dropdown3,
                  dropdown4,
                );
                setState(() {
                  selectedDropdown1 = null;
                  selectedDropdown2 = null;
                  selectedDropdown3 = null;
                  selectedDropdown4 = null;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("messvala")
            .where("uid", isEqualTo: widget.currentUser.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            var data = snapshot.data!.docs[0];
            List<String> dropdown1Data = List.from(data['dropdown1'] ?? []);
            List<String> dropdown2Data = List.from(data['dropdown1'] ?? []);
            List<String> dropdown3Data = List.from(data['dropdown2'] ?? []);
            List<String> dropdown4Data = List.from(data['dropdown2'] ?? []);

            return Stack(
              children: [

                Positioned(
                  width: 53, // Adjust width as needed
                  height: 53, // Adjust height as needed
                  top: 66,
                  left: 36,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB( 255, 0, 77, 87),
                      elevation: 0,
                      shadowColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Adjust border radius for a circular shape
                      ),
                    ),
                    onPressed: () {

                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Icon(Icons.arrow_back_ios_outlined, color:  Colors.white),
                    ),
                  ),
                ),

                Positioned(
                  width: 185,
                  height: 182,
                  top: -46,
                  left: 292,
                  child: Transform.rotate(
                    angle: 0.0, // 45 degrees in radians
                    child: Container(
                      width:
                      MediaQuery.of(context).size.width / 2, // Half width
                      height: 100, // Adjust height as needed
                      child: Image.asset(
                        'assets/CornerImage.png', // Replace with your image asset path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  width: 41.74,
                  height: 47.5,
                  top: 7.93,
                  left: 90,
                  child: Transform.rotate(
                    angle: 10.95, // 45 degrees in radians
                    child: Container(
                      width:
                      MediaQuery.of(context).size.width / 2, // Half width
                      height: 100, // Adjust height as needed
                      child: Image.asset(
                        'assets/leaf.png', // Replace with your image asset path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),



                Positioned(
                  width: 90,
                  height: 102,
                  top: 225,
                  left: -25,
                  child: Container(
                    child: Image.asset(
                      'assets/Group25.png', // Replace with your image asset path
                    ),
                  ),
                ),
                Positioned(
                  width: 104,
                  height: 106,
                  top: 530,
                  left: 329,
                  child: Container(
                    child: Image.asset(
                      'assets/rightRound.png', // Replace with your image asset path
                    ),
                  ),
                ),

                Positioned(
                  width: 91.48,
                  height: 100.24,
                  top: 300.8,
                  left: 329,
                  child: Container(
                    child: Image.asset(
                      'assets/leafFull.png', // Replace with your image asset path

                    ),
                  ),
                ),
                Padding(
              padding: const EdgeInsets.only(left: 38.0 , right: 38),

              child: ListView(
                padding: EdgeInsets.all(16),
                children: [

                  SizedBox(height: 140),
                  // Text(
                  //   data['name'],
                  //   style: TextStyle(
                  //     color: Color.fromARGB( 255, 0, 77, 87),
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  // Text(
                  //   data['mess_name'],
                  //   style: TextStyle(
                  //     color: Color.fromARGB( 255, 0, 77, 87),
                  //     fontSize: 18,
                  //   ),
                  // ),
                  //SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      "Up-DatePoll : Oli Bhaji",
                      style: TextStyle(
                        color: Color.fromARGB( 255, 0, 77, 87),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Text('OLI BHAJI 1:',
                    style: TextStyle(
                      color: Color.fromARGB( 255, 0, 77, 87),
                      fontSize: 18,
                    ),
                  ),
                  buildDropdown(
                    dropdown1Data,
                    selectedValue: selectedDropdown1,
                    onChanged: (newValue) {
                      setState(() {
                        selectedDropdown1 = newValue;
                      });
                    },
                    hint: 'Select Oli Bhaji 1 ',
                  ),
                  Text('OLI BHaji2:',
                    style: TextStyle(
                      color: Color.fromARGB( 255, 0, 77, 87),
                      fontSize: 18,
                    ),
                  ),
                  buildDropdown(
                    dropdown1Data,
                    selectedValue: selectedDropdown2,
                    onChanged: (newValue) {
                      setState(() {
                        selectedDropdown2 = newValue;
                      });
                    },
                    hint: 'Select Oli Bhaji 2',
                  ),
                  SizedBox(height: 35),

                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      "Up-DatePoll : Sukhi Bhaji",
                      style: TextStyle(
                        color: Color.fromARGB( 255, 0, 77, 87),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text('Sukhi Bhaji 1:',
                    style: TextStyle(
                      color: Color.fromARGB( 255, 0, 77, 87),
                      fontSize: 18,
                    ),
                  ),
                  buildDropdown(
                    dropdown3Data,
                    selectedValue: selectedDropdown3,
                    onChanged: (newValue) {
                      setState(() {
                        selectedDropdown3 = newValue;
                      });
                    },
                    hint: 'Select Sukhi Bhaji 1',
                  ),
                  Text('Sukhi Bhaji 2 :',
                    style: TextStyle(
                      color: Color.fromARGB( 255, 0, 77, 87),
                      fontSize: 18,
                    ),
                  ),
                  buildDropdown(
                    dropdown4Data,
                    selectedValue: selectedDropdown4,
                    onChanged: (newValue) {
                      setState(() {
                        selectedDropdown4 = newValue;
                      });
                    },
                    hint: 'Select Sukhi Bhaji 2 ',
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        showConfirmationDialog(
                          context,
                          selectedDropdown1,
                          selectedDropdown2,
                          selectedDropdown3,
                          selectedDropdown4,
                          data.reference,
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB( 255, 0, 77, 87),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0), // Adjust the radius for rounded corners
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(150, 40), // Adjust width and height as needed
                        ),
                      ),
                      child: Text("Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
              ],
            );
          }
        },
      ),
    );
  }
}
