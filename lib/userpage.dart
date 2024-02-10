import 'package:aashray_veriion3/UpiPaymentScreen.dart';
import 'package:aashray_veriion3/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:location/location.dart';

import 'FormPage.dart';
import 'LoginForm.dart';

enum SortOption { location, vegNonVeg, price }

class userpage extends StatefulWidget {
  const userpage({Key? key});

  @override
  State<userpage> createState() => _userpage();
}

class _userpage extends State<userpage> {
  int bhaji1Votes = 0;
  var visit = 0;
  var bhaji1;
  TextEditingController searchController = TextEditingController();
  String searchText = '';

  int bhaji2Votes = 0;
  bool hasVoted = false;
  SortOption _currentSortOption = SortOption.location;

  LocationData? userLocation;
  bool isVoting = false;
  String pollId = '';
  List<String> options = [];
  String selectedOption = '';

  late User _user;
  late String _userName = '';

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _fetchUserProfile();

    getUserLocation();
    // checkUserEnabledStatus();
    initializePoll();
  }

  Future<void> _fetchUserProfile() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          _userName = userSnapshot.get('name');
        });
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  Future<void> initializePoll() async {
    final pollDoc = await FirebaseFirestore.instance.collection('polls').add({
      'title': 'Bhaji Poll',
    });

    pollId = pollDoc.id;

    await pollDoc.collection('options').doc('bhaji1').set({'votes': 0});
    await pollDoc.collection('options').doc('bhaji2').set({'votes': 0});
  }

  Future<void> checkUserEnabledStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        bool isEnabled = userSnapshot.get('enable') ?? false;
        if (!isEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("User is disabled. You can't access this page."),
            ),
          );

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => LoginForm(),
            ),
            (route) => false,
          );
        }
      }
    }
  }

  List<DocumentSnapshot<Object?>>? item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 38.0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //ahar name and logout button
            Stack(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 150.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Image.network(
                      'https://s3-alpha-sig.figma.com/img/721f/2f03/a18ca223859328ec1a98b2448ef6e054?Expires=1707696000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=eIewpRBqM0Qxf-gwnFcb36xuGeAuHl3Owl3L5bIZK4Qx90FGrQSeFNcmWEXxoKVwVWjnYWxgVBSl2p3D3CDAQkHET~p~jqkMZOyFsYfgOffNJb0DkXDEj1yb6GP8435ckBqXjyiub5~QA29~5Lis7K~YYyHHVf50S0H7wiu9a3Sn1x-6kqVHJOI~p0yMPJfZPGg00toumdWOA2hcsTDd05xZwz--Yc-BdbOTpP-skW2TOkfEB7A-IOvt1C2h3BzfFy6MD99EjLqxY2HJiHgXRk2pRERDldlv-KOyxexCY5442ymX6vpLlDQnA3yn8kSIg0KFnpXfdtnb3QOZzzcaVA__', // Replace with your image URL
                      fit: BoxFit.cover,
                      height: 30,
                      width: 34, // Set the height as needed
                    ),
                  ),
                ),
                //   Positioned(
                //     top: 20, // Adjust the top position as needed
                //     left: 0, // Adjust the left position as needed
                //     child: Text(
                //       'Aahar ',
                //       textAlign: TextAlign.left,
                //       style: TextStyle(
                //         fontSize: 30,
                //         fontWeight: FontWeight.bold,
                //         color: Color.fromARGB(255, 171, 99, 0),
                //       ),
                //     ),
                //   ),
                //
                // //logout button
                //
                // IconButton(
                //   onPressed: () async {
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => LoginForm(),
                //       ),
                //     );
                //     await FirebaseAuth.instance.signOut();
                //   },
                //   icon: Icon(Icons.logout_sharp,
                //       color: Color.fromARGB(255, 171, 99, 0)),
                // )
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  _userName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 0, 93, 122),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Add a static search bar
            Container(
              width: 354,
              height: 54,
              alignment: Alignment.center,
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                style: TextStyle(color: Color.fromARGB(255, 0, 93, 122)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  hintText: 'Search Mess...',
                  hintStyle: TextStyle(color: Color.fromARGB(255, 0, 93, 122)),
                  prefixIcon: Icon(Icons.search,
                      color: Color.fromARGB(255, 0, 93, 122)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(
                      color: Color.fromARGB(
                          255, 0, 93, 122), // Set the border color
                      width: 1, // Set the border width
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(
                      color: Color.fromARGB(
                          255, 0, 93, 122), // Set the focused border color
                      width: 2, // Set the focused border width
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilterButton("All"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilterButton("Pure Veg"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilterButton("Non Veg"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilterButton("Lower Price"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilterButton("Higher Price"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilterButton("Rice Plate"),
                    ),
                    // Add more FilterButton widgets as needed
                  ],
                ),
              ),
            ),

            //cards are show
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('messvala')
                      .doc('messlist')
                      .collection('messlistcol')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 0, 93, 122),
                      ));
                    }

                    item = snapshot.data!.docs;

                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: item?.map((doc) {
                            var title = doc['name'];
                            var imageURL = doc['url'];
                            var imglogo = doc["messpic"];
                            var uid = doc["uid"];
                            var food = doc['food'];
                            var isVeg = doc['vegnonveg'] == 'Veg';
                            var isNonVeg = doc['vegnonveg'] == 'Nonveg';
                            var isVegNonVeg = doc['vegnonveg'] == 'Veg,Nonveg';
                            var special = doc['special'];
                            var messOn = doc['messon'] ?? false;

                            // visit=doc?['visit']?? 0;
                            //visit=visit+1;
                            //updateFirebaseCounts(visit,uid);

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemDetailsScreen(
                                      title: title,
                                      imageURL: imglogo,
                                      food: food,
                                      isVeg: isVeg,
                                      isNonVeg: isNonVeg,
                                      isVegNonVeg: isVegNonVeg,
                                      special: special,
                                      uid: uid,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 1.0),
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.4),
                                        spreadRadius: 0,
                                        blurRadius: 5,
                                        offset: Offset(0, 0),
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Stack(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              child: Container(
                                                decoration: BoxDecoration(),
                                                child: Image.network(
                                                  imageURL,
                                                  width: 138,
                                                  height: 125,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 16.0),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    title,
                                                    style: TextStyle(
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromARGB(
                                                          255, 0, 93, 122),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          if (isVeg)
                                                            Text(
                                                              'Veg',
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        77,
                                                                        87),
                                                              ),
                                                            ),
                                                          if (isNonVeg)
                                                            Text(
                                                              'Non Veg',
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        77,
                                                                        87),
                                                              ),
                                                            ),
                                                          if (isVegNonVeg)
                                                            Text(
                                                              'Veg - Non Veg',
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        77,
                                                                        87),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 12.0),
                                                  if (special != null &&
                                                      special.isNotEmpty)
                                                    Text(
                                                      'Special: $special',
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          bottom: 0.0,
                                          right: 0.0,
                                          child: Container(
                                            width: 112,
                                            height: 29,
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 0, 77, 87),
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Today Menu",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  WidgetSpan(
                                                    child: SizedBox(width: 9),
                                                  ),
                                                  WidgetSpan(
                                                    child: Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      size: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList() ??
                          [],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calculateDistance(double messLat, double messLon) {
    if (userLocation != null &&
        userLocation!.latitude != null &&
        userLocation!.longitude != null) {
      double userLat = userLocation!.latitude!;
      double userLon = userLocation!.longitude!;

      const double radius = 6371;
      double dLat = (messLat - userLat) * (math.pi / 180);
      double dLon = (messLon - userLon) * (math.pi / 180);
      double a = (math.sin(dLat / 2) * math.sin(dLat / 2)) +
          (math.cos(userLat * (math.pi / 180)) *
              math.cos(messLat * (math.pi / 180)) *
              math.sin(dLon / 2) *
              math.sin(dLon / 2));
      double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
      double distance = radius * c;

      return distance;
    } else {
      return double.maxFinite;
    }
  }

  void getUserLocation() async {
    Location location = Location();
    PermissionStatus status = await location.hasPermission();

    if (status == PermissionStatus.denied) {
      status = await location.requestPermission();
      if (status == PermissionStatus.granted) {
        LocationData position = await location.getLocation();
        setState(() {
          userLocation = position;
        });
      }
    } else if (status == PermissionStatus.granted) {
      LocationData position = await location.getLocation();
      setState(() {
        userLocation = position;
      });
    }
  }

  void updateFirebaseCounts(var count, var uid) {
    FirebaseFirestore.instance
        .collection('messvala')
        .doc('messlist')
        .collection('messlistcol')
        .doc(uid)
        .update({'visit': count});
  }
}

