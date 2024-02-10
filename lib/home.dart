import 'package:aashray_veriion3/loginmess.dart';
import 'package:aashray_veriion3/messprofile.dart';
import 'package:aashray_veriion3/poleupdate.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'UpiPaymentScreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _pageController = PageController();
  int _currentIndex = 0;
  final String phoneNumber = "8856887702";
  final messNameController = TextEditingController();
  final pollQuestionController = TextEditingController();
  final pollOption1Controller = TextEditingController();
  final pollOption2Controller = TextEditingController();
  String selectedBhajiOption = '';
  String messtitle = '';
  String selectedOliBhajiOption = '';
  var bhaji1 = '';
  var bhaji2 = '';
  var oli_bhaji1 = '';
  var oli_bhaji2 = '';
  int bhaji1Count = 0;
  int bhaji2Count = 0;
  int oli1Count = 0;
  int visit = 0;
  int oli2Count = 0;

  @override
  void initState() {
    super.initState();
    fetchFirebaseCounts();
    checkSubscription();
  }


  Future<void> checkSubscription() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userData = await fetchUserData(user.uid);

      if (userData != null && userData.containsKey('joindate')) {
        final joinDate = (userData['joindate'] as Timestamp).toDate();
        final currentDate = DateTime.now();
        final difference = currentDate.difference(joinDate).inDays;

        if (difference >= 30) {
          // User has been subscribed for 30 days or more, show the subscription popup
          showSubscriptionPopup();
        }
      }
    }
  }


  void makePayment(double price, String recnm, String upid) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UpiPaymentScreen(price: price, recnm: recnm, upid: upid),
      ),
    );
    print('Payment of $price is initiated.');
  }

  Future<void> _signOut() async {
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginMess(),
        ),
      );

      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
  _makePhoneCall(String phoneNumber) async {
    final String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Future<void> showSubscriptionPopup() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          // Returning false prevents the dialog from closing on back button press
          return false;
        },
        child: AlertDialog(
          title: Text('Subscription'),
          content: Text('Your subscription is over !! Make Payment for continueing the Access to Aahar Aplication. Choose an option:'),
          actions: [
            ElevatedButton(
            onPressed: () async {
              // Handle logout action
              //await FirebaseAuth.instance.signOut();
              _makePhoneCall(phoneNumber);
             // Navigator.pop(context); // Close the dialog
            },
            child: Text('Contact us'),
          ),
            ElevatedButton(
              onPressed: () {
                // Handle payment action
                var price = '300';
                var rcnnn = 'aashray';
                var upi = '8856887702@ybl';
                makePayment(double.parse(price), rcnnn, upi);
              },
              child: Text('Payment'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Handle logout action
                _signOut();

                //Navigator.pop(context); // Close the dialog
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }



  // backgroundColor: Color.fromARGB(255, 241, 224, 199),
  // appBar: AppBar(
  // backgroundColor: Color.fromARGB(255, 254, 171, 0),






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children:  <Widget>[
          PollUpdate(),
          _buildCard(),
          MessProfileScreen(),
        ],
      ),

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        buttonBackgroundColor: const Color.fromARGB( 255, 0, 77, 87),
        color: const Color.fromARGB( 255, 0, 77, 87),
        height: 65,
        items: const <Widget>[
          Icon(
            Icons.home,
            size: 35,
            color: Colors.white,
          ),
          Icon(
            Icons.graphic_eq,
            size: 35,
            color: Colors.white,
          ),
          Icon(
            Icons.person,
            size: 35,
            color: Colors.white,
          ),
          // Icon(
          //   Icons.person,
          //   size: 35,
          //   color: Colors.white,
          // ),


        ],
        onTap: (index) {
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut);
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Color.fromARGB(255, 246, 158, 40),
      //   currentIndex: _currentIndex,
      //     selectedItemColor: Color.fromARGB(255, 10, 10, 10),
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home ),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.graphic_eq),
      //       label: 'Impression',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      //   onTap: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //   },
      // ),
    );
  }

  Widget _buildBody() {

    switch (_currentIndex) {
      case 0:
        return PollUpdate();
      case 1:
        return _buildCard();
      case 2:
        return MessProfileScreen();
      default:
        return Container();
    }
  }

  Widget _buildCard() {
    return Stack(
      children: [
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
        Column(

      children: [
        FutureBuilder<double>(
          future: _calculateProgress("olibhaji", 'olibhaji1count', 'olibhaji2count'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: SizedBox(child: CircularProgressIndicator()));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return _buildVoteProgressBars(snapshot.data);
            }
          },
        ),
        SizedBox(height: 16.0),
      ],
    ),
      ],
    );
  }

  double calculateBhaji1Progress() {
    final totalVotes = bhaji1Count + bhaji2Count;
    if (totalVotes == 0) {
      return 0.0; // To avoid division by zero
    }
    return (bhaji1Count / totalVotes) * 100;
  }

  double calculateBhaji2Progress() {
    final totalVotes = bhaji1Count + bhaji2Count;
    if (totalVotes == 0) {
      return 0.0; // To avoid division by zero
    }
    return (bhaji2Count / totalVotes) * 100;
  }

  double calculateBhaji1Progressoli() {
    final totalVotes = oli1Count + oli2Count;
    if (totalVotes == 0) {
      return 0.0; // To avoid division by zero
    }
    return (oli1Count / totalVotes) * 100;
  }

  double calculateBhaji2Progressoli() {
    final totalVotes = oli1Count + oli2Count;
    if (totalVotes == 0) {
      return 0.0; // To avoid division by zero
    }
    return (oli2Count / totalVotes) * 100;
  }


  //here progress report shown
  Widget _buildVoteProgressBars(double? progress) {
    final bhaji1Progress = calculateBhaji1Progress();
    final bhaji2Progress = calculateBhaji2Progress();
    final bhaji1Progressoli = calculateBhaji1Progressoli();
    final bhaji2Progressoli = calculateBhaji2Progressoli();
    return Padding(
      padding: const EdgeInsets.all(48.0),

      child: Padding(
        padding: const EdgeInsets.only(top: 98.0),
        child: Card(
          color: Colors.white,
          elevation: 7,
          child: Padding(
            padding: EdgeInsets.all(35.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only( bottom: 8.0),
                  child: Text(
                    'Votes: ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:  Color.fromARGB( 255, 0, 77, 87),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '$bhaji1 Progress: ${bhaji1Progress.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 20,

                    color: Color.fromARGB( 255, 0, 77, 87),
                  ),
                ),
                SizedBox(height: 8.0),
                LinearProgressIndicator(
                  value: bhaji1Progress / 100,
                  minHeight: 10,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB( 255, 0, 77, 87),),
                ),
                SizedBox(height: 15.0),
                Text(
                  '$bhaji2 Progress: ${bhaji2Progress.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 20,

                    color:  Color.fromARGB( 255, 0, 77, 87),
                  ),
                ),
                SizedBox(height: 8.0),
                LinearProgressIndicator(
                  value: bhaji2Progress / 100,
                  minHeight: 10,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB( 255, 0, 77, 87),),
                ),
                SizedBox(height: 60.0),
                Text(
                  '$oli_bhaji1 Progress(votes): ${bhaji1Progressoli.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 20,

                    color:  Color.fromARGB( 255, 0, 77, 87),
                  ),
                ),
                SizedBox(height: 8.0),
                LinearProgressIndicator(
                  value: bhaji1Progressoli / 100,
                  minHeight: 10,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB( 255, 0, 77, 87),),
                ),
                SizedBox(height: 30.0),
                Text(
                  '$oli_bhaji2 Progress: ${bhaji2Progressoli.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 20,

                    color: Color.fromARGB( 255, 0, 77, 87),
                  ),
                ),
                SizedBox(height: 8.0),
                LinearProgressIndicator(
                  value: bhaji2Progressoli / 100,
                  minHeight: 10,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB( 255, 0, 77, 87),),
                ),
                SizedBox(height: 30.0),
                Text(
                  'Total Number of visits : ${visit}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,

                    color:Color.fromARGB( 255, 0, 77, 87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchFirebaseCounts() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final documentSnapshot3 = await FirebaseFirestore.instance.collection('messvala').doc(user.uid).get();

        if (documentSnapshot3.exists) {
          setState(() {
            messtitle = documentSnapshot3['mess_name'] ?? 'no name';
          });
        } else {
          // Handle the case where the document does not exist
        }
      }

      User? user2 = FirebaseAuth.instance.currentUser;
      if (user2 != null) {
        print("usid here at home is ");
        print(user2.uid);
        final doc = await FirebaseFirestore.instance
            .collection('messvala')
            .doc('messfooddetails')
            .collection('messfoods')
            .doc(user2.uid)
            .get();

        if (doc.exists) {
          setState(() {
            bhaji1Count = doc['sukhibhaji1count'] ?? 0;
            bhaji2Count = doc['sukhibhaji2count'] ?? 0;
            oli1Count = doc['olibhaji1count'] ?? 0;
            oli2Count = doc['olibhaji2count'] ?? 0;
            bhaji1 = doc['bhaji1'] ?? "bhaji 1 not found";
            bhaji2 = doc['bhaji2'] ?? "bhaji2 not found";
            oli_bhaji1 = doc['bhajioli1'] ?? "bhajioli1 not found";
            oli_bhaji2 = doc['bhajioli2'] ?? "bhajioli2 not found";
            visit = doc['visit'] ?? 0;
          });
        }
      } else {
        // Handle the case where the document does not exist
      }
    } catch (error) {
      // Handle the error (e.g., log it or show an error message)
      print('Error fetching Firebase counts: $error');
    }
  }

  Future<double> _calculateProgress(String category, String option1Field, String option2Field) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userData = await fetchUserData(user.uid);

      if (userData != null && userData.containsKey(category)) {
        final option1Count = userData[category][option1Field] ?? 0;
        final option2Count = userData[category][option2Field] ?? 0;

        if (option1Count + option2Count > 0) {
          return option1Count / (option1Count + option2Count);
        }
      }
    }

    return 0.0;
  }

  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    final documentSnapshot = await FirebaseFirestore.instance.collection('messvala').doc(uid).get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  void _submitData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userData = await fetchUserData(user.uid);

      if (userData != null) {
        CollectionReference collRef = FirebaseFirestore.instance.collection('polls').doc(user.uid).collection('userPolls');

        collRef.doc(user.uid).set({
          'question': pollQuestionController.text,
          'options': [
            {'answer': pollOption1Controller.text, 'percent': 0},
            {'answer': pollOption2Controller.text, 'percent': 0},
          ],
          'total_votes': 0,
        });

        pollQuestionController.clear();
        pollOption1Controller.clear();
        pollOption2Controller.clear();
      }
    }
  }
}
