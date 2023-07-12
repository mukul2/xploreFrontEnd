import 'dart:html';

import 'package:admin/students_activity.dart';
import 'package:admin/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:provider/provider.dart';

import 'AppProviders/DrawerProvider.dart';
import 'RestApi.dart';
import 'edit_question_activity.dart';

class CourseTable extends StatefulWidget {
 // GlobalKey<ScaffoldState> scaffoldKey;
  //CourseTable({required this.scaffoldKey});
  CourseTable();
  @override
  State<CourseTable> createState() => _StudentsState();
}
// The "soruce" of the table
class MyData extends DataTableSource {
  MyData(this._data);
 // GlobalKey<ScaffoldState> key;
  final List<dynamic> _data;


  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {


    return DataRow(cells: [
      DataCell(Text(_data[index]['name']??"--")),
      DataCell(Text(_data[index]['description']??"--")),
      DataCell(Text(_data[index]['price'].toString()??"--")),
      DataCell(Text(_data[index]['lectures'][0]["lnum"].toString()??"--")),



      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}


class _StudentsState extends State<CourseTable> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(FirebaseAuth.instance.currentUser==null){

    }else{
      Data().batchesid(id: FirebaseAuth.instance.currentUser!.uid).then((value) {
        Provider.of<Batchprovider>(context, listen: false).items = value;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    Widget actions = Row(children: [
      TextButton(onPressed: (){}, child: Text("Create Batch"))
    ],);
//Batchprovider
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size(0,50),child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          ElevatedButton(onPressed: (){



            showDialog(
                context: context,
                builder: (_) =>AlertDialog(backgroundColor: Colors.grey.shade50,title: Text("Create Course"),content: Container(width: 1200,
                  child:CreateCourseActivity() ,
                ),));

          }, child: Text("Create Course"))
        ],),
      ),),
      body: true?Consumer<Batchprovider>(
        builder: (_, bar, __) {

          if(bar.items.isEmpty)return Center(child: Text("No data"),);
          //return Text(bar.items.toString());

          int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
          final DataTableSource _allUsers = MyData(bar.items);
          return SingleChildScrollView(
            child: PaginatedDataTable(

              header:null,
              rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

              columns: const [
                DataColumn(label: Text('Course Name',style: TextStyle(color: Colors.blue),)),
                DataColumn(label: Text('Description',style: TextStyle(color: Colors.blue),)),
                DataColumn(label: Text('Price',style: TextStyle(color: Colors.blue),)),
                DataColumn(label: Text('Total Lectures',style: TextStyle(color: Colors.blue),)),

                // DataColumn(label: Text('Id')),
                // DataColumn(label: Text('Phone'))
              ],
              source: _allUsers,
            ),
          );

        },
      ): FutureBuilder(

          future:Data().batches(),
          builder: (context, AsyncSnapshot<List> snap) {
            if(snap.hasData && snap.data!.length>0){

              int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
              final DataTableSource _allUsers = MyData(snap.data!);
              return SingleChildScrollView(
                child: PaginatedDataTable(

                  header:null,
                 rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

                  columns: const [
                    DataColumn(label: Text('Name')),

                    // DataColumn(label: Text('Id')),
                    // DataColumn(label: Text('Phone'))
                  ],
                  source: _allUsers,
                ),
              );
            }else{

              return Center(child: Text("No data"),);
            }

          }),
    );

    return  Scaffold(
      body: StreamBuilder(

          stream:FirebaseFirestore.instance.collection('courses').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snap) {


            if(snap.hasData){
              final DataTableSource _allUsers = MyData(snap.data!.docs);
              int n =( ( MediaQuery.of(context).size.height - 100 ) / 55 ).toInt() ;
              return SingleChildScrollView(
                child: PaginatedDataTable(
                  header: null,
                  rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,
                  columns: const [
                    DataColumn(label: Text('Batch name')),
                     DataColumn(label: Text('Number of students')),
                     DataColumn(label: Text('Total apply')),

                    // DataColumn(label: Text('Id')),
                    // DataColumn(label: Text('Phone'))
                  ],
                  source: _allUsers,
                ),
              );
            }
            else{
              return new Text('No data...');
            }
          }),
    );



  }
}
class CreateCourseActivity extends StatefulWidget {
  const CreateCourseActivity({super.key});

  @override
  State<CreateCourseActivity> createState() => _CreateCourseActivityState();
}

