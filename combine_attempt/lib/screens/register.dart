// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:login/screens/login_screen.dart';

import 'package:login/services/firestore.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final TextEditingController _secretAnswerController = TextEditingController();

  bool isVisible = false;
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String _selectedSecretQuestion = "Name of your pet?"; // Default question

  final List<String> _secretQuestions = [
    "Name of your pet?",
    "What is your mother's maiden name?",
    "Which city were you born in?",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 30),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "Hi!",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              10), // Adding some space between "Welcome to" and the additional text
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                        child: Text(
                          "Let's create your new account",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w400,
                            // You can change the color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //username textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(color: Colors.deepPurple, width: 2.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: TextFormField(
                        controller: _usernameController,
                        validator: (value) {
                          Future.delayed(Duration(seconds: 5), () {
                            if (value!.isEmpty) {
                              return "Password is required";
                              // Show the error message after 5 seconds if the value is still empty
                            }
                          });
                          return null;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: Colors.deepPurple,
                          ),
                          border: InputBorder.none,
                          hintText: "Username",
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                //password textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(color: Colors.deepPurple, width: 2.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                        obscureText: !isVisible,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.lock,
                              color: Colors.deepPurple,
                            ),
                            border: InputBorder.none,
                            hintText: "Password",
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                                icon: Icon(
                                  Icons.visibility,
                                  color: Colors.deepPurple,
                                ))),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                //password2 textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(color: Colors.deepPurple, width: 2.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: TextFormField(
                        controller: _passwordController2,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                        obscureText: !isVisible,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock,
                            color: Colors.deepPurple,
                          ),
                          border: InputBorder.none,
                          hintText: "Repeat Password",
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                //secret question
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(color: Colors.deepPurple, width: 2.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: DropdownButtonFormField(
                        value: _selectedSecretQuestion,
                        items: _secretQuestions.map((question) {
                          return DropdownMenuItem(
                            value: question,
                            child: Text(question),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSecretQuestion = value.toString();
                          });
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Secret Question',
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                //secret answer
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(color: Colors.deepPurple, width: 2.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: TextFormField(
                        controller: _secretAnswerController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Answer is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Secret Answer',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                //button
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (_passwordController.text !=
                                  _passwordController2.text) {
                                // Passwords don't match, show a popup or display an error message
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Password Mismatch'),
                                      content: Text(
                                          'The entered passwords do not match. Please try again.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            _passwordController.clear();
                                            _passwordController2.clear();
                                            Navigator.pop(context);
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                // Passwords match, proceed with your registration logic
                                print(
                                    'Selected Secret Question: $_selectedSecretQuestion');
                                print(
                                    'Secret Answer: ${_secretAnswerController.text}');
                                print('Username: ${_usernameController.text}');

                                print('Password: ${_passwordController.text}');

                                firestoreService.addUser(
                                    _usernameController.text,
                                    _passwordController.text,
                                    _selectedSecretQuestion,
                                    _secretAnswerController.text);

                                _usernameController.clear();
                                _passwordController.clear();
                                _passwordController2.clear();
                                _secretAnswerController.clear();

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Account Created'),
                                      content:
                                          Text('Redirecting to Login Page'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen()));
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                // Add your registration logic here
                              }
                            }
                          },
                          color: Colors.black87,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: const Text("Register",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                )),
                          ),
                        ),
                      ),
                    ],
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


/*print('Selected Secret Question: $_selectedSecretQuestion');
                print('Secret Answer: ${_secretAnswerController.text}');

                firestoreService.addUser(
                    _usernameController.text,
                    _passwordController.text,
                    _selectedSecretQuestion,
                    _secretAnswerController.text);

                _usernameController.clear();
                _passwordController.clear();
                _secretAnswerController.clear();*/

                // Add your registration logic here
                // You can use _usernameController.text, _emailController.text, and _passwordController.text to get user input


/* 
StreamBuilder<QuerySnapshot>(
                    stream: firestoreService.getUserStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List userList = snapshot.data!.docs;

                        return ListView.builder(
                            itemCount: userList.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document = userList[index];
                              String docID = document.id;

                              Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;
                              String userText = data['username'];

                              return ListTile(
                                title: Text(userText),
                              );
                            });
                      } else {
                        return const Text("");
                      }
                    }),
*/







