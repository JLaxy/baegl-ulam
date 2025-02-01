import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/screens/login_screen.dart';
import 'package:login/services/firestore.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();
  String? secretQuestion;
  String? secretAnswer;
  String docID = "0";

  bool _showAnswerForm = false;
  bool _showChangePasswordForm = false;
  bool _showGetSecretInfoButton = true;

  Future<void> _getUserSecretInfo() async {
    String username = _usernameController.text.trim();

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        if (userDoc.exists && userDoc.data() != null) {
          docID = userDoc.id;
          setState(() {
            secretQuestion = userDoc['secret question:'];
            secretAnswer = userDoc['secret answer'];
            _showAnswerForm = true;
            _showGetSecretInfoButton = false; // Hide the Get Secret Info button
          });
        }
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Invalid Input'),
              content: Text('Username not found'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error retrieving user info: $e');
    }
  }

  void _checkAnswerAndShowChangePassword() {
    if (_answerController.text.trim() == secretAnswer) {
      setState(() {
        _showChangePasswordForm = true;
        _showAnswerForm = false; // Hide the answer field after correct answer
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Input'),
            content: Text('Secret answer dont match'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _changePassword() {
    firestoreService.updatePass(docID, _newPasswordController.text);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Password Changed'),
          content: Text('Redirecting to Login Page'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            color: Colors.black87, // Set text color to black (30%)
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_showAnswerForm && !_showChangePasswordForm)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    border: Border.all(color: Colors.deepPurple, width: 2.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                        icon: Icon(
                          Icons.person,
                        ),
                        border: InputBorder.none,
                        hintText: 'Username',
                        iconColor: Colors.deepPurple),
                  ),
                ),
              if (_showGetSecretInfoButton)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            _getUserSecretInfo();
                          },
                          color:
                              Colors.black87, // Set button color to black (30%)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              "Find Username",
                              style: TextStyle(
                                color: Colors.white, // Set text color to white
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_showAnswerForm)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 15),
                      child: Text(
                        'Secret Question: $secretQuestion',
                        style: TextStyle(
                          color:
                              Colors.black87, // Set text color to black (30%)
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        border:
                            Border.all(color: Colors.deepPurple, width: 2.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _answerController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.question_mark_sharp),
                          border: InputBorder.none,
                          hintText: 'Answer',
                          iconColor: Colors.deepPurple,
                        ),
                      ),
                    ),
                    //Submit answer button
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                _checkAnswerAndShowChangePassword();
                              },
                              color: Colors
                                  .black87, // Set button color to black (30%)
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              if (_showChangePasswordForm)
                //new password text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        border:
                            Border.all(color: Colors.deepPurple, width: 2.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          border: InputBorder.none,
                          hintText: 'New Password',
                          iconColor: Colors.deepPurple,
                        ),
                      ),
                    ),
                    //change password button
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                _changePassword();
                              },
                              color: Colors
                                  .black87, // Set button color to black (30%)
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  "Change Password",
                                  style: TextStyle(
                                    color:
                                        Colors.white, // Set text color to white
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
