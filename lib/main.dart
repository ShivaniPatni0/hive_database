import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_database/home_screen.dart';
import 'package:hive_database/models/note_model.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // String path = "/assets/db";
    Hive.registerAdapter(NotesModelAdapter());
    await Hive.openBox<NotesModel>('notes');
  } else {
    var directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(NotesModelAdapter());
    await Hive.openBox<NotesModel>('notes');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}
