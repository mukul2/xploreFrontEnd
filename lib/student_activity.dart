import 'package:admin/students.dart';
import 'package:flutter/material.dart';

class StudentActivity extends StatefulWidget {

  StudentActivity();

  @override
  State<StudentActivity> createState() => _StudentActivityState();
}

class _StudentActivityState extends State<StudentActivity> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(key: scaffoldKey,body: Students(scaffoldKey),);
  }
}
