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
  static const double fieldRad = 10.0;
  static const int tFBgColor = 0xffdedcdb;
  static const TextStyle dataTextStyle = TextStyle(fontSize: 30);
  static const TextStyle labelTextStyle = TextStyle();
  // Duration of fake transaction
  static const int timeDuration = 3;

  // Late tells that it will be initialized; it wont be used until it is initialized
  late final List<dynamic> actionFunctions = [
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
    "Balance"
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
  static final TextEditingController _balanceController =
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
        final balance = userData['balance'].toString();

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

// Builds List View
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
                    child: Text(
                      // Default value is error if null
                      fieldDatas?[index] ?? "no data",
                      style: dataTextStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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

// Builds Field
  Padding _buildField(String label, TextEditingController controller,
          [String? Function(String?)? func]) =>
      Padding(
        padding: const EdgeInsets.only(
            top: fieldVertPadding, bottom: fieldVertPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Name Label
            Text(label),
            // First Name Text Field
            TextFormField(
              validator: func,
              // Border
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(fieldRad),
                  borderSide: BorderSide(width: 0, style: BorderStyle.none),
                ),
                filled: true,
                fillColor: Color(tFBgColor),
              ),
              controller: controller,
            ),
          ],
        ),
      );

// Dialog for changing name
  _changeNameDialog() {
    final nameFormKey = GlobalKey<FormState>();
    _firstNameController.text = fieldDatas![0].split(" ")[0];
    _lastNameController.text = fieldDatas![0].split(" ")[1];
    return showDialog(
      barrierDismissible: false,
      context: context,
      // Alert Dialog
      builder: (context) => AlertDialog(
        // Alert Dialog Title
        title: Text("Change Name"),
        // Form
        content: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: nameFormKey,
          // Column
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // First Name Field
              _buildField(
                  controllerNames[0], _firstNameController, _notEmptyValidator),
              _buildField(
                  controllerNames[1], _lastNameController, _notEmptyValidator)
            ],
          ),
        ),
        // Dialogue Actions
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          // Save Changes Button
          TextButton(
            onPressed: () {
              final isValid = nameFormKey.currentState!.validate();

              if (isValid) {
                setState(() => fieldDatas?[0] =
                    "${_firstNameController.text} ${_lastNameController.text}");
                updater.updateName(widget.docID, _firstNameController.text,
                    _lastNameController.text);
                Navigator.pop(context);
                _firstNameController.clear();
                _lastNameController.clear();
              }
            },
            child: Text("Save Changes"),
          )
        ],
      ),
    );
  }

// Checks if Text Form Field is not empty
  String? _notEmptyValidator(value) {
    if (value == "") {
      return "Cannot be empty!";
    }
    return null;
  }

// Dialog for changing password
  _changePasswordDialog() {
    final passFormKey = GlobalKey<FormState>();

    return showDialog(
      barrierDismissible: false,
      context: context,
      // Alert Dialog
      builder: (context) => AlertDialog(
        // Alert Dialog Title
        title: Text("Change Password"),
        // Main Column
        // Form
        content: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: passFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Password Field
              _buildField(
                  controllerNames[2], _passwordController, _passwordValidator),
              // Confirm Password Field
              _buildField(controllerNames[3], _confirmPasswordController,
                  _notEmptyValidator)
            ],
          ),
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _passwordController.clear();
              _confirmPasswordController.clear();
            },
            child: Text("Cancel"),
          ),
          // Save Changes Button
          TextButton(
            onPressed: () {
              final isValid = passFormKey.currentState!.validate();
              print(isValid);

              if (isValid) {
                setState(() => fieldDatas?[1] = _passwordController.text);
                updater.updatePassword(widget.docID, _passwordController.text);
                Navigator.pop(context);
                _passwordController.clear();
                _confirmPasswordController.clear();
              }
            },
            child: Text("Save Changes"),
          )
        ],
      ),
    );
  }

// Method that checks password
  String? _passwordValidator(value) {
    if (value == "") {
      return "Cannot be empty!";
    } else if (value!.length < 8) {
      return "Too short!";
    } else if (_passwordController.text != _confirmPasswordController.text) {
      return "Passwords do not match!";
    }
    return null;
  }

// Dialog for changing address
  _changeAddressOneDialog() {
    final addressFormKey = GlobalKey<FormState>();
    _addressOneController.text = fieldDatas![2];
    return showDialog(
      barrierDismissible: false,
      context: context,
      // Alert Dialog
      builder: (context) => AlertDialog(
        // Alert Dialog Title
        title: Text("Change Address"),
        // Main Column
        // Form
        content: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: addressFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Address Field
              _buildField(controllerNames[4], _addressOneController,
                  _notEmptyValidator),
            ],
          ),
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          // Save Changes Button
          TextButton(
            onPressed: () {
              final isValid = addressFormKey.currentState!.validate();
              print(isValid);

              if (isValid) {
                setState(() => fieldDatas?[2] = _addressOneController.text);
                updater.updateAddress(widget.docID, _addressOneController.text);
                Navigator.pop(context);
                _addressOneController.clear();
              }
            },
            child: Text("Save Changes"),
          )
        ],
      ),
    );
  }

