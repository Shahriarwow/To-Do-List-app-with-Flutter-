import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/data/data.dart';
import 'package:to_do_list/data/repo/repository.dart';
import 'package:to_do_list/data/source/hive_task_source.dart';

import 'package:to_do_list/screens/home/home.dart';

const taskBoxName = 'tasks';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<Task>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: primaryVariantColor));

  runApp(ChangeNotifierProvider<Repository<Task>>(
      create: (context) =>
          Repository<Task>(HiveTaskSource(Hive.box(taskBoxName))),
      child: const MyApp()));
}

const Color primaryColor = Color(0xff794CFF);
const Color primaryVariantColor = Color(0xff5C0AFF);
const secendaryTextColor = Color(0xffAFBED0);
const normalPeriority = Color(0xffF09819);
const lowPeriority = Color(0xff3BE1F1);
const hightPriority = primaryColor;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final primaryTextColor = Color(0xff1D2830);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
              headline6: TextStyle(fontWeight: FontWeight.bold))),
          inputDecorationTheme: const InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: TextStyle(color: secendaryTextColor),
              iconColor: secendaryTextColor,
              border: InputBorder.none),
          colorScheme: ColorScheme.light(
            primary: primaryColor,
            primaryVariant: primaryVariantColor,
            background: const Color(0xffF3F5F8),
            onSurface: primaryTextColor,
            onBackground: primaryTextColor,
            onPrimary: Colors.white,
            secondary: primaryColor,
            onSecondary: Colors.white,
          )),
      home: HomeScreen(),
    );
  }
}
