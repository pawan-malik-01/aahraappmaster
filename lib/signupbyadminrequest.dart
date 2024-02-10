import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupByHadminRequest extends StatelessWidget {
  final String phoneNumber = "7796310414"; // Replace with the actual phone number

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
              width: 53, // Adjust width as needed
              height: 53, // Adjust height as needed
              top: 66,
              left: 36,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 0, 93, 122),
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
                  child: Icon(Icons.arrow_back_ios_outlined, color:Colors.white),
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


            // Content centered horizontally
            Positioned.fill(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.call,
                        color: Color.fromARGB(255, 0, 93, 122)),
                    Text('Contact',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 32.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.0,
                        color:  Color.fromARGB( 255, 0, 77, 87),
                      ),
                    ),
                    SizedBox( height: 20,),
                    Text(
                      'To sign up, you need to contact \n the Aashray Team:',
                      style: TextStyle(fontSize: 22,

                        color: Color.fromARGB(255, 50, 29, 1),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0 , right: 40),
                      child: Row(
                        children: [
                          Icon(Icons.email,
                              color: Color.fromARGB(255, 0, 93, 122)),
                          SizedBox( width: 10,),
                          Text( "Email -",
                            style: TextStyle(fontSize: 22,

                              color: Color.fromARGB(255, 50, 29, 1),
                            ),),

                        ],
                      ),
                    ),
                    SizedBox( height: 10,),
                    Text(
                      'aaharbyaashray@gmail.com',
                      style: TextStyle(fontSize: 22,
                        color: Color.fromARGB(255, 0, 93, 122),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox( height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0 , right: 40),
                      child: Row(
                        children: [
                          Icon(Icons.phone_android_outlined,
                              color: Color.fromARGB(255, 0, 93, 122)),
                          SizedBox( width: 10,),
                          Text( "Phone -",
                            style: TextStyle(fontSize: 22,

                              color: Color.fromARGB(255, 50, 29, 1),
                            ),),

                        ],
                      ),
                    ),
                    SizedBox( height: 10,),
                    Text( phoneNumber,
                      style: TextStyle(fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 93, 122),

                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.only(left:38.0 , right: 38),
                      child: ElevatedButton(
                        onPressed: () {
                          _makePhoneCall(phoneNumber);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 0, 93, 122),
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30.0), // Adjust the radius for rounded corners
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 40)),
                        ),
                        child: Text('Make a Call',
                          style: TextStyle(fontSize: 19,

                            color: Colors.white,
                          ),
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
  }

  // Function to make a phone call
  _makePhoneCall(String phoneNumber) async {
    final String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

