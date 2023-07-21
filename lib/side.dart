import 'dart:html';

import 'package:admin/courses.dart';
import 'package:admin/quizes_table.dart';
import 'package:admin/sql_questions.dart';
import 'package:admin/student_activity.dart';
import 'package:admin/students.dart';
import 'package:admin/students_activity.dart';
import 'package:admin/subject_activity.dart';
import 'package:admin/tab_questions.dart';
import 'package:admin/tab_quiz.dart';
import 'package:admin/table_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';
import 'AppProviders/DrawerProvider.dart';
import 'Create_Quize/create_quize.dart';
import 'Quizes.dart';
import 'Teacher/Questions/question.dart';
import 'Teacher/Quize/teacher_quizes.dart';
import 'chapter_activity.dart';
import 'class_activity.dart';
import 'course_table.dart';
import 'data_sources.dart';
import 'login.dart';
import 'utils.dart';
import 'Questions_new.dart';
import 'all_questions.dart';

void main() {
  runApp(SidebarXExampleApp());
}

class SidebarXExampleApp extends StatefulWidget {
  int? tab;
  SidebarXExampleApp({this.tab});

  @override
  State<SidebarXExampleApp> createState() => _SidebarXExampleAppState();
}

class _SidebarXExampleAppState extends State<SidebarXExampleApp> {


  final _controller = SidebarXController(selectedIndex: 0, extended: true);


  final _key = GlobalKey<ScaffoldState>();

  bool loggedIn = false;
  @override
  void initState() {
    // TODO: implement initState

    if(widget.tab==null){

    }else{
      _controller.selectIndex(1);
    }
    super.initState();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        setState(() {
          loggedIn = false;
        });
        print('User is currently signed out!');
      } else {

        setState(() {
          loggedIn = true;

        });

        // FirebaseFirestore.instance.collection("mmu-users").where("uid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get().then((value) {
        //
        //   try{
        //     if(value.docs.first.get("type")=="admin"){
        //       setState(() {
        //         loggedIn = true;
        //
        //       });
        //
        //     }
        //   }catch(e){
        //
        //   }
        // });
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return true? Builder(
      builder: (context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        return Scaffold(
          key: _key,
          appBar: isSmallScreen
              ? AppBar(
            backgroundColor: canvasColor,
            title: Text(_getTitleByIndex(_controller.selectedIndex)),
            leading: IconButton(
              onPressed: () {
                // if (!Platform.isAndroid && !Platform.isIOS) {
                //   _controller.setExtended(true);
                // }
                _key.currentState?.openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
          )
              : null,
          drawer: ExampleSidebarX(controller: _controller),
          body: Row(
            children: [
              if (!isSmallScreen) ExampleSidebarX(controller: _controller),
              Expanded(
                child: Center(
                  child: _ScreensExample(
                    controller: _controller,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ):Login();
  }
}

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {

   // _controller.selectIndex(0);
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 250,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return FirebaseAuth.instance.currentUser ==null?Container():SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(FirebaseAuth.instance.currentUser!.email!,style: TextStyle(fontSize: 16,color: Colors.white),),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.question_mark,
          label: 'Questions',
          onTap: () {
            debugPrint('Home');
          },
        ),
        const SidebarXItem(
          icon: Icons.quiz,
          label: 'Quiz',
        ),
        const SidebarXItem(
          icon: Icons.book,
          label: 'Courses',
        ),
        const SidebarXItem(
          icon: Icons.supervised_user_circle_outlined,
          label: 'Students',
        ),
        // const SidebarXItem(
        //   icon: Icons.supervised_user_circle_outlined,
        //   label: 'Class',
        // ),
        // const SidebarXItem(
        //   icon: Icons.supervised_user_circle_outlined,
        //   label: 'Subject',
        // ),
        // const SidebarXItem(
        //   icon: Icons.supervised_user_circle_outlined,
        //   label: 'Chapters',
        // ),
        const SidebarXItem(
          icon: Icons.supervised_user_circle_outlined,
          label: 'Wallet',
        ),
         SidebarXItem(
          icon: Icons.logout,
          label: 'Logout',onTap: (){
            FirebaseAuth.instance.signOut().then((value) {
              GoRouter.of(context).go("/");

            });
         },
        ),

      ],
    );
  }
}

class _ScreensExample extends StatelessWidget {
  const _ScreensExample({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //AppRouter

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(controller.selectedIndex);
        switch (controller.selectedIndex) {
          case 0:
            return true? QuestionsActivitySQL(): Questions_All(type: questionbank.type1,);
            case 1:
              GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
            return  (window.location.href).contains("create-quize")?CreateQuize():  true?QuizesTable(scaffoldKey: scaffoldKey,):QuizFromFirebase();
          case 2:
            return  CourseTable();
          case 3:
            return  StudentActivitySql();
          // case 4:
          //   return  ClassActivity();
          //   case 5:
          // return  SubjectActivity();
          // case 6:
          //   return  ChapterActivity();
          case 4:
            return  Wallet();
          default:
            return Text(
              pageTitle,
              style: theme.textTheme.headlineSmall,
            );
        }
      },
    );
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Questions';
    case 1:
      return 'Search';
    case 2:
      return 'People';
    case 3:
      return 'Favorites';
    case 4:
      return 'Custom iconWidget';
    case 5:
      return 'Profile';
    case 6:
      return 'Settings';
    default:
      return 'Not found page';
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);


