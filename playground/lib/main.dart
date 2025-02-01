import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Test App"),
        ),
        body: Center(
          child: FutureBuilder(
            future: _getResponse(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print("error");
                print(snapshot.error.toString());
                return const Text("Error!");
              } else if (snapshot.hasData) {
                print("no error");
                return Text(snapshot.data["quote"]!);
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Future _getResponse() async {
    final result = await http.get(Uri.parse("https://api.kanye.rest/"));
    final message = jsonDecode(result.body);
    print(message);

    return message;
  }
}
