import 'package:aashray_veriion3/signupbyadminrequest.dart';
import 'package:flutter/material.dart';
import 'package:aashray_veriion3/authFunction2.dart';

class LoginMess extends StatefulWidget {
  const LoginMess({super.key});

  @override
  State<LoginMess> createState() => _LoginMessState();
}

class _LoginMessState extends State<LoginMess> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String fullname = '';
  String fullnamemess = '';
  String address = '';

  bool login = true; // Start with login mode

  String role = 'mess';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB( 255, 0, 77, 87),

      body: SingleChildScrollView(
        child: Form(

          key: _formKey,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    "Aahar",
                    style: TextStyle(
                      fontFamily: 'Ravi Prakash',
                      fontSize: 45,
                      fontWeight: FontWeight.w400,
                      height: 62 / 39,
                      letterSpacing: 0,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only( top: 20.0),
                  child: Image.asset(
                    'assets/user_login.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(64, 217, 217, 217),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(53.0),
                        topRight: Radius.circular(53.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Text(
                              'Login to your account',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(53.0),
                                  topRight: Radius.circular(53.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(48.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (!login)

                                      TextFormField(
                                        key: ValueKey('fullname'),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color.fromARGB(255, 255, 255, 255),
                                          hintText: 'Enter Password',
                                          hintStyle: TextStyle(color: Color.fromARGB(255, 0, 93, 122)),
                                          prefixIcon: Icon(Icons.password_outlined,
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
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please Enter Full Name';
                                          } else {
                                            return null;
                                          }
                                        },
                                        onSaved: (value) {
                                          setState(() {
                                            fullname = value!;
                                          });
                                        },
                                      ),
                                    if (!login)
                                      TextFormField(
                                        key: ValueKey('Mess Name'),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color.fromARGB(255, 255, 255, 255),
                                          hintText: 'Enter Password',
                                          hintStyle: TextStyle(color: Color.fromARGB(255, 0, 93, 122)),
                                          prefixIcon: Icon(Icons.password_outlined,
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
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please Enter Mess Name';
                                          } else {
                                            return null;
                                          }
                                        },
                                        onSaved: (value) {
                                          setState(() {
                                            fullnamemess = value!;
                                          });
                                        },
                                      ),
                                    if (!login)
                                      TextFormField(
                                        key: ValueKey('address'),
                                        decoration: InputDecoration(
                                          hintText: 'Enter Password',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(255, 171, 99, 0), // You can set the border color here
                                              width: 1.0, // You can set the border width here
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please Enter Mess address';
                                          } else {
                                            return null;
                                          }
                                        },
                                        onSaved: (value) {
                                          setState(() {
                                            address = value!;
                                          });
                                        },
                                      ),

                                    SizedBox(height: 30),
                                    TextFormField(
                                      key: ValueKey('email'),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color.fromARGB(255, 255, 255, 255),
                                        hintText: 'Enter Email',
                                        hintStyle: TextStyle(color: Color.fromARGB(255, 0, 93, 122)),
                                        prefixIcon: Icon(Icons.email_outlined,
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
                                      validator: (value) {
                                        if (value!.isEmpty || !value.contains('@')) {
                                          return 'Please Enter valid Email';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (value) {
                                        setState(() {
                                          role = 'mess';
                                          email = value!;
                                        });
                                      },
                                    ),

                                    SizedBox(height: 30),
                                    TextFormField(
                                      key: ValueKey('password'),
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color.fromARGB(255, 255, 255, 255),
                                        hintText: 'Enter Password',
                                        hintStyle: TextStyle(color: Color.fromARGB(255, 0, 93, 122)),
                                        prefixIcon: Icon(Icons.password_outlined,
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
                                      validator: (value) {
                                        if (value!.length < 6) {
                                          return 'Please Enter Password of min length 6';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (value) {
                                        setState(() {
                                          password = value!;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("Forgot Password ?",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 93, 122),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 55,
                                      width: double.infinity,
                                      child: ElevatedButton(

                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
                                            _formKey.currentState!.save();
                                            AuthServices.signinUser(role, email, password, context);
                                          }
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
                                        child: Text('Login',
                                          style: TextStyle(
                                            fontSize: 19,
                                            color:Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SignupByHadminRequest(),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Don't have an Account ? ",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text("sign up",
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 0, 93, 122),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 130),

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
