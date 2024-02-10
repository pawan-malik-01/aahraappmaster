import 'package:aashray_veriion3/userpage.dart';
import 'package:aashray_veriion3/userprofilescreen.dart';

import 'package:flutter/material.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'UserProfile.dart';
import 'websiteAshray.dart';

void main() {
  runApp(MaterialApp(
    home: UserScreen(),
  ));
}

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();


}

class _UserScreenState extends State<UserScreen> {

  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children:  <Widget>[
          userpage(),
          Websiteview(),
          UserProfile(),
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
            Icons.insert_chart_outlined_rounded,
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
    );
  }

}





