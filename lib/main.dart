import 'package:flutter/material.dart';
import 'package:get_it_done/screens/dashboard.dart';

import 'databaseHelper/localDatabase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalDatabaseHelper.connect();
  await LocalDatabaseHelper().printUsersTable();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // theme: ThemeData.dark(),
      home: DashBoard(),
    );
  }
}
