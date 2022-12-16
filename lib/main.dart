import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pretest_md_pai/loading.dart';
import 'package:pretest_md_pai/todo_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text(snapshot.error.toString()),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Loading(),
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.grey[900],
              primarySwatch: Colors.blue,
            ),
            home: TodoList(),
          );
        });
  }
}
