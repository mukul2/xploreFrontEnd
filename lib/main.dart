import 'package:admin/side.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AppProviders/DrawerProvider.dart';
import 'Questions_new.dart';
import 'Quizes.dart';
import 'all_questions.dart';
import 'all_quizes.dart';
import 'drawer.dart';
import 'firebase_options.dart';
import 'utils.dart';
import 'package:http/http.dart' as http;
Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return   MultiProvider(
        providers: [
    ChangeNotifierProvider<DrawerProviderProvider>(create: (context) => DrawerProviderProvider()),
    ChangeNotifierProvider<QuestionsSelectedProvider>(create: (context) => QuestionsSelectedProvider()),
    ChangeNotifierProvider<AddedProvider>(create: (context) => AddedProvider()),

        ],
      child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: 'Nexa',inputDecorationTheme: InputDecorationTheme( border:  OutlineInputBorder(
      // width: 0.0 produces a thin "hairline" border
      borderSide:  BorderSide(color:Colors.black.withOpacity(0.8), width: 0.5,),borderRadius: BorderRadius.circular(3),
      ),
        enabledBorder:  OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide:  BorderSide(color: Colors.black.withOpacity(0.8), width: 0.5),borderRadius: BorderRadius.circular(3),
        ),
        disabledBorder:   OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide:  BorderSide(color: Theme.of(context).primaryColor, width: 0.5),borderRadius: BorderRadius.circular(3),
        ),
        focusedBorder:    OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide:  BorderSide(color: Colors.blue, width:0.5),borderRadius: BorderRadius.circular(3),
        ),floatingLabelBehavior: FloatingLabelBehavior.always)),
      home:  SidebarXExampleApp(),
    ),);
  }
}


