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
  late List<String>? fieldDatas;

// Will be called when initialized
  @override
  void initState() {
    // DO NOT TOUCH
    super.initState();
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
