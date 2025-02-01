// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  // Easy to change values
  static const double fieldHoriPadding = 20;
  static const double fieldVertPadding = 13;
  static const double fieldBordRad = 20.0;
  static const int tFBgColor = 0xffdedcdb;
  static const TextStyle dataTextStyle = TextStyle(fontSize: 30);
  static const TextStyle labelTextStyle = TextStyle();
  // Late tells that it will be initialized; it wont be used until it is initialized
  late List<dynamic> actionFunctions = [
    _changeName,
    _changePassword,
    _changeAddressOne,
    _changeAddressTwo,
    _changePhoneNumber,
    _changeEmail,
    _addWalletBalance
  ];
  static const List<String> labels = [
    "Full Name",
    "Password",
    "Address 1",
    "Address 2",
    "Phone Number",
    "Email",
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
    "Address 2",
    "Phone Number",
    "Email"
  ];
  // List of all controllers
  late Map<String, TextEditingController> fieldControllers;

// Will be called when initialized
  @override
  void initState() {
    // DO NOT TOUCH
    _initMyControllers();
    super.initState();
  }

// Will be called when widget is disposed
  @override
  void dispose() {
    // for (var name in controllerNames) {
    //   fieldControllers[name]?.dispose();
    // }

    // DO NOT TOUCH
    super.dispose();
  }

  // Saves user data retrieved from FireBase
  Future<List<String>> _recordData(dynamic retrievedData) async {
    print("getting data from database...");
    print("saving to variable...");

    var retrievedData = Future.value([
      "Andrew Tate",
      "TopG",
      "Bahay13",
      "Bahay2",
      "09271234567",
      "hustlersuniversity@gmail.com",
      "P1,000,000,000,000,000.00"
    ]);
    // Test delay
    await Future.delayed(const Duration(seconds: 3));
    return retrievedData;
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
        future: _recordData(null),
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
        itemCount: 7,
        itemBuilder: (context, index) => _grayFieldsBuilder(null, index));
  }

  // Returns widget being built by ListView.builder()
  Padding _grayFieldsBuilder(void _, int index) {
    // .builder() automatically creates copies of widget repeatedly
    final clickableIcon = index == 6 ? Icons.add_circle : Icons.edit;
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

  // Initializes Text Field Controllers
  _initMyControllers() {
    for (var name in controllerNames) {
      print("inting" + name);
      fieldControllers[name] = TextEditingController();
    }
  }

  Future _changeName() {
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
                    controller: fieldControllers[0],
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
                  // First Name Label
                  Text(controllerNames[1]),
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
                      controller: fieldControllers[1]),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          // Save Changes Button
          TextButton(
            onPressed: () {
              fieldDatas?[0] = fieldControllers["First Name"]!.text +
                  fieldControllers["Last Name"]!.text;
              print("PRINTING");
              print(fieldControllers["First Name"]!.text);
              // Navigator.pop(context);
            },
            child: Text("Save Changes"),
          )
        ],
      ),
    );
  }

  static _changePassword() {
    print("changing password...");
  }

  static _changeAddressOne() {
    print("changing address1...");
  }

  static _changeAddressTwo() {
    print("changing address2...");
  }

  static _changePhoneNumber() {
    print("changing phone number...");
  }

  static _changeEmail() {
    print("changing email...");
  }

  static _addWalletBalance() {
    print("adding wallet balance...");
  }
}