class ItemDetailsScreen extends StatelessWidget {
  final String title;
  final String uid;
  final String imageURL;
  final String food;
  final bool isVeg;
  final bool isNonVeg;
  final bool isVegNonVeg;
  final String? special;

  var visit = 0;

  ItemDetailsScreen({
    required this.title,
    required this.uid,
    required this.imageURL,
    required this.food,
    required this.isVeg,
    required this.isNonVeg,
    required this.isVegNonVeg,
    this.special,
  });
  var databro;
  Future<Map<String, dynamic>> fetchMessFoodDetails(String uid) async {
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('messvala')
        .doc('messfooddetails')
        .collection('messfoods')
        .doc(uid)
        .get();

    print("uid is bro  ");

    print(uid);
    print(documentSnapshot.get('Olibhajifinal'));
    databro = documentSnapshot;
    print(databro);
    // print("Fetched data: $documentSnapshot.data()");

    if (documentSnapshot.exists) {
      return {
        'address': documentSnapshot.get('address') ?? 'Address not found',
        'Olibhajifinal':
            documentSnapshot.get('Olibhajifinal') ?? 'Bhaji 1 not found',
        'SukhiBhajifinal':
            documentSnapshot.get('SukhiBhajifinal') ?? 'Bhaji 2 not found',
        'price': documentSnapshot.get('price') ?? 'price not found',
        'recnm': documentSnapshot.get('rcnm') ?? 'payment name not found',
        'upid': documentSnapshot.get('upid') ?? 'upi id not fund',
        'visit': documentSnapshot.get('visit') ?? 0,
      };
    } else {
      return {
        'address': 'Address not found',
        'Olibhajifinal': 'Bhaji 1 not found',
        'SukhiBhajifinal': 'Bhaji 2 not found',
        'price': 'price not found',
        'recnm': 'reciver nam enot found',
        'upid': 'upi id not found'
      };
    }
  }

