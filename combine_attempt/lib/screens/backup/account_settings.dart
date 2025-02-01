// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/services/firestore.dart';
import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key, required this.docID});
  final String docID;

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  // Data updater
  final AccountSettingsUpdater updater = AccountSettingsUpdater();

  // Easy to change values
  static const double fieldHoriPadding = 20;
  static const double fieldVertPadding = 13;
  static const double fieldBordRad = 20.0;
  static const int tFBgColor = 0xffdedcdb;
  static const TextStyle dataTextStyle = TextStyle(fontSize: 30);
  static const TextStyle labelTextStyle = TextStyle();
  // Late tells that it will be initialized; it wont be used until it is initialized
  late List<dynamic> actionFunctions = [
    _changeNameDialog,
    _changePasswordDialog,
    _changeAddressOneDialog,
    _changePhoneNumberDialog,
    _addWalletBalanceDialog
  ];
  static const List<String> labels = [
    "Full Name",
    "Password",
    "Address 1",
    "Phone Number",
    "Current Wallet Balance"
  ];
  // Contains data retrieved from database
  late List<String>? fieldDatas;

  static const List<String> controllerNames = [
    "First Name",
    "Last Name",
    "Password",
    "Confirm Password",
    "Address 1",
    "Phone Number",
  ];
  // List of all controllers
  static final TextEditingController _firstNameController =
      TextEditingController();
  static final TextEditingController _lastNameController =
      TextEditingController();
  static final TextEditingController _passwordController =
      TextEditingController();
  static final TextEditingController _confirmPasswordController =
      TextEditingController();
  static final TextEditingController _addressOneController =
      TextEditingController();
  static final TextEditingController _phoneNumberController =
      TextEditingController();

// Will be called when initialized
  @override
  void initState() {
    // DO NOT TOUCH
    super.initState();
  }

  // Saves user data retrieved from FireBase
  Future<List<String>> _recordData() async {
    print('docID' + widget.docID);
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.docID)
              .get();

      final userData = snapshot.data();
      if (userData != null) {
        final firstName = userData['first_name'] ?? '';
        final lastName = userData['last_name'] ?? '';
        final fullName = firstName.isNotEmpty && lastName.isNotEmpty
            ? '$firstName $lastName'
            : 'No Full Name';
        String password = userData['password'] ?? 'No Password';
        final address = userData['address'] ?? 'No Address';
        final phoneNumber = userData['phone_number'] ?? '';
        final balance = userData['balance'].toString() ?? '';

        var temp = password.split('');
        password = "";
        for (var _ in temp) {
          password += "*";
        }

        return [fullName, password, address, phoneNumber, balance];
      }
    } catch (e) {
      print('Error retrieving user data: $e');
    }

    return ['No Data', 'No Data', 'No Data', '', '', '', ''];
  }

