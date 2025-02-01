// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/services/firestore.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirestoreService firestoreService = FirestoreService();
  List<String> docIDs = [];

  Future getDocId() async {
    await FirebaseFirestore.instance.collection('Users').get().then(
          (snapshot) => snapshot.docs.forEach((element) {
            print(element.reference);
            docIDs.add(element.reference.id);
          }),
        );
  }

  @override
  void initState() {
    getDocId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
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
                    String userPass = data['password'];

                    return ListTile(
                      title: Text(userText),
                      subtitle: Text(userPass),
                      trailing: IconButton(
                        onPressed: () {
                          firestoreService.updatePass(docID, "Sheesh");
                        },
                        icon: const Icon(Icons.settings_outlined),
                      ),
                    );
                  });
            } else {
              return const Text("nigga");
            }
          }),
    );
  }
}
