import 'package:aashray_veriion3/polluplode.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'local_notifications.dart';

class PollUpdate extends StatefulWidget {
  @override
  _PollUpdateState createState() => _PollUpdateState();
}

class _PollUpdateState extends State<PollUpdate> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;
  String? selectedDropdown1;
  String? selectedDropdown2;
  String? selectedDropdown3;
  String? selectedDropdown4;
  var uid1 = '';
  TextEditingController _textFieldController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    User? user = _auth.currentUser;
    setState(() {
      currentUser = user;
    });
  }

  //build dropdown here

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
              style: TextStyle(color:Color.fromARGB( 255, 0, 77, 87), fontSize: 16),
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

  //store values
  Future<void> storeSelectedValues(String? dropdown1, String? dropdown2, String? dropdown3,
      String? dropdown4, String? textFieldValue) async {
    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection("messvala")
          .where("uid", isEqualTo: currentUser?.uid)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs[0];
        var address = userData['address'];
        var location = userData['location'];
        var messon = userData['messon'];
        var profileImageUrl = userData['profileImageUrl'];
        var messnm = userData['mess_name'];
        var rcnm = userData['rcnm'];
        var upid = userData['upid'];
        var vegNonveg = userData['vegNonveg'];
        var uid = userData['uid'];
        uid1 = uid;

        var myDataCollection = FirebaseFirestore.instance.collection("messvala").doc('messfooddetails').collection('messfoods');

        await myDataCollection.doc(uid).set({
          'SukhiBhajifinal': dropdown1,
          'Olibhajifinal': dropdown2,
          'rice': dropdown3,
          'price': dropdown4,
          'textFieldValue': textFieldValue,
          'timestamp': FieldValue.serverTimestamp(),
          'address': address,
          'location': location,
          'messon': messon,
          'rcnm': rcnm,
          'profileImageUrl': profileImageUrl,
          'upid': upid,
          'vegNonveg': vegNonveg,
          'uid': uid,
          'mess_name': messnm,
        });

        var myDataCollection2 = FirebaseFirestore.instance.collection("messvala").doc('messlist').collection('messlistcol');
        var existingDocument = await myDataCollection2.doc(uid).get();

        if (existingDocument.exists) {
          print('Document exists before update: true');
          await myDataCollection2.doc(uid).update({
            'special': textFieldValue,
          });
        } else {
          print('Document does not exist before update');
        }

        print('Selected values stored successfully');
      } else {
        print('User data not found');
      }
    } catch (e) {
      print('Error storing selected values: $e');
    }
  }

  //values confirmation
  Future<void> showConfirmationDialog(BuildContext context, String? dropdown1, String? dropdown2,
      String? dropdown3, String? dropdown4, String? textFieldValue, DocumentReference userRef) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:Color(0xffffffff) ,
          title: Text('Are you sure to Confirm?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB( 255, 0, 77, 87),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('oli Bhaji : $dropdown1' ,
                  style: TextStyle(
                    fontSize: 18,

                    color: Color.fromARGB( 255, 0, 77, 87),
                  ),
                ),
                Text('Sukhi Bhaji : $dropdown2',
                  style: TextStyle(
                    fontSize: 18,

                    color: Color.fromARGB( 255, 0, 77, 87),
                  ),
                ),
                Text('Rice: $dropdown3',
                  style: TextStyle(
                    fontSize: 18,

                    color: Color.fromARGB( 255, 0, 77, 87),
                  ),
                ),
                Text('Price : $dropdown4',
                  style: TextStyle(
                    fontSize: 18,

                    color: Color.fromARGB( 255, 0, 77, 87),
                  ),
                ),
                Text('Extra Info: $textFieldValue',
                  style: TextStyle(
                    fontSize: 18,

                    color: Color.fromARGB( 255, 0, 77, 87),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB( 255, 0, 77, 87),
                ),
              ),
              onPressed: () {
                setState(() {
                  selectedDropdown1 = null;
                  selectedDropdown2 = null;
                  selectedDropdown3 = null;
                  selectedDropdown4 = null;
                  _textFieldController.clear();
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB( 255, 0, 77, 87),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await storeSelectedValues(
                  dropdown1,
                  dropdown2,
                  dropdown3,
                  dropdown4,
                  _textFieldController.text,
                );
                setState(() {
                  selectedDropdown1 = null;
                  selectedDropdown2 = null;
                  selectedDropdown3 = null;
                  selectedDropdown4 = null;
                  _textFieldController.clear();
                });
                _handleNotificationButtonClick();
              },
            ),
          ],
        );
      },
    );
  }


  //confirmation default
  Future<void> showConfirmationDialog2(BuildContext context, String? dropdown1) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:Colors.white,
          title: Text('Please fill all the fields !!',
            style: TextStyle(
              color: Color.fromARGB( 255, 0, 77, 87),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please select all the fields',
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
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                setState(() {

                });
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }

  void _handleNotificationButtonClick() {
    DateTime now = DateTime.now();
    bool isWithinMorningRange = now.hour >= 9 && now.hour < 10 && now.minute >= 0 && now.minute < 60;
    bool isWithinEveningRange = now.hour >= 19 && now.hour < 20 && now.minute >= 0 && now.minute < 60;

    if (isWithinMorningRange || isWithinEveningRange) {
      LocalNotifications.cancel(1);
    } else {
      _scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Data updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: StreamBuilder(

        stream: FirebaseFirestore.instance
            .collection("messvala")
            .where("uid", isEqualTo: currentUser?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            var data2 = snapshot.data!.docs[0];
            print("Document data: ${data2.data()}");

            var data = snapshot.data!.docs[0];
            List<String> dropdown1Data = List.from(data['dropdown1'] ?? []);
            List<String> dropdown2Data = List.from(data['dropdown2'] ?? []);
            List<String> dropdown3Data = List.from(data['dropdown3'] ?? []);
            List<String> dropdown4Data = List.from(data['dropdown4'] ?? []);

            return Stack(
              children: [
                Positioned(

                  top: 710.8,
                  left: 325,
                  child: FloatingActionButton(
                    backgroundColor: Color.fromARGB( 255, 0, 77, 87),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => polluplode(),                          ),
                      );
                    },
                    child: Icon(
                      Icons.add,color: Colors.white,
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
                    padding: EdgeInsets.only( top: 4 , left: 15 , right: 15),
                    children: [

                      SizedBox(height: 87),
                      Text(
                        data['mess_name'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB( 255, 0, 77, 87),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Update Today's Menu",
                        style: TextStyle(
                          fontSize: 24,

                          color: Color.fromARGB( 255, 0, 77, 87),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Oli Bhaji:',

                        style: TextStyle(
                          fontSize: 18,

                          color: Color.fromARGB( 255, 0, 77, 87),
                        ),),
                      buildDropdown(
                        dropdown1Data,
                        selectedValue: selectedDropdown1,
                        onChanged: (newValue) {
                          setState(() {
                            selectedDropdown1 = newValue;
                          });
                        },
                        hint: 'Select Oli Bhaji',
                        //dropdownColor: Color.fromARGB(255, 255, 240, 220),
                      ),
                      Text('Sukhi Bhaji:',
                        style: TextStyle(
                          fontSize: 18,

                          color: Color.fromARGB( 255, 0, 77, 87),
                        ),),
                      buildDropdown(
                        dropdown2Data,
                        selectedValue: selectedDropdown2,
                        onChanged: (newValue) {
                          setState(() {
                            selectedDropdown2 = newValue;
                          });
                        },
                        hint: 'Select Sukhi Bhaji',
                        //dropdownColor: Color.fromARGB(255, 255, 240, 220),
                      ),
                      Text('RICE:',
                        style: TextStyle(
                          fontSize: 18,

                          color: Color.fromARGB( 255, 0, 77, 87),
                        ),),
                      buildDropdown(
                        dropdown3Data,
                        selectedValue: selectedDropdown3,
                        onChanged: (newValue) {
                          setState(() {
                            selectedDropdown3 = newValue;
                          });
                        },
                        hint: 'Select Rice Type',
                        //dropdownColor:Color.fromARGB(255, 255, 240, 220),
                      ),
                      Text('Price:',
                        style: TextStyle(
                          fontSize: 18,

                          color: Color.fromARGB( 255, 0, 77, 87),
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
                        hint: 'Select Price',
                        //dropdownColor: Color.fromARGB(255, 255, 240, 220),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _textFieldController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                          Color.fromARGB( 64, 0, 77, 87), // Background color
                          hintText: 'Extra Info ...',
                          hintStyle: TextStyle(
                              color:Color.fromARGB( 255, 0, 77, 87),
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Color.fromARGB( 255, 0, 77, 87), // Border color
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                              color: Color.fromARGB(
                                  255, 0, 93, 122), // Set the focused border color
                              width: 2, // Set the focused border width
                            ),
                          ),

                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          bool isSubscriptionExpired = false;

                          if (selectedDropdown1 == null || selectedDropdown2 == null || selectedDropdown3 == null || selectedDropdown4 == null) {

                            showConfirmationDialog2(
                              context,
                              "PLs fill all fields",
                            );

                          } else if (isSubscriptionExpired) {
                            // showsubscriptiondialog();
                          } else {
                            showConfirmationDialog(
                              context,
                              selectedDropdown1,
                              selectedDropdown2,
                              selectedDropdown3,
                              selectedDropdown4,
                              _textFieldController.text,
                              data.reference,
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB( 255, 0, 77, 87),
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Adjust the radius for rounded corners
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 40)),
                        ),

                        child: Text("Submit",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:Colors.white,
                          ),),

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