  // void incrementCounts() {
  //   if (selectedBhajiOption == bj1) {
  //     bhaji1Count += 1;
  //   } else  {
  //     bhaji2Count += 1;
  //   }
  //
  //   if (selectedOliBhajiOption == olibj1) {
  //     oli1Count += 1;
  //   } else if (selectedOliBhajiOption == olibj2) {
  //     oli2Count += 1;
  //   }
  //
  //   // Update Firebase counts when an option is selected
  //   updateFirebaseCounts(bhaji1Count, bhaji2Count, oli1Count, oli2Count);
  // }

  @override
  Widget build(BuildContext context) {
    void _showFormPage() {}

    void makePayment(double price, String recnm, String upid) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              UpiPaymentScreen(price: price, recnm: recnm, upid: upid),
        ),
      );
      print('Payment of $price is initiated.');
    }

    print("uid at line 483");
    print(uid);

    print("passing the uid and title");
    print(title);
    print(uid);
    return Scaffold(
      // backgroundColor: Color(0xfffff0dc),
      // appBar: AppBar(
      //   backgroundColor: Color.fromARGB(255, 0, 93, 122),
      //   title: Text('Item Details'),
      // ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchMessFoodDetails(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // final data = snapshot.data;
          final data = databro;
          print("dataisbro");

          // print("Entire Data: $data");
          // print( data?['address'] );
          //
          // print("Entire Data: $data");
          // print( data?['address'] );
          print("data at the here checking at");
          print(data);
          final address = data?['address'] ?? 'Address not found';
          final bhaji1 = data?['Olibhajifinal'] ?? 'Bhaji 1 not found';
          final bhaji2 = data?['SukhiBhajifinal'] ?? 'Bhaji 2 not found';
          final price = data?['price'] ?? 'price not declared';
          final rcnnn = data?['rcnm'];
          final upi = data?['upid'];

          if (bhaji1 == "Bhaji 1 not found") {
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
                              width: 200,
                              height: 200,
                              child: Image.network(imageURL),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              "Pls Vote in the pole box by clicking on the follwing button",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18.0 , color: Colors.white),
                            ),
                            SizedBox(height: 20,),
                            FloatingActionButton(
                              backgroundColor: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FormPage(messTitle: title, uid1: uid),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.add, color:Color.fromARGB( 255, 0, 77, 87),
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
          }

          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 0.0,
              ),
            ),
            child: Stack(
              children: [
                // Left half - red color
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Container(
                    color: Color.fromARGB(255, 0, 93, 122),
                  ),
                ),
                // Right half - white color
                Positioned(
                  left: MediaQuery.of(context).size.width / 2,
                  top: 0,
                  bottom: 0,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Container(
                    color: Colors.white,
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


                // Content centered horizontally
                Positioned.fill(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 256.0,
                            height: 77.0,
                            padding: EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 4,
                                  color:
                                      Color(0x40000000), // #00000040 with alpha
                                ),
                                BoxShadow(
                                  offset: Offset(-4, -4),
                                  blurRadius: 4,
                                  color:
                                      Color(0x40000000), // #00000040 with alpha
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 25.0),
                                Image.asset(
                                  'assets/Pizza.png',
                                  width: 56.0, // Set the width of the image
                                  height: 53.0, // Set the height of the image
                                  // Add other properties as needed
                                ),
                                SizedBox(width: 28.0),
                                Text(
                                  bhaji1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 256.0,
                            height: 77.0,
                            padding: EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 4,
                                  color:
                                      Color(0x40000000), // #00000040 with alpha
                                ),
                                BoxShadow(
                                  offset: Offset(-4, -4),
                                  blurRadius: 4,
                                  color:
                                      Color(0x40000000), // #00000040 with alpha
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 25.0),
                                Image.asset(
                                  'assets/Bowl.png',
                                  width: 56.0, // Set the width of the image
                                  height: 53.0, // Set the height of the image
                                  // Add other properties as needed
                                ),
                                SizedBox(width: 28.0),
                                Text(
                                  bhaji2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 256.0,
                            height: 77.0,
                            padding: EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 4,
                                  color:
                                      Color(0x40000000), // #00000040 with alpha
                                ),
                                BoxShadow(
                                  offset: Offset(-4, -4),
                                  blurRadius: 4,
                                  color:
                                      Color(0x40000000), // #00000040 with alpha
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 25.0),
                                Image.asset(
                                  'assets/Chapati.png',
                                  width: 56.0, // Set the width of the image
                                  height: 53.0, // Set the height of the image
                                  // Add other properties as needed
                                ),
                                SizedBox(width: 28.0),
                                Text(
                                  "Chapati",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 256.0,
                            height: 77.0,
                            padding: EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 4,
                                  color:
                                      Color(0x40000000), // #00000040 with alpha
                                ),
                                BoxShadow(
                                  offset: Offset(-4, -4),
                                  blurRadius: 4,
                                  color:
                                      Color(0x40000000), // #00000040 with alpha
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 25.0),
                                Image.asset(
                                  'assets/Pizza.png',
                                  width: 56.0, // Set the width of the image
                                  height: 53.0, // Set the height of the image
                                  // Add other properties as needed
                                ),
                                SizedBox(width: 28.0),
                                Text(
                                  price,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 256.0,
                            height: 77.0,
                            padding: EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 4,
                                  color:
                                      Color(0x40000000), // #00000040 with alpha
                                ),
                                BoxShadow(
                                  offset: Offset(-4, -4),
                                  blurRadius: 4,
                                  color:
                                      Color(0x40000000), // #00000040 with alpha
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 25.0),
                                Image.asset(
                                  'assets/Pizza.png',
                                  width: 56.0, // Set the width of the image
                                  height: 53.0, // Set the height of the image
                                  // Add other properties as needed
                                ),
                                SizedBox(width: 28.0),
                                Text(
                                  address,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30,),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              // Left Button
                              Container(
                                width: 154.0,
                                height: 56, // Set the width of the Container
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.white,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {

                                  },
                                  child: Text(
                                    'Suggestion',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Color.fromARGB(255, 0, 93, 122),
                                    ),
                                  ),
                                ),
                              ),

                              Spacer(), // Add Spacer to push the next item to the right

                              // Right Button
                              Container(
                                width: 154.0,
                                height: 56,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 0, 93, 122),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return UpiPaymentScreen(
                                          price: double.parse(price),
                                          upid: upi,
                                          recnm: rcnnn,
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'Make Payment',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // FloatingActionButton(
                        //   onPressed: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => FormPage(messTitle: title,uid1:uid),
                        //       ),
                        //     );
                        //   },
                        //   child: Icon(
                        //     Icons.add,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: userpage(),
  ));
}

class FilterButton extends StatefulWidget {
  final String text;

  FilterButton(this.text);

  @override
  _FilterButtonState createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  bool isHovered = false;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: TextButton(
        onPressed: () {
          setState(() {
            isSelected = !isSelected;
          });
        },
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.blue.withOpacity(0.1);
              }
              return Colors.blue.withOpacity(0.1);
            },
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Color.fromARGB(255, 0, 93, 122); // Set the pressed color
              } else if (isSelected) {
                return Color.fromARGB(
                    255, 0, 93, 122); // Set the selected color
              } else if (isHovered) {
                return Colors.blue.withOpacity(0.1); // Set the hover color
              }
              return Colors.blue.withOpacity(0.1);
            },
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              side: BorderSide(
                color: Color.fromARGB(255, 0, 93, 122), // Set the border color
                width: isSelected ? 2.0 : 1.0, // Set the border width
              ),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