// Dialog for changing phone
  _changePhoneNumberDialog() {
    final phoneFormKey = GlobalKey<FormState>();
    _phoneNumberController.text = fieldDatas![3];
    return showDialog(
      barrierDismissible: false,
      context: context,
      // Alert Dialog
      builder: (context) => AlertDialog(
        // Alert Dialog Title
        title: Text("Change Phone Number"),
        // Main Column
        // Form
        content: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: phoneFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Address Field
              _buildNumberField(controllerNames[5], _phoneNumberController,
                  _phoneNumberValidator),
            ],
          ),
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          // Save Changes Button
          TextButton(
            onPressed: () {
              final isValid = phoneFormKey.currentState!.validate();
              print(isValid);

              if (isValid) {
                setState(() => fieldDatas?[3] = _phoneNumberController.text);
                updater.updatePhoneNumber(
                    widget.docID, _phoneNumberController.text);
                Navigator.pop(context);
                _phoneNumberController.clear();
              }
            },
            child: Text("Save Changes"),
          )
        ],
      ),
    );
  }

// Method that checks phone number
  String? _phoneNumberValidator(value) {
    // if(value == "" || )

    if (value == "" ||
        value.length < 2 ||
        (value[0] != "0" || value[1] != "9" || value.length != 11)) {
      return "Invalid phone number!";
    }
    return null;
  }

// Field that accepts number
  Padding _buildNumberField(String label, TextEditingController controller,
          [String? Function(String?)? func]) =>
      Padding(
        padding: const EdgeInsets.only(
            top: fieldVertPadding, bottom: fieldVertPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Name Label
            Text(label),
            // First Name Text Field
            TextFormField(
              keyboardType: TextInputType.number,
              validator: func,
              // Border
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(fieldRad),
                  borderSide: BorderSide(width: 0, style: BorderStyle.none),
                ),
                filled: true,
                fillColor: Color(tFBgColor),
              ),
              controller: controller,
            ),
          ],
        ),
      );

// Dialog for adding wallet balance
  _addWalletBalanceDialog() {
    final balanceFormKey = GlobalKey<FormState>();
    return showDialog(
      barrierDismissible: false,
      context: context,
      // Alert Dialog
      builder: (context) => AlertDialog(
        // Alert Dialog Title
        title: Text("Top-up Wallet"),
        // Main Column
        // Form
        content: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: balanceFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Balance Field
              _buildNumberField(
                  controllerNames[6], _balanceController, _amountValidator),
            ],
          ),
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _balanceController.clear();
            },
            child: Text("Cancel"),
          ),
          // Save Changes Button
          TextButton(
            onPressed: () {
              // Checks if all fields are valid
              final isValid = balanceFormKey.currentState!.validate();
              print(isValid);

              // If valid
              if (isValid) {
                // Update data in field datas
                double newAmount = double.parse(fieldDatas![4]) +
                    double.parse(_balanceController.text);
                setState(() => fieldDatas?[4] = newAmount.toString());
                // Update balance to firebase
                updater.updateBalance(widget.docID, newAmount);
                Navigator.pop(context);
                _balanceController.clear();
                // Show loading dialog
                _loadingDialog();
              }
            },
            child: Text("Save Changes"),
          )
        ],
      ),
    );
  }

  // Checks if value is double
  String? _amountValidator(value) {
    // Catches if there exception
    try {
      double doubleValue = double.parse(value);
      if (doubleValue < 0) {
        throw Exception;
      }
      // If number on field is not valid
    } catch (e) {
      return "Invalid amount!";
    }
    return null;
  }

  // Returns dialog displaying loading
  _loadingDialog() {
    print("loading dialog");
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        // Will remove loading dialog then show transaction complete after 3 seconds
        Future.delayed(
          const Duration(seconds: timeDuration),
          // Function it will do after delay
          () {
            Navigator.pop(context);
            _transactCompleteDialog();
          },
        );
        // Immediately show loading dialog
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [CircularProgressIndicator()],
          ),
        );
      },
    );
  }

  // Returns dialog displaying transaction is complete
  _transactCompleteDialog() {
    print("complete dialog");
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [Text("Transaction Complete")],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Finish"),
            ),
          ],
        );
      },
    );
  }
}
