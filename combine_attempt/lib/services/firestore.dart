import 'package:cloud_firestore/cloud_firestore.dart';

class FoodService {
  final CollectionReference food =
      FirebaseFirestore.instance.collection('food');

  Stream<QuerySnapshot> getFoodStream() {
    final foodStream =
        food.orderBy('description', descending: true).snapshots();
    return foodStream;
  }
}

class FirestoreService {
//get
  final CollectionReference login =
      FirebaseFirestore.instance.collection('Users');
//create
  Future<void> addUser(
      String name, String password, String question, String answer) {
    return login.add({
      'username': name,
      'password': password,
      'secret question:': question,
      'secret answer': answer,
      'balance': 0,
    });
  }

//read usernames:
  Stream<QuerySnapshot> getUserStream() {
    final userStream = login.orderBy('username', descending: true).snapshots();
    return userStream;
  }

//update
  Future<void> updatePass(String docID, String password) {
    return login.doc(docID).update({
      'password': password,
    });
  }

//delete
  Future<void> deleteUser(String docID) {
    return login.doc(docID).delete();
  }

  //??
}

class AuthService {
  final FirestoreService firestoreService = FirestoreService();

  String docId = "0";
  String getDocumentId() => docId;

  // Setter for document ID
  set documentId(String id) {
    docId = id;
  }

  Future<bool> loginUser(String username, String password) async {
    try {
      // Fetch the user document with the provided username
      QuerySnapshot querySnapshot = await firestoreService.login
          .where('username', isEqualTo: username)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // User with the provided username exists
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Check if the entered password matches the stored password
        if (userDoc['password'] == password) {
          // Username and password match
          docId = userDoc.id;
          return true;
        } else {
          // Incorrect password
          return false;
        }
      } else {
        // User with the provided username doesn't exist
        return false;
      }
    } catch (e) {
      // Handle any potential errors here
      print('Error during login: $e');
      return false;
    }
  }
}

class AccountSettingsUpdater {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');

// Updating Full Name
  Future<void> updateName(String docID, String firstName, String lastName) {
    print(docID);
    print(firstName);
    print(lastName);
    return users.doc(docID).update(
      {
        'first_name': firstName,
        'last_name': lastName,
      },
    );
  }

  // Updating Password
  Future<void> updatePassword(String docID, String password) {
    return users.doc(docID).update(
      {
        'password': password,
      },
    );
  }

  // Updating Address
  Future<void> updateAddress(String docID, String address) {
    return users.doc(docID).update(
      {
        'address': address,
      },
    );
  }

  // Updating Phone Number
  Future<void> updatePhoneNumber(String docID, String phoneNumber) {
    return users.doc(docID).update(
      {
        'phone_number': phoneNumber,
      },
    );
  }

  // Updating Wallet Balance
  Future<void> updateBalance(String docID, double balance) {
    return users.doc(docID).update(
      {
        'balance': balance,
      },
    );
  }
}
