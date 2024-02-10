import 'package:aashray_veriion3/loginmess.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfile> {


  late User _user;
  late String _userName = '';



  late String _email; // Initialize to an empty string

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _fetchUserProfile();
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
          _email = userSnapshot.get('email');
        });
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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


            // Content centered horizontally
            Positioned.fill(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Profile',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 32.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.0,
                        color:  Color.fromARGB( 255, 0, 77, 87),
                      ),
                    ),
                    SizedBox( height: 20,),
                    ClipOval(
                      child: Image.asset(
                        'assets/user_login.png',
                        width: 121.0, // Set the width of the image
                        height: 115.0, // Set the height of the image
                        // Add other properties as needed
                      ),
                         // Placeholder for when image is null
                    ),
                    // Change Profile Picture Button
                    // Positioned(
                    //   bottom: 20,
                    //   right: 20,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       // Handle button click to change profile picture
                    //       // Implement logic to pick a new image
                    //     },
                    //     child: Icon(Icons.edit),
                    //   ),
                    // ),
                    SizedBox( height: 10,),

                    Text(
                      _userName,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.0,
                        color:  Color.fromARGB( 255, 0, 77, 87),
                      ),
                    ),

                    SizedBox( height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: 271,
                          height: 51,
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
                          color:  Color.fromARGB( 255, 0, 77, 87),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                "Edit Profile",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              Icon( Icons.mode_edit_outlined , color: Colors.white,),

                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox( height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 271,
                        height: 51,
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
                          color:  Color.fromARGB( 255, 0, 77, 87),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                "Streak",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              Icon( Icons.local_fire_department_rounded , color: Colors.white,),

                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox( height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 271,
                        height: 51,
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
                          color:  Color.fromARGB( 255, 0, 77, 87),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                "Log Out",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () async {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginMess(),
                                    ),
                                  );

                                  await FirebaseAuth.instance.signOut();
                                },
                                icon: Icon(Icons.logout_outlined , color:Colors.white ),
                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox( height: 10,),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 271,
                        height: 51,



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
                          color:  Color.fromARGB( 255, 0, 77, 87),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                "Share",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.share, color: Colors.white),
                                onPressed: () {
                                  Share.share('Share text');
                                },
                              ),

                            ],
                          ),
                        ),
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
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserProfile(),
  ));
}
