import 'package:admin/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../AppProviders/DrawerProvider.dart';
import '../../Create_Quize/create_quize.dart';
import '../../RestApi.dart';
import '../../course_table.dart';
import '../../create_question_activity.dart';
import '../../students_activity.dart';
import '../Chapters/chapters.dart';
import '../Classes/classes.dart';
import '../Students/students.dart';
import '../Subject/subjects.dart';
import '../Teachers/teachers.dart';
import 'data.dart';


class AdminDrawer extends StatefulWidget {
  const AdminDrawer({super.key});

  @override
  State<AdminDrawer> createState() => _TeacherDrawerState();
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
class _TeacherDrawerState extends State<AdminDrawer> {
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
              itemCount: drawerDataAdmin.length,shrinkWrap: true,

              itemBuilder: (context, index) {
                return true?SingleMenu(data: drawerDataAdmin[index],position: index,): Column(children: [
                  InkWell(onHover: (bool b){

                  },child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(drawerDataAdmin[index]["name"]),
                  ),),
                ],);
              },
            ),
          ],
        ),),
        Container(height: MediaQuery.of(context).size.height,width: 1,color: Colors.grey.shade300,),
        Expanded(child: Consumer<DrawerSelectionSub>(
            builder: (_, bar, __) {

            if(bar.selection == 0 && bar.selectionsub == 0) return Teachers();
            if(bar.selection == 1 && bar.selectionsub == 0) return AllStudents();
            if(bar.selection == 2 && bar.selectionsub == 0) return AllClasses();
            if(bar.selection == 2 && bar.selectionsub == 1) return CreateClassW();
            if(bar.selection == 3 && bar.selectionsub == 0) return AllSubjects();
            if(bar.selection == 3 && bar.selectionsub == 1) return CreateSubjectw();
            if(bar.selection == 4 && bar.selectionsub == 0) return AllChapters();
            if(bar.selection == 4 && bar.selectionsub ==1) return CreateChapterW();
              return Text(drawerDataAdmin[bar.selection]["sub"][bar.selectionsub]);
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
            if(widget.position == drawerDataAdmin.length - 1)FirebaseAuth.instance.signOut().then((value) {
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
                      Icon(widget.data["icon"]  ,color:  bar.selection == widget.position?Colors.blue:( Colors.black54)),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            Text(widget.data["name"],style: TextStyle(color:  bar.selection == widget.position?Colors.blue:( Colors.black54)),),
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
                  child: Text(drawerDataAdmin[index]["name"]),
                ),),
              ],);
            },
          )
        ],));
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

class CreateClassW extends StatefulWidget {
  const CreateClassW({super.key});

  @override
  State<CreateClassW> createState() => _CreateClassWState();
}

class _CreateClassWState extends State<CreateClassW> {
  TextEditingController c = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Container(margin: EdgeInsets.all(10),
      child: Scaffold(backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
          Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(controller:c ,decoration: InputDecoration(hintText: "Class name"),)),
            ElevatedButton(onPressed: (){

              Data().saveClasses(data: {"name":c.text,"created_by":FirebaseAuth.instance.currentUser==null?null:FirebaseAuth.instance.currentUser!.uid}).then((value) {
                Provider.of<DrawerSelectionSub>(context, listen: false).selection = 2;
                Provider.of<DrawerSelectionSub>(context, listen: false).selectionsub = 0;
              });



            }, child: Text("Create Class")),

          ],),
        ),
      ),
    );
  }
}
class CreateSubjectw extends StatelessWidget {
  const CreateSubjectw({super.key});

  @override
  Widget build(BuildContext context) {
    String selectedClassId ="";
    TextEditingController c = TextEditingController();
    return  Container(width: 500,color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClassSelectDropdown(onSelected: (String id){

                  selectedClassId = id;
                },),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(controller:c ,decoration: InputDecoration(hintText: "Subject"),),
              ),
              Center(
                child: ElevatedButton(onPressed: (){

                  Data().saveSubjects(data: {"class_id":selectedClassId,"name":c.text,}).then((value) {
                    Provider.of<DrawerSelectionSub>(context, listen: false).selection = 3;
                    Provider.of<DrawerSelectionSub>(context, listen: false).selectionsub = 0;

                  });



                }, child: Text("Create Class")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class CreateChapterW extends StatelessWidget {
  const CreateChapterW({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController c = TextEditingController();
    String selectedClassId= "";
    String selectedSubjectID= "";
    return Container(width: 500,color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(controller:c ,decoration: InputDecoration(hintText: "Class Chapter"),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClassSelectDropdown(onSelected: (String id){

                selectedClassId = id;
              },),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SubjectSelectDropdown(onSelected: (String id){

                selectedSubjectID = id;
              },),
            ),
            ElevatedButton(onPressed: (){

              Data().saveChapters(data: {"subject_id":selectedSubjectID,"class_id":selectedClassId,"name":c.text,}).then((value) {
                Provider.of<DrawerSelectionSub>(context, listen: false).selection = 4;
                Provider.of<DrawerSelectionSub>(context, listen: false).selectionsub = 0;

              });



            }, child: Text("Create Chapter"))

          ],
        ),
      ),
    );
  }
}
