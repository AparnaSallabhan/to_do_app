// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/controller/home_screen_controller.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/view/home_screen/home_screen.dart';
import 'package:to_do_app/view/splash_screen/spalsh_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  var box = await Hive.openBox<TaskModel>("taskBox");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeScreenController(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SpalshScreen(),
      ),
    );
  }
}