// Builds Widget
  @override
  Widget build(BuildContext context) {
    print("i am running");
    return Scaffold(
      appBar: AppBar(title: const Text("ACCOUNT INFORMATION")),
      // FutureBuilder that waits for data to be retrieved
      body: FutureBuilder<List<String>>(
        // The function that will retrieve data from database; returned object will be assigned to "snapshot variable"
        future: _recordData(),
        // Function that builds before
        builder: (context, snapshot) {
          fieldDatas = snapshot.data;
          print("retrieved data:");
          print(fieldDatas);

          // Handles operations
          switch (snapshot.connectionState) {
            // If still retrieving
            case ConnectionState.waiting:
              // Show loading screen
              return Center(child: CircularProgressIndicator());
            // If done retrieving
            case ConnectionState.done:
              // Show screen
              return _myListViewBuilder();
            default:
              return Center(
                child: Text("switch case defaulted lol"),
              );
          }
        },
      ),
    );
  }

  ListView _myListViewBuilder() {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => _grayFieldsBuilder(null, index));
  }

  // Returns widget being built by ListView.builder()
  Padding _grayFieldsBuilder(void _, int index) {
    // .builder() automatically creates copies of widget repeatedly
    final clickableIcon = index == 4 ? Icons.add_circle : Icons.edit;
    return Padding(
      // Defining padding
      padding: EdgeInsets.only(
          left: fieldHoriPadding,
          right: fieldHoriPadding,
          top: fieldVertPadding,
          bottom: fieldVertPadding),
      // Display Field
      child: Container(
        decoration: BoxDecoration(
            color: Color(tFBgColor),
            borderRadius: BorderRadius.circular(fieldBordRad)),
        // Imaginary Container
        child: Container(
          // Sets Margin from outer Container
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Label Text
              Text(
                labels[index],
                style: labelTextStyle,
              ),
              // Current Data Stored
              Row(
                children: [
                  // Widget that makes sure to sakop all available space
                  Expanded(
                    // Box for debugging
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.blue),
                      // Data text
                      child: Text(
                        // Default value is error if null
                        fieldDatas?[index] ?? "no data",
                        style: dataTextStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  // Clickable Buttons
                  IconButton(
                      // Function that will be called when pressing icon
                      onPressed: actionFunctions[index],
                      icon: Icon(clickableIcon))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// Dialog for changing name
  _changeNameDialog() {
    return showDialog(
      context: context,
      // Alert Dialog
      builder: (context) => AlertDialog(
        // Alert Dialog Title
        title: Text("Change Name"),
        // Main Column
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // First Name Column
            Padding(
              padding: const EdgeInsets.only(
                  top: fieldVertPadding, bottom: fieldVertPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First Name Label
                  Text(controllerNames[0]),
                  // First Name Text Field
                  TextField(
                    // Border
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(width: 0, style: BorderStyle.none),
                      ),
                      filled: true,
                      fillColor: Color(tFBgColor),
                    ),
                    controller: _firstNameController,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: fieldVertPadding, bottom: fieldVertPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Last Name Label
                  Text(controllerNames[1]),
                  // Last Name Text Field
                  TextField(
                      // Border
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(width: 0, style: BorderStyle.none),
                        ),
                        filled: true,
                        fillColor: Color(tFBgColor),
                      ),
                      controller: _lastNameController),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              _firstNameController.clear();
              _lastNameController.clear();
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          // Save Changes Button
          TextButton(
            onPressed: () {
              if (_firstNameController.text.isNotEmpty &&
                  _lastNameController.text.isNotEmpty) {
                setState(() {
                  fieldDatas?[0] = _firstNameController.text +
                      " " +
                      _lastNameController.text;
                });
                updater.updateName(widget.docID, _firstNameController.text,
                    _lastNameController.text);
                print("printing...");
                print(fieldDatas?[0]);
              }
              _firstNameController.clear();
              _lastNameController.clear();
              Navigator.pop(context);
            },
            child: Text("Save Changes"),
          )
        ],
      ),
    );
  }

// Dialog for changing password
  _changePasswordDialog() {
    return showDialog(
      context: context,
      // Alert Dialog
      builder: (context) => AlertDialog(
        // Alert Dialog Title
        title: Text("Change Password"),
        // Main Column
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Password Column
            Padding(
              padding: const EdgeInsets.only(
                  top: fieldVertPadding, bottom: fieldVertPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Password Label
                  Text(controllerNames[2]),
                  // Password Text Field
                  TextField(
                    // Border
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(width: 0, style: BorderStyle.none),
                      ),
                      filled: true,
                      fillColor: Color(tFBgColor),
                    ),
                    // Controller
                    controller: _passwordController,
                  ),
                ],
              ),
            ),
            // Confirm Password Column
            Padding(
              padding: const EdgeInsets.only(
                  top: fieldVertPadding, bottom: fieldVertPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Confirm Password Label
                  Text(controllerNames[3]),
                  // Confirm Password Text Field
                  TextField(
                      // Border
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(width: 0, style: BorderStyle.none),
                        ),
                        filled: true,
                        fillColor: Color(tFBgColor),
                      ),
                      controller: _confirmPasswordController),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              _passwordController.clear();
              _confirmPasswordController.clear();
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          // Save Changes Button
          TextButton(
            onPressed: () {
              if (_passwordController.text.isNotEmpty &&
                  _confirmPasswordController.text.isNotEmpty) {
                setState(() {
                  fieldDatas?[1] = _passwordController.text;
                });
                updater.updatePassword(widget.docID, _passwordController.text);
                print("printing...");
                print(fieldDatas?[1]);
              }
              _passwordController.clear();
              _confirmPasswordController.clear();
              Navigator.pop(context);
            },
            child: Text("Save Changes"),
          )
        ],
      ),
    );
  }

// Dialog for changing address
  _changeAddressOneDialog() {
    return showDialog(
      context: context,
      // Alert Dialog
      builder: (context) => AlertDialog(
        // Alert Dialog Title
        title: Text("Change Address"),
        // Main Column
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Address Column
            Padding(
              padding: const EdgeInsets.only(
                  top: fieldVertPadding, bottom: fieldVertPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address Label Label
                  Text(controllerNames[4]),
                  // Password Text Field
                  TextField(
                    // Border
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(width: 0, style: BorderStyle.none),
                      ),
                      filled: true,
                      fillColor: Color(tFBgColor),
                    ),
                    // Controller
                    controller: _addressOneController,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              _addressOneController.clear();
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          // Save Changes Button
          TextButton(
            onPressed: () {
              if (_addressOneController.text.isNotEmpty) {
                setState(() {
                  fieldDatas?[2] = _addressOneController.text;
                });
                updater.updateAddress(widget.docID, _addressOneController.text);
                _addressOneController.clear();
                print("printing...");
                print(fieldDatas?[2]);
              }
              _addressOneController.clear();
              Navigator.pop(context);
            },
            child: Text("Save Changes"),
          )
        ],
      ),
    );
  }

// Dialog for changing phone
  _changePhoneNumberDialog() {
    return showDialog(
      context: context,
      // Alert Dialog
      builder: (context) => AlertDialog(
        // Alert Dialog Title
        title: Text("Change Phone Number"),
        // Main Column
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Address Column
            Padding(
              padding: const EdgeInsets.only(
                  top: fieldVertPadding, bottom: fieldVertPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address Label Label
                  Text(controllerNames[5]),
                  // Password Text Field
                  TextField(
                    // Border
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(width: 0, style: BorderStyle.none),
                      ),
                      filled: true,
                      fillColor: Color(tFBgColor),
                    ),
                    // Controller
                    controller: _phoneNumberController,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              _phoneNumberController.clear();
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          // Save Changes Button
          TextButton(
            onPressed: () {
              if (_phoneNumberController.text.isNotEmpty) {
                setState(() {
                  fieldDatas?[3] = _phoneNumberController.text;
                });
                updater.updatePhoneNumber(
                    widget.docID, _phoneNumberController.text);
                _phoneNumberController.clear();
                print("printing...");
                print(fieldDatas?[3]);
              }
              _phoneNumberController.clear();
              Navigator.pop(context);
            },
            child: Text("Save Changes"),
          )
        ],
      ),
    );
  }

// Dialog for adding wallet balance
  static _addWalletBalanceDialog() {
    print("adding wallet balance...");
  }
}
