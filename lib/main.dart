import 'package:admin/side.dart';
import 'package:admin/student_side.dart';
import 'package:admin/teacher_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'AppProviders/DrawerProvider.dart';
import 'Questions_new.dart';
import 'Quizes.dart';
import 'RestApi.dart';
import 'all_questions.dart';
import 'all_quizes.dart';
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

                    return SidebarXExampleApp();

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
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return FirebaseAuth.instance.currentUser==null?Login():  FutureBuilder<dynamic>(
                future: Data().userInfo(id:FirebaseAuth.instance.currentUser!.uid), // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.hasData){
                    try{
                      if(snapshot.data!["isTeacher"]) {

                        return SidebarXExampleApp();

                      }else if(snapshot.data!["isStudent"]) {

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
                        return SidebarXExampleApp();
                        return Center(child: CircularProgressIndicator(),);

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
        ),
        GoRoute(
          path: 'signup',
          builder: (BuildContext context, GoRouterState state) {
            return TeacherSignup();
          },
        ),   GoRoute(
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

        ],
      child: MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData( dialogBackgroundColor: Colors.grey.shade50,dialogTheme: DialogTheme(backgroundColor: Colors.grey.shade50),appBarTheme: AppBarTheme(elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        color: Colors.white, //<-- SEE HERE
      ),fontFamily: 'Nexa',inputDecorationTheme: InputDecorationTheme(fillColor: Colors.grey.shade50,filled: true,contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 8), labelStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),border:  OutlineInputBorder(
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
        routerConfig: _router,
      //  home:  SidebarXExampleApp(),
    ),);
  }
}


