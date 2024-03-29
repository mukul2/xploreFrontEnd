import 'package:admin/courses.dart';
import 'package:admin/sql_questions.dart';
import 'package:admin/student_activity.dart';
import 'package:admin/students.dart';
import 'package:admin/students_activity.dart';
import 'package:admin/styles.dart';
import 'package:admin/subject_activity.dart';
import 'package:admin/sync_data_table.dart';
import 'package:admin/tab_questions.dart';
import 'package:admin/tab_quiz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidebarx/sidebarx.dart';
import 'Quizes.dart';
import 'RestApi.dart';
import 'Student/Courses/course.dart';
import 'chapter_activity.dart';
import 'class_activity.dart';
import 'course_table.dart';
import 'login.dart';
import 'my_quizes.dart';
import 'utils.dart';
import 'Questions_new.dart';
import 'all_questions.dart';

void main() {
  runApp(StudentApp());
}

class StudentApp extends StatefulWidget {
  StudentApp({Key? key}) : super(key: key);

  @override
  State<StudentApp> createState() => _SidebarXExampleAppState();
}

class _SidebarXExampleAppState extends State<StudentApp> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  final _key = GlobalKey<ScaffoldState>();

  bool loggedIn = false;
  @override
  void initState() {
    // TODO: implement initState
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
        return SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(FirebaseAuth.instance.currentUser!.email!,style: TextStyle(fontSize: 16,color: Colors.white),),
          ),
        );
      },
      items: [

        const SidebarXItem(
          icon: Icons.quiz,
          label: 'Quiz',
        ),
        const SidebarXItem(
          icon: Icons.book,
          label: 'Courses',
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
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(controller.selectedIndex);
        switch (controller.selectedIndex) {
          case 0:
            return true?MyQuizes(): Questions_All(type: questionbank.type1,);
            case 1:
            return CoursesStudent();
          case 2:
            return  CourseTable();
          case 3:
            return  StudentActivitySql();
          case 4:
            return  ClassActivity();
            case 5:
          return  SubjectActivity();
          case 6:
            return  ChapterActivity();
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


class QuizesStudent extends StatefulWidget {
  const QuizesStudent({Key? key}) : super(key: key);

  @override
  State<QuizesStudent> createState() => _QuizesStudentState();
}

class _QuizesStudentState extends State<QuizesStudent> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyDataPurchasedQuizes extends DataTableSource {
  MyDataPurchasedQuizes(this._data);
  final List<dynamic> _data;

  List selected_quiz = [];
  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {


    return DataRow(cells: [
      DataCell(Text(_data[index]['quize']??"-")),

      DataCell(ElevatedButton(onPressed: (){},child: Text("Start Exam"),)),


      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}

