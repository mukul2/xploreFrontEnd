import 'package:admin/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../AppProviders/DrawerProvider.dart';
import '../../Create_Quize/create_quize.dart';
import '../../course_table.dart';
import '../../create_question_activity.dart';
import '../../students_activity.dart';
import '../Questions/question.dart';
import '../Quize/teacher_quizes.dart';
import 'data.dart';

class TeacherDrawer extends StatefulWidget {
  const TeacherDrawer({super.key});

  @override
  State<TeacherDrawer> createState() => _TeacherDrawerState();
}

class _TeacherDrawerState extends State<TeacherDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 250,height: MediaQuery.of(context).size.height,decoration: BoxDecoration(color: Colors.white),child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Text("Project name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(FirebaseAuth.instance.currentUser!.email!,style: TextStyle(),),
            ),
            ListView.builder(
              itemCount: drawerDataTeacher.length,shrinkWrap: true,

              itemBuilder: (context, index) {
                return true?SingleMenu(data: drawerDataTeacher[index],position: index,): Column(children: [
                  InkWell(onHover: (bool b){

                  },child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(drawerDataTeacher[index]["name"]),
                  ),),
                ],);
              },
            ),
          ],
        ),),
        Container(height: MediaQuery.of(context).size.height,width: 1,color: Colors.grey.shade300,),
        Expanded(child: Consumer<DrawerSelectionSub>(
            builder: (_, bar, __) {
              if(bar.selection == 4 && bar.selectionsub == 0) return Wallet();
              if(bar.selection == 3 && bar.selectionsub == 0) return StudentActivitySql();
              if(bar.selection == 2 && bar.selectionsub == 0) return CreateCourseActivity();
              if(bar.selection == 2 && bar.selectionsub == 1) return CourseTable();
              if(bar.selection == 1 && bar.selectionsub == 0) return CreateQuize();
              if(bar.selection == 1 && bar.selectionsub == 1) return QuizesTable(scaffoldKey: GlobalKey<ScaffoldState>());
              if(bar.selection == 0 && bar.selectionsub == 0) return QuestionsActivitySQL();
              if(bar.selection == 0 && bar.selectionsub == 1) return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                child: Create_question(),
              );
              return Text(drawerDataTeacher[bar.selection]["sub"][bar.selectionsub]);
            })),
      ],
    ),);
  }
}
class SingleMenu extends StatefulWidget {
  Map<String,dynamic>data;
  int position;
  SingleMenu({required this.data,required this.position});
  @override
  State<SingleMenu> createState() => _SingleMenuState();
}

class _SingleMenuState extends State<SingleMenu> {
  bool onHover = false;
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    //DrawerSelection

    return  Consumer<DrawerSelection>(
      builder: (_, bar, __) =>Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [

        InkWell(onTap: (){
          if(widget.position == drawerDataTeacher.length - 1)FirebaseAuth.instance.signOut().then((value) {
            GoRouter.of(context).go("/");
          });


          bar.selection = widget.position;
          Provider.of<DrawerSelectionSub>(context, listen: false).selection = widget.position;
          Provider.of<DrawerSelectionSub>(context, listen: false).selectionsub = 0;

          if( bar.selection == widget.position){
            expanded = true;
          }else{
            expanded = false;
          }

        },onHover: (bool b){
          setState(() {
            onHover = b;
          });

        },child: Container(margin: EdgeInsets.symmetric(horizontal: 8,vertical: 5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color:onHover?Colors.blue.shade50:Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(widget.data["icon"]  ,color:  bar.selection == widget.position?Colors.blue:( Colors.black)),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Text(widget.data["name"],style: TextStyle(color:  bar.selection == widget.position?Colors.blue:( Colors.black)),),
                        ],
                      ),
                    ),
                  ],
                ),

                Icon(  bar.selection == widget.position?Icons.keyboard_arrow_down_outlined:Icons.keyboard_arrow_up_outlined,color: onHover?Colors.blue:Colors.black87),
              ],
            ),
          ),
        ),),
       if( bar.selection == widget.position) ListView.builder(padding: EdgeInsets.only(left: 15),
          itemCount: widget.data["sub"].length,shrinkWrap: true,

          itemBuilder: (context, index) {
            return true?SingleMenuSub(data:  widget.data["sub"][index],position: widget.position, positionsub: index,): Column(children: [
              InkWell(onHover: (bool b){

              },child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(drawerDataTeacher[index]["name"]),
              ),),
            ],);
          },
        )
      ],));
    return Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
      InkWell(onTap: (){
        setState(() {
          expanded = !expanded;
        });

      },onHover: (bool b){
        setState(() {
          onHover = b;
        });

      },child: Container(margin: EdgeInsets.all(5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: onHover?Colors.blue.shade50:Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(widget.data["icon"]  ,color: onHover?Colors.blue:Colors.black54),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(widget.data["name"],style: TextStyle(color: onHover?Colors.blue:Colors.black54),),
                  ),
                ],
              ),

              Icon( expanded?Icons.keyboard_arrow_down_outlined:Icons.keyboard_arrow_up_outlined,color: onHover?Colors.blue:Colors.black87),
            ],
          ),
        ),
      ),),
    ],);
  }
}



class SingleMenuSub extends StatefulWidget {
  String data;
  int position;
  int positionsub;
  SingleMenuSub({required this.data,required this.position,required this.positionsub});
  @override
  State<SingleMenuSub> createState() => _SingleMenuSubState();
}

class _SingleMenuSubState extends State<SingleMenuSub> {
  bool onHover = false;
 // bool expanded = false;
  @override
  Widget build(BuildContext context) {
    //DrawerSelection

    return  Consumer<DrawerSelectionSub>(
        builder: (_, bar, __) =>Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [

          InkWell(onTap: (){
          bar.selectionsub = widget.positionsub;


            // if( bar.selectionsub == widget.position){
            //   expanded = true;
            // }else{
            //   expanded = false;
            // }

          },onHover: (bool b){
            setState(() {
              onHover = b;
            });

          },child: Container(margin: EdgeInsets.symmetric(horizontal: 8,vertical: 5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color:(bar.selection == widget.position &&  bar.selectionsub == widget.positionsub )?Colors.blue.shade50 :( onHover?Colors.blue.shade50:Colors.transparent)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("-",style: TextStyle(color: (bar.selection == widget.position &&  bar.selectionsub == widget.positionsub ) ?Colors.blue:( Colors.black54))),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(widget.data,style: TextStyle(color: (bar.selection == widget.position &&  bar.selectionsub == widget.positionsub ) ?Colors.blue:( Colors.black54)),),
                      ),
                    ],
                  ),

                 // Icon( expanded?Icons.keyboard_arrow_down_outlined:Icons.keyboard_arrow_up_outlined,color: onHover?Colors.blue:Colors.black87),
                ],
              ),
            ),
          ),),

        ],));
  }
}