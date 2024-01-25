import 'package:admin/side.dart';
import 'package:admin/student_side.dart';
import 'package:admin/styles.dart';
import 'package:admin/teacher_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Admin/Drawer/drawer.dart';
import 'Admin/Students/students.dart';
import 'Admin/Teachers/teachers.dart';
import 'AppProviders/DrawerProvider.dart';
import 'Create_Quize/create_quize.dart';
import 'Questions_new.dart';
import 'Quizes.dart';
import 'RestApi.dart';
import 'Admin/admin_page.dart';
import 'Student/Courses/Market/market_place.dart';
import 'Student/Drawer/Drawer.dart';
import 'Student/ExamHall/take_exam.dart';
import 'Student/Lecture/lectures.dart';
import 'Teacher/Drawer/drawer.dart';
import 'all_questions.dart';
import 'all_quizes.dart';
import 'course_details.dart';
import 'drawer.dart';
import 'firebase_options.dart';
import 'login.dart';
import 'utils.dart';
import 'package:http/http.dart' as http;
Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return FirebaseAuth.instance.currentUser==null?Login():   FutureBuilder<dynamic>(
            future: Data().userInfo(id:FirebaseAuth.instance.currentUser!.uid), // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.hasData){
                try{
                  if(snapshot.data!["isTeacher"]) {

                    return true?TeacherDrawer():SidebarXExampleApp();

                  }else
                  if(snapshot.data!["isStudent"]) {
                    return StudentApp();
                  }else{
                    return Text("Unknwon user");
                  }

                }catch(e){
                  return Login();
                }

              }else{
                return Login();
              }

            });

      },
      routes: <RouteBase>[
        GoRoute(
          path: 'home/create-quize',
          builder: (BuildContext context, GoRouterState state) {
            return SidebarXExampleApp(tab: 1,);

          },
        ),
        GoRoute(
          path: 'create-quize',
          builder: (BuildContext context, GoRouterState state) {
            return CreateQuize();

          },
        ),
        GoRoute(
          path: 'admin/students',
          builder: (BuildContext context, GoRouterState state) {
            return AllStudents();

          },
        ),

        GoRoute(
          path: 'admin/teachers',
          builder: (BuildContext context, GoRouterState state) {
            return Teachers();

          },
        ),
        GoRoute(
          path: 'admin',
          builder: (BuildContext context, GoRouterState state) {
            return FirebaseAuth.instance.currentUser==null?AdminDrawer(): AdminDrawer();
            return StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(), // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                  return FirebaseAuth.instance.currentUser==null?Login():   SidebarXExampleApp();
                });
          },
        ),
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return FirebaseAuth.instance.currentUser==null?Login():  FutureBuilder<dynamic>(
                future: Data().userInfo(id:FirebaseAuth.instance.currentUser!.uid), // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.hasData){
                    try{
                      if(snapshot.data!["isTeacher"]) {

                        return true?TeacherDrawer(): SidebarXExampleApp();

                      }else if(snapshot.data!["isStudent"]) {

                        return StudentDrawer();
                        return StudentApp();
                      }else{
                        return Text("Unknwon user");
                      }

                    }catch(e){
                      return Login();
                    }

                  }else{
                    return Login();
                  }

                });
            return StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(), // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                  return FirebaseAuth.instance.currentUser==null?Login():   SidebarXExampleApp();
                });
          },
        ),
        GoRoute(
          path: 'shome',
          builder: (BuildContext context, GoRouterState state) {
            return FirebaseAuth.instance.currentUser==null?Login():  FutureBuilder<dynamic>(
                future: Data().userInfo(id:FirebaseAuth.instance.currentUser!.uid), // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.hasData){
                    try{
                      if(snapshot.data!["isTeacher"]) {
                        return TeacherDrawer();
                        return Center(child: CircularProgressIndicator(),);

                      }else
                      if(snapshot.data!["isStudent"]) {
                        return StudentDrawer();
                        return StudentApp();
                      }else{
                        return Text("Unknwon user");
                      }

                    }catch(e){
                      return Login();
                    }

                  }else{
                    return Login();
                  }

                });
          },
        ),
        GoRoute(
          path: 'take-exam/:id',
          builder: (BuildContext context, GoRouterState state) {
            return TakeExam(id:state.pathParameters['id']!);
          },
        ),
        GoRoute(
          path: 'signup',
          builder: (BuildContext context, GoRouterState state) {
            return TeacherSignup();
          },
        ),
        GoRoute(
          path: 'courses/:id',
          builder: (BuildContext context, GoRouterState state) {
            return CoursesMarketPlace( id:state.pathParameters['id']!,);
          },
        ),
        GoRoute(
          path: 'lectures/:id',
          builder: (BuildContext context, GoRouterState state) {
            return Lectures( id:int.parse(state.pathParameters['id']!),);
          },
        ),
        GoRoute(
          path: 'course-details/:id',
          builder: (BuildContext context, GoRouterState state) {
            return CourseDetails( id:int.parse(state.pathParameters['id']!),);
          },
        ),
        GoRoute(
          path: 'student-registration',
          builder: (BuildContext context, GoRouterState state) {
            return StudentSignup();
          },
        ),
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return Login();
          },
        ),
        GoRoute(
          path: 'drawer',
          builder: (BuildContext context, GoRouterState state) {
            return TeacherDrawer();
          },
        ),
      ],
    ),
  ],
);

