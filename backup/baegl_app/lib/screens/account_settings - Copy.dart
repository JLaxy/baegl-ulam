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
  static const double fieldVertPadding = 10;
  static const double fieldBordRad = 20.0;
  static const int tFBgColor = 0xffdedcdb;
  static const TextStyle dataTextStyle = TextStyle(fontSize: 30);
  static const TextStyle labelTextStyle = TextStyle();
  // static const List<Function> actionFunctions = [];
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
  late List<String> fieldData;

// Will be called when initialized
  @override
  void initState() {
    // INSERT CODE GETTING DATA FROM DATABASE
    print("getting data from database...");
    // Recording data retrieved from database; retrieved data as argument

    fieldData = _recordData(null);

    // DO NOT TOUCH
    super.initState();
  }

  // Saves user data retrieved from FireBase
  List<String> _recordData(dynamic retrievedData) {
    print("saving to variable...");

    // Dummy Data
    var test = [
      "Andrew Tate",
      "TopG",
      "Bahay1",
      "Bahay2",
      "09271234567",
      "hustlersuniversity@gmail.com",
      "P1,000,000,000,000,000.00"
    ];

    return test;
  }

// Builds Widget
  @override
  Widget build(BuildContext context) {
    print("i am running");
    return Scaffold(
      appBar: AppBar(title: const Text("ACCOUNT INFORMATION")),
      // Builds Gray Fields
      body: ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) => _grayFieldsBuilder(null, index)),
    );
  }

  // Returns widget being built by ListView.builder()
  Padding _grayFieldsBuilder(void _, int index) {
    // .builder() automatically creates copies of widget repeatedly
    final clickableIcon = index == 6 ? Icons.add_circle : Icons.edit;
    return Padding(
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
                        fieldData[index],
                        style: dataTextStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  // Clickable Buttons
                  IconButton(
                      onPressed: () => print(index), icon: Icon(clickableIcon))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