class _CreateCourseActivityState extends State<CreateCourseActivity> {
  TextEditingController c = TextEditingController();
  TextEditingController c_description = TextEditingController();
  TextEditingController c_price = TextEditingController();
  String? class_id;
  String? subject_id;
  List lectures = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(decoration: boxShadow,width: 590,margin: EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(controller:c ,decoration: InputDecoration(hintText: "Course name"),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(controller:c_description ,decoration: InputDecoration(hintText: "Description"),),
                    ),  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(controller:c_price ,decoration: InputDecoration(hintText: "Price"),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      child: ClassSelectDropdown(onSelected: (String id){
                        class_id = id;
                        // selectedClassId = id;
                      },),
                    ) ,Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SubjectSelectDropdown(onSelected: (String id){
                        subject_id = id;

                        // selectedClassId = id;
                      },),
                    )

                  ],
                ),
              ),
            ),
            Container(width: 590,margin: EdgeInsets.all(5),
              child: Wrap(
                children: [
                  Container(decoration: boxShadow,margin: EdgeInsets.only(bottom: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        Text("Lectures"),
                        ElevatedButton(onPressed: (){
                          TextEditingController lecturename = TextEditingController();
                          List lectureContents = [];
                          showDialog(
                              context: context,
                              builder: (_) =>StatefulBuilder(
                                builder: (context,setS) {
                                  return AlertDialog(content: Container(width: 500,
                                    child: Wrap(children: [
                                      Container(margin: EdgeInsets.only(top: 10,bottom: 10,left: 5,right: 5),decoration: boxShadow,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("Lecture name"),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextFormField(controller:lecturename ,decoration: InputDecoration(),),
                                            ),




                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Lecture contents"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: lectureContents.length==0?Center(child: Text("No contents added",style: TextStyle(color: Colors.grey),),): ListView.builder(shrinkWrap: true,
                                          itemCount: lectureContents.length,

                                          itemBuilder: (context, index) {
                                            return Row(
                                              children: [

                                                Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),width: 60,child: Center(child: Text((index+1).toString(),style: TextStyle(color: Colors.grey),))),
                                                Expanded(
                                                  child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                                      child: Text(lectureContents[index]),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(onPressed: (){

                                              TextEditingController lecturecontent = TextEditingController();
                                              showDialog(
                                                  context: context,
                                                  builder: (_) =>AlertDialog(content: Wrap(children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("Content Link"),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: TextFormField(controller:lecturecontent ,decoration: InputDecoration(),),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: ElevatedButton(onPressed: (){
                                                        lectureContents.add(lecturecontent.text);
                                                        setS(() {

                                                        });
                                                        Navigator.pop(context);

                                                      }, child: Text("Add")),
                                                    ),
                                                  ],),));
                                            }, child: Text("Add lecture content")),
                                            if(lectureContents.length>0)   ElevatedButton(onPressed: (){
                                              setState(() {
                                                lectures.add({"name":lecturename.text,"contents":lectureContents});
                                                Navigator.pop(context);
                                              });
                                            }, child: Text("Finish")),
                                          ],
                                        ),
                                      ),

                                    ],),
                                  ),title: Text("Add Lecture"),);
                                }
                              ));
                        }, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Add lecture"),

                          ],
                        )),
                      ],),
                    ),
                  ),
                  ListView.builder(shrinkWrap: true,
                    itemCount: lectures.length,

                    itemBuilder: (context, index) {
                      return Container(decoration: boxShadow2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4,bottom: 4),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("# "+(1+index).toString(),style: TextStyle(color: Colors.grey),),
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(lectures[index]["name"]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(lectures[index]["contents"].length.toString()+" contents",style: TextStyle(color: Colors.grey),),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                 //   separatorBuilder: (BuildContext context, int index) { return Divider();},
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: TextFormField(controller:c_description ,decoration: InputDecoration(hintText: "Description"),),
                  // ),  Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: TextFormField(controller:c_price ,decoration: InputDecoration(hintText: "Price"),),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  //   child: ClassSelectDropdown(onSelected: (String id){
                  //     class_id = id;
                  //     // selectedClassId = id;
                  //   },),
                  // ) ,Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //   child: SubjectSelectDropdown(onSelected: (String id){
                  //     subject_id = id;
                  //
                  //     // selectedClassId = id;
                  //   },),
                  // )

                ],
              ),
            ),
          ],
        ),
          ElevatedButton(child: Text("Finish"),onPressed: (){

    Data().saveBatches(data: {"lectures":lectures,"price":c_price.text,"class_id":class_id,"subject_id":subject_id,"description":c_description.text,"name":c.text,
    "created_by":FirebaseAuth.instance.currentUser!.uid}).then((value) {

    Data().batchesid(id: FirebaseAuth.instance.currentUser!.uid).then((value) {
    Provider.of<Batchprovider>(context, listen: false).items = value;
    });
    });
    Navigator.pop(context);

    })
      ],
    );
  }
}
