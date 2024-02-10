import 'package:flutter/material.dart';
import 'authFunctions.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String role = '';
  String password = '';
  var enable=true;
  String fullname = '';

  bool login = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromARGB( 255, 0, 77, 87),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 18.0),
                Padding(
                  padding: const EdgeInsets.only(top: 40),

                  child: Text(
                    "Aahar",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 45,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
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
                              login
                                  ? "Sign In "
                                  : "Complete Your profile ",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          Container(

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
                                  login ? Container():
                                  TextFormField(
                                    key: ValueKey('fullname'),
                                    style: TextStyle(color: Color.fromARGB(255, 0, 93, 122)),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color.fromARGB(255, 255, 255, 255),
                                      hintText: 'Enter Full Name',
                                      hintStyle: TextStyle(color: Color.fromARGB(255, 0, 93, 122)),
                                      prefixIcon: Icon(Icons.drive_file_rename_outline_outlined,
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
                                        return 'Enter Full Name';
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
                                  SizedBox(height: 16),
                                  TextFormField(
                                    key: ValueKey('email'),
                                    style: TextStyle(color: Color.fromARGB(255, 0, 93, 122)),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color.fromARGB(255, 255, 255, 255),
                                      hintText: 'Enter Email',
                                      hintStyle: TextStyle(color: Color.fromARGB(255, 0, 93, 122)),
                                      prefixIcon: Icon(Icons.mail_outline,
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
                                      if (value!.isEmpty ||
                                          !value.contains('@')) {
                                        return 'Please Enter valid Email';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        role = 'user';
                                        email = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  TextFormField(
                                    key: ValueKey('password'),
                                    obscureText: true,
                                    style: TextStyle(color: Color.fromARGB(255, 0, 93, 122)),
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
                                    height: 30,
                                  ),
                                  Container(
                                    height: 55,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                          Color.fromARGB( 255, 0, 77, 87),
                                        ),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                30.0), // Adjust the radius for rounded corners
                                          ),
                                        ),
                                        minimumSize: MaterialStateProperty.all(Size(double.infinity, 40)),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState!
                                            .validate()) {
                                          _formKey.currentState!.save();
                                          login
                                              ? AuthServices.signinUser(
                                              role,
                                              email,
                                              password,
                                              context)
                                              : AuthServices.signupUser(
                                              role,
                                              email,
                                              password,
                                              fullname,
                                              context,
                                              enable
                                          );
                                        }
                                      },
                                      child: Text(login ? 'Login' : 'Signup',
                                        style: TextStyle(
                                          fontSize: 19,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        login = !login;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          login
                                              ? "Don't have an account? "
                                              : "Already have an account? ",
                                          style: TextStyle(

                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          login
                                              ? "Signup"
                                              : "Login",
                                          style: TextStyle(
                                            color:Color.fromARGB( 255, 0, 77, 87),
                                          ),
                                        ),

                                        login ? SizedBox(
                                          height: 10,) : Container(),




                                      ],

                                    ),
                                  ),
                                  login ? SizedBox(
                                    height: 200,) : SizedBox(
                                    height: 100,)
                                ],
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