import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormPage extends StatefulWidget {
  final String messTitle;
  final String uid1;
  final currentUser = FirebaseAuth.instance;

  FormPage({required this.messTitle,required this.uid1});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  String selectedBhajiOption = ''; // Store the selected option for Bhaji
  String selectedOliBhajiOption = ''; // Store the selected option for Oli Bhaji
  int bhaji1Count = 0; // Store the count for Option 1 (Bhaji)
  int bhaji2Count = 0; // Store the count for Option 2 (Bhaji)
  int oli1Count = 0; // Store the count for Option 1 (Oli Bhaji)
  int oli2Count = 0; // Store the count for Option 2 (Oli Bhaji)

  var bj1=null;
  var bj2=null;
  var olibj1=null;
  var olibj2=null;
  @override
  void initState() {
    super.initState();
    // Fetch the current counts from Firestore when the widget initializes
    print("uid is ");
    print(widget.uid1);
    //fetchFirebaseCounts();
  }

  Future<void> fetchFirebaseCounts() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('messvala')
          .doc('messfooddetails')
          .collection('messfoods')
          .doc(widget.uid1)
          .get();

      if (doc.exists) {
        setState(() {
          bhaji1Count = doc['sukhibhaji1count'] ?? 0;
          bhaji2Count = doc['sukhibhaji2count'] ?? 0;
          oli1Count = doc['olibhaji1count'] ?? 0;
          oli2Count = doc['olibhaji2count'] ?? 0;
        });
      } else {
        // Handle the case where the document does not exist
      }
    } catch (error) {

      print('Error fetching Firebase counts: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messvala')
            .doc('messfooddetails')
            .collection('messfoods')
            .doc(widget.uid1)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final bhaji1 = snapshot.data?.get('bhaji1') ?? 'Option 1 (Bhaji)';
          bj1=bhaji1;
          final bhaji2 = snapshot.data?.get('bhaji2') ?? 'Option 2 (Bhaji)';
          bj2=bhaji2Count;

          final oli1 = snapshot.data?.get('bhajioli1') ?? 'Option 1 (Olibhaji)';
          olibj1=oli1;

          final oli2 = snapshot.data?.get('bhajioli2') ?? 'Option 2 (Olibhaji)';
          olibj2=oli2;

          return Scaffold(
            body: Container(

              decoration: BoxDecoration(
                color: Color.fromARGB( 255, 0, 77, 87),
                border: Border.all(
                  color: Colors.black,
                  width: 0.0,
                ),
              ),
              child: Stack(
                children: [

                  Positioned(
                    width: 185,
                    height: 182,
                    top: -3,
                    left: 208,
                    child: Transform.rotate(
                      angle: 0.0, // 45 degrees in radians
                      child: Container(
                        width:
                        MediaQuery.of(context).size.width / 2, // Half width
                        height: 100, // Adjust height as needed
                        child: Image.asset(
                          'assets/CornerImg2.png', // Replace with your image asset path
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
                        'assets/leftRound.png', // Replace with your image asset path
                      ),
                    ),
                  ),
                  Positioned(
                    width: 104,
                    height: 156,
                    top: 530,
                    left: 329,
                    child: Container(
                      child: Image.asset(
                        'assets/rightRoundWhite.png', // Replace with your image asset path
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
                  Positioned(
                    width: 53, // Adjust width as needed
                    height: 53, // Adjust height as needed
                    top: 66,
                    left: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0), // Adjust border radius for a circular shape
                        ),
                      ),
                      onPressed: () {
                        // Handle button click
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Icon(Icons.arrow_back_ios_outlined, color:  Color.fromARGB(255, 0, 93, 122),),
                      ),
                    ),
                  ),


                  // Content centered horizontally
                  Positioned.fill(

                    child: Center(

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Container(
                            width: 300,
                            height: 65,

                            decoration: BoxDecoration(
                              color: Color.fromARGB( 64, 217, 217, 217),
                              borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                            ),

                            child: Center(
                              child: Text('Poll',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 32.0,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.0,
                                        color:  Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text('Sukhi Bhaji',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.0,
                              color:  Colors.white,
                            ),
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left: 58.0 , right: 38),
                            child: Column(
                              children: [
                                RadioListTile(
                                  title: Text(bhaji1 ,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  value: bhaji1,
                                  groupValue: selectedBhajiOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBhajiOption = value.toString();
                                    });
                                  },
                                  activeColor: Colors.white,
                                ),
                                RadioListTile(
                                  title: Text(bhaji2 ,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  value: bhaji2,
                                  groupValue: selectedBhajiOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBhajiOption = value.toString();
                                    });
                                  },
                                  activeColor:Colors.white,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20,),

                          Text(
                            "Oli Bhaji",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left: 58.0 , right: 38),
                            child: Column(
                              children: [
                                RadioListTile(
                                  title: Text(
                                    oli1,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color:  Colors.white,
                                    ),
                                  ),
                                  value: oli1,
                                  groupValue: selectedOliBhajiOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOliBhajiOption = value.toString();
                                    });
                                  },
                                  activeColor:  Colors.white, // Set the active color
                                ),
                                RadioListTile(
                                  title: Text(oli2 ,
                                    style: TextStyle(
                                      fontSize: 20,

                                      color:  Colors.white,
                                    ),
                                  ),
                                  value: oli2,
                                  groupValue: selectedOliBhajiOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOliBhajiOption = value.toString();
                                    });
                                  },
                                  activeColor:  Colors.white,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),


                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB( 255, 217, 217, 217),
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0), // Adjust the radius for rounded corners
                                ),
                              ),
                              minimumSize: MaterialStateProperty.all<Size>(
                                Size(300, 55), // Adjust width and height as needed
                              ),
                            ),
                            onPressed: () {
                              if (selectedBhajiOption.isNotEmpty || selectedOliBhajiOption.isNotEmpty) {
                                // An option for Bhaji or Oli Bhaji is selected
                                incrementCounts();
                              } else {
                                // Show a validation message if no option is selected
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please select an option for Bhaji or Oli Bhaji.'),
                                  ),
                                );
                              }
                            },
                            child: Text('Submit',
                              style: TextStyle(
                                fontSize: 25,
                                color: Color.fromARGB( 255, 0, 77, 87),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void incrementCounts() {
    if (selectedBhajiOption == bj1) {
      bhaji1Count += 1;
    } else  {
      bhaji2Count += 1;
    }

    if (selectedOliBhajiOption == olibj1) {
      oli1Count += 1;
    } else if (selectedOliBhajiOption == olibj2) {
      oli2Count += 1;
    }

    // Update Firebase counts when an option is selected
    updateFirebaseCounts(bhaji1Count, bhaji2Count, oli1Count, oli2Count);
  }

  void updateFirebaseCounts(int bhaji1Count, int bhaji2Count, int oli1Count, int oli2Count) {
    FirebaseFirestore.instance
        .collection('messvala')
        .doc('messfooddetails')
        .collection('messfoods')
        .doc(widget.uid1)
        .update({
      'sukhibhaji1count': bhaji1Count,
      'sukhibhaji2count': bhaji2Count,
      'olibhaji1count': oli1Count,
      'olibhaji2count': oli2Count,
    });
  }
}

void main() => runApp(MaterialApp(
  home: Scaffold(
    body: FormPage(messTitle: 'YourMessTitle',uid1: 'uidhere'), // Replace with your mess title
  ),
));
