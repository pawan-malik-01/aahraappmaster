import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'LoginForm.dart';

void main() {
   runApp(  MaterialApp(
    home:  UserProfileScreen(),
  ));
}

class UserProfileScreen extends StatefulWidget {
  @override
   _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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
      appBar: AppBar(
        title: Text('Profile' ,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color:  Color.fromARGB(255, 171, 99, 0),
          ),),
        backgroundColor: Color.fromARGB(255, 255, 240, 220),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginForm(),
                ),
              );
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout_sharp, color: Color.fromARGB(255, 171, 99, 0)),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 30, left: 18.0, right: 18.0),
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Color(0xfffff0dc),
            child: ClipOval(
              child: Image.asset(
                'assets/student.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              // data['name'], // Use data from Firestore for the user's name
              _userName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 171, 99, 0),
              ),
            ),
          ),
          SizedBox(height: 10),
          _buildInfoCard(
            'Name',
            _userName,
            400.0,
            80.0,
            BoxDecoration(
              color: Color(0xfffff0dc),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          _buildInfoCard(
            "User Id",
            _user.uid,
            400.0,
            80.0,
            BoxDecoration(
              color: Color(0xfffff0dc),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          _buildInfoCard(
            'About Us',
            "aaharbyaashray@gmail.com",
            400.0,
            80.0,
            BoxDecoration(
              color: Color(0xfffff0dc),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildInfoCard(String label, String value, double containerWidth,
      double containerHeight, BoxDecoration containerDecoration) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: containerWidth,
        height: containerHeight,
        decoration: containerDecoration,
        child: ListTile(
          contentPadding: EdgeInsets.all(5),
          title: Text(
            label,
            style: TextStyle(
              fontSize: 20, // Increase font size for the label
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 171, 99, 0),
            ),
          ),
          subtitle: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            // Add vertical padding for the subtitle
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 18, color: Color.fromARGB(255, 171, 99, 0)),
            ),
          ),
        ),
      ),
    );
  }
}