/// The main app.
class MyApp2 extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    var baseTheme = ThemeData();
    return   MultiProvider(
        providers: [
    ChangeNotifierProvider<DrawerProviderProvider>(create: (context) => DrawerProviderProvider()),
    ChangeNotifierProvider<QuestionsSelectedProvider>(create: (context) => QuestionsSelectedProvider()),
    ChangeNotifierProvider<AddedProvider>(create: (context) => AddedProvider()),
    ChangeNotifierProvider<AddedProviderOnlyNew>(create: (context) => AddedProviderOnlyNew()),
    ChangeNotifierProvider<Batchprovider>(create: (context) => Batchprovider()),
    ChangeNotifierProvider<Classprovider>(create: (context) => Classprovider()),
    ChangeNotifierProvider<Studentsprovider>(create: (context) => Studentsprovider()),
    ChangeNotifierProvider<Quizessprovider>(create: (context) => Quizessprovider()),
    ChangeNotifierProvider<Questionsprovider>(create: (context) => Questionsprovider()),
    ChangeNotifierProvider<Subjectsprovider>(create: (context) => Subjectsprovider()),
    ChangeNotifierProvider<Chapterprovider>(create: (context) => Chapterprovider()),
    ChangeNotifierProvider<QuestionSortsprovider>(create: (context) => QuestionSortsprovider()),
    ChangeNotifierProvider<Questionprovider>(create: (context) => Questionprovider()),
    ChangeNotifierProvider<AppRouter>(create: (context) => AppRouter()),
    ChangeNotifierProvider<CurrentLesson>(create: (context) => CurrentLesson()),
    ChangeNotifierProvider<DrawerSelection>(create: (context) => DrawerSelection()),
    ChangeNotifierProvider<DrawerSelectionSub>(create: (context) => DrawerSelectionSub()),

        ],
      child: MaterialApp.router(
      title: 'Flutter Demo',
      theme: true?ThemeData(

          visualDensity: VisualDensity.adaptivePlatformDensity,
          cardColor: Colors.white,appBarTheme: AppBarTheme(surfaceTintColor: Colors.white,
          elevation: 10,
          color: Colors.white),

          elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(elevation: 5,
            primary: Colors.green,
            onPrimary: Colors.white,
            onSurface: Colors.grey,
            textStyle: styleNormal.copyWith(
              // fontSize: 20,
              // fontWeight: FontWeight.bold,
            ),
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          )),
          dialogTheme: DialogTheme(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
              backgroundColor: Colors.white,surfaceTintColor: Colors.white),
          // textTheme: GoogleFonts.poppinsTextTheme(),
          fontFamily: "Nexa",
          scaffoldBackgroundColor: Colors.grey.shade100 ,cardTheme: CardTheme(color: Colors.white,surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
          // textTheme: GoogleFonts.redHatDisplayTextTheme(textTheme).copyWith(
          //   bodyLarge: GoogleFonts.redHatDisplay(textStyle: textTheme.bodyLarge!.copyWith(color: Colors.black)),
          //   bodyMedium: GoogleFonts.redHatDisplay(textStyle: textTheme.bodyMedium!.copyWith(color: Colors.black)),
          //   bodySmall: GoogleFonts.redHatDisplay(textStyle: textTheme.bodySmall!.copyWith(color: Colors.black)),
          // ),
          //  textTheme:  GoogleFonts.montserratAlternatesTextTheme(),
          //textTheme:  GoogleFonts.redHatDisplayTextTheme(),
          //   fontFamily: 'Nexa',
          // textTheme: Typography.blackCupertino.apply(fontSizeFactor: 1.spMin ),


          dropdownMenuTheme: DropdownMenuThemeData(inputDecorationTheme: InputDecorationTheme(
              border:  OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide:  BorderSide(color:Colors.black.withOpacity(0.8), width: 0.4,),borderRadius: BorderRadius.circular(6),
              ),
              enabledBorder:  OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide:  BorderSide(color:Colors.black.withOpacity(0.8), width: 0.4,),borderRadius: BorderRadius.circular(6),
              ),
              focusedBorder:  OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide:  BorderSide(color:Colors.black.withOpacity(0.8), width: 1,),borderRadius: BorderRadius.circular(6),
              ),

              constraints: BoxConstraints.tight(const Size.fromHeight(40)),
              isDense: true,fillColor: Colors.grey.shade50,filled: true)

          ),
          inputDecorationTheme: true?InputDecorationTheme(floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
              //  fillColor: Colors.white,
              //  filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),isDense: true,
              constraints: BoxConstraints.tight(const Size.fromHeight(40)),
              //  labelStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),

              border:  OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide:  BorderSide(color:Colors.black.withOpacity(0.3), width: 0.2,),borderRadius: BorderRadius.circular(6),
              ),
              fillColor: Colors.grey.shade100,filled: true,

              enabledBorder:  OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide:  BorderSide(color: Colors.black.withOpacity(0.3), width: 0.2),borderRadius: BorderRadius.circular(6),
              ),
              disabledBorder:   OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide:  BorderSide(color: Colors.black.withOpacity(0.3), width: 0.2),borderRadius: BorderRadius.circular(6),
              ),
              focusedBorder:    OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide:  BorderSide(color: Color.fromARGB(255,0, 8, 255), width:2),borderRadius: BorderRadius.circular(8),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always): InputDecorationTheme(fillColor: Colors.white,filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 0),
              labelStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),border:  OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide:  BorderSide(color:Colors.black.withOpacity(0.4), width: 0.5,),borderRadius: BorderRadius.circular(3),
              ),
              enabledBorder:  OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide:  BorderSide(color: Colors.black.withOpacity(0.4), width: 0.5),borderRadius: BorderRadius.circular(3),
              ),
              disabledBorder:   OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide:  BorderSide(color: Colors.grey, width: 0.5),borderRadius: BorderRadius.circular(3),
              ),
              focusedBorder:    OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide:  BorderSide(color: Color.fromARGB(255,0, 8, 255), width:0.5),borderRadius: BorderRadius.circular(3),
              ),floatingLabelBehavior: FloatingLabelBehavior.always),

          primaryColor: Color.fromARGB(255,0, 8, 255),
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255,0, 8, 255)),useMaterial3: true
        // useMaterial3: true,
      ): ThemeData( fontFamily: "Inter",  cardTheme: CardTheme(color: Colors.white,
        elevation: 3, // remove shadow
        margin: const EdgeInsets.all(0), // reset margin
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // Change radius
        ),
      ),
         // textTheme:  GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
          scaffoldBackgroundColor: Colors.grey.shade300,dialogBackgroundColor: Colors.grey.shade300,dialogTheme: DialogTheme(backgroundColor: Colors.grey.shade300),
          appBarTheme: AppBarTheme(elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),titleTextStyle: TextStyle(color: Colors.black54),
        color: Colors.white, //<-- SEE HERE
      ),
        //  fontFamily: 'Nexa',
          inputDecorationTheme: InputDecorationTheme(fillColor: Colors.grey.shade50,filled: true,contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 8), labelStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),border:  OutlineInputBorder(
      // width: 0.0 produces a thin "hairline" border
      borderSide:  BorderSide(color:Colors.black.withOpacity(0.4), width: 0.5,),borderRadius: BorderRadius.circular(3),
      ),
        enabledBorder:  OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide:  BorderSide(color: Colors.black.withOpacity(0.4), width: 0.5),borderRadius: BorderRadius.circular(3),
        ),
        disabledBorder:   OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide:  BorderSide(color: Theme.of(context).primaryColor, width: 0.5),borderRadius: BorderRadius.circular(3),
        ),
        focusedBorder:    OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide:  BorderSide(color: Colors.blue, width:0.5),borderRadius: BorderRadius.circular(3),
        ),floatingLabelBehavior: FloatingLabelBehavior.always)),
        routerConfig: _router,
      //  home:  SidebarXExampleApp(),
    ),);
  }
}


