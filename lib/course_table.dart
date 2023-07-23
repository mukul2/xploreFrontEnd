import 'dart:html';
import 'dart:typed_data';

import 'package:admin/students_activity.dart';
import 'package:admin/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:image_picker/image_picker.dart';
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
  BuildContext context;
  MyData(this._data,this.context);
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
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300,minWidth: 100), child: Text(_data[index]['name']??"--"))),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300,minWidth: 100), child: Text(_data[index]['description']??"--"))),
      DataCell(Text(_data[index]['price'].toString()??"--")),
      DataCell(Text(_data[index]['lectures'][0]["lnum"].toString()??"--")),
      DataCell(ElevatedButton(onPressed: (){


        showDialog(
            context: context,
            builder: (_) =>AlertDialog(
              //title: Text("Delete Question"),
              content: Container(width: 400,
                child: Wrap(
                  children: [
                    Center(child: Icon(Icons.warning,size: 50,)),
                    Container(width: 400,child: Center(child: Text("Are you sure to delete this course?"))),
                  ],
                ),
              ),actions: [
              ElevatedButton(onPressed: (){
                Data().deletecourse(id:_data[index]['id'].toString() ).then((value) {

                  Data().batchesid(id: FirebaseAuth.instance.currentUser!.uid).then((value) {
                    Provider.of<Batchprovider>(context, listen: false).items = value;
                  });

                });
              }, child: Text("Yes")),
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("No")),
            ],));




      },child: Text("Delete"),)),



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
    return Scaffold(backgroundColor: Colors.white,
      body: true?Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<Batchprovider>(
          builder: (_, bar, __) {

          //  if(bar.items.isEmpty)return Center(child: Text("No data"),);
            //return Text(bar.items.toString());

            int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
            final DataTableSource _allUsers = MyData(bar.items,context);
            return PaginatedDataTable(

              header:Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Container(height: 40,width: 300,child: TextFormField(decoration: InputDecoration(hintText: "Search"),),),
                if(false)  ElevatedButton(onPressed: (){
                    showDialog(
                        context: context,
                        builder: (_) =>AlertDialog(backgroundColor: Colors.grey.shade50,
                          // title: Text("Create Course"),
                          content: Container(width: MediaQuery.of(context).size.width,height:  MediaQuery.of(context).size.height,
                            child:CreateCourseActivity() ,
                          ),));


                  }, child: Text("Create Course")),
                ],),
              ),
              rowsPerPage:bar.items.length>0?( _allUsers.rowCount>n?n:_allUsers.rowCount):1,

              columns: const [
                DataColumn(label: Text('Course Name',style: TextStyle(color: Colors.blue),)),
                DataColumn(label: Text('Description',style: TextStyle(color: Colors.blue),)),
                DataColumn(label: Text('Price',style: TextStyle(color: Colors.blue),)),
                DataColumn(label: Text('Total Lectures',style: TextStyle(color: Colors.blue),)),
                DataColumn(label: Text('Actions',style: TextStyle(color: Colors.blue),)),

                // DataColumn(label: Text('Id')),
                // DataColumn(label: Text('Phone'))
              ],
              source: _allUsers,
            );

          },
        ),
      ): FutureBuilder(

          future:Data().batches(),
          builder: (context, AsyncSnapshot<List> snap) {
            if(snap.hasData && snap.data!.length>0){

              int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
              final DataTableSource _allUsers = MyData(snap.data!,context);
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
              final DataTableSource _allUsers = MyData(snap.data!.docs,context);
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
  List Quizes = [];
  @override
  Widget build(BuildContext context) {
    return    Container(margin: EdgeInsets.all(20), decoration: boxShadow,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Wrap(
          children: [
            Container(margin: EdgeInsets.symmetric(horizontal: 8,vertical: 6),decoration: boxShadow,child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Course information"),
                ],
              ),
            )),
            Row(
              children: [
                Expanded(flex: 4 ,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(controller:c ,decoration: InputDecoration(hintText: "Course name"),),
                  ),
                ),
                Expanded(flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(controller:c_price ,decoration: InputDecoration(hintText: "Price"),),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(controller:c_description ,decoration: InputDecoration(hintText: "Description"),),
            ),
            // PickPhotoBox(onPhotoPicked: (dynamic data){
            //
            // },),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    child: ClassSelectDropdown(onSelected: (String id){
                      class_id = id;
                      // selectedClassId = id;
                    },),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SubjectSelectDropdown(onSelected: (String id){
                      subject_id = id;

                      // selectedClassId = id;
                    },),
                  ),
                )
              ],
            ),

            Container(margin: EdgeInsets.symmetric(horizontal: 8,vertical: 6),decoration: boxShadow,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Text("Lectures"),
                  ElevatedButton(onPressed: (){
                    TextEditingController lecturename = TextEditingController();

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
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Text("Lecture contents"),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: lectureContents.length==0?Center(child: Text("No contents added",style: TextStyle(color: Colors.grey),),): ListView.builder(shrinkWrap: true,
                                  //     itemCount: lectureContents.length,
                                  //
                                  //     itemBuilder: (context, index) {
                                  //       return Row(
                                  //         children: [
                                  //
                                  //           Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),width: 60,child: Center(child: Text((index+1).toString(),style: TextStyle(color: Colors.grey),))),
                                  //           Expanded(
                                  //             child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                                  //               child: Padding(
                                  //                 padding: const EdgeInsets.symmetric(horizontal: 5),
                                  //                 child: Text(lectureContents[index]),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       );
                                  //     },
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                      if(false) ElevatedButton(onPressed: (){


                                        }, child: Text("Add lecture content")),
                                        ElevatedButton(onPressed: (){
                                          setState(() {
                                            lectures.add({"name":lecturename.text,"contents":[],"quizes":[]});
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
            lectures.length==0?Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("No lectures added",style:  TextStyle(color: Colors.grey),),
            ),): ListView.builder(shrinkWrap: true,padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
              itemCount: lectures.length,

              itemBuilder: (context, index) {
                return Container(decoration: boxShadow,margin:EdgeInsets.symmetric(horizontal: 0,vertical: 2) ,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4,bottom: 4),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("# "+(1+index).toString(),style: TextStyle(color: Colors.grey),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(lectures[index]["name"]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(lectures[index]["contents"].length.toString()+" contents "+lectures[index]["quizes"].length.toString()+" quizes",style: TextStyle(color: Colors.grey),),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton(onPressed: (){
                                showDialog(
                                    context: context,
                                    builder: (_) =>StatefulBuilder(
                                      builder: (context,setS) {
                                        return AlertDialog(content: true?Container(height: 500,width: 600,
                                          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              FutureBuilder<List>(
                                              future: Data().quizesHandelerid(id: FirebaseAuth.instance.currentUser!.uid), // a previously-obtained Future<String> or null
                                              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                                                if(snapshot.hasData){

                                                return  ListView.builder(shrinkWrap: true,
                                                    itemCount: snapshot.data!.length,

                                                    itemBuilder: (context, index2) {

                                                      return Opacity( opacity:lectures[index]["quizes"]==null?1: lectures[index]["quizes"].length>0?( lectures[index]["quizes"].contains(snapshot.data![index2]["id"])?0.5:1):1,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(snapshot.data![index2]["title"]),
                                                              ElevatedButton(onPressed: (){

                                                                if(lectures[index]["quizes"].contains(snapshot.data![index2]["id"])){
                                                                  try{
                                                                    lectures[index]["quizes"].remove(snapshot.data![index2]["id"]);
                                                                  }catch(e){
                                                                    print(e);
                                                                  }
                                                                  setState(() {

                                                                  });
                                                                  setS(() {

                                                                  });
                                                                }else{
                                                                  print("add");
                                                                  try{
                                                                    lectures[index]["quizes"].add(snapshot.data![index2]["id"]);
                                                                  }catch(e){
                                                                    print(e);
                                                                  }
                                                                  setState(() {

                                                                  });
                                                                  setS(() {

                                                                  });
                                                                }

                                                                Navigator.of(context);
                                                              }, child: Text(lectures[index]["quizes"].contains(snapshot.data![index2]["id"])?"Remove": "Select"))
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }else{
                                                  return Center(child: CircularProgressIndicator(),);
                                                }
                                              }),
                                              Center(
                                                child: ElevatedButton(onPressed: (){
                                                  Navigator.pop(context);
                                                }, child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                                                  child: Text("Close"),
                                                )),
                                              )
                                            ],
                                          ),
                                        ): Wrap(children: [

                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(onPressed: (){
                                              lectures[index]["quizes"].add("1");
                                              setState(() {

                                              });
                                              Navigator.pop(context);

                                            }, child: Text("Add")),
                                          ),
                                        ],),);
                                      }
                                    ));
                              }, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Add Quize"),


                                ],
                              )),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton(onPressed: (){
                                TextEditingController lecturecontent = TextEditingController();
                                TextEditingController lecturecontenttitle = TextEditingController();
                                //List lectureContents = [];
                                showDialog(
                                    context: context,
                                    builder: (_) =>AlertDialog(content: Wrap(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Title"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(controller:lecturecontenttitle ,decoration: InputDecoration(),),
                                      ),
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
                                          lectures[index]["contents"].add({"title":lecturecontenttitle.text,"body":lecturecontent.text});
                                         setState(() {

                                         });
                                          Navigator.pop(context);

                                        }, child: Text("Add")),
                                      ),
                                    ],),));


                              }, child: Text("Add Course content"),),
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

            Center(
              child: ElevatedButton(child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 15,vertical: 6),
                child: Text("Finish"),
              ),onPressed: (){

                Data().saveBatches(data: {"lectures":lectures,"price":c_price.text,"class_id":class_id,"subject_id":subject_id,"description":c_description.text,"name":c.text,
                  "created_by":FirebaseAuth.instance.currentUser!.uid}).then((value) {

                  Data().batchesid(id: FirebaseAuth.instance.currentUser!.uid).then((value) {
                    Provider.of<Batchprovider>(context, listen: false).items = value;
                    Provider.of<DrawerSelectionSub>(context, listen: false).selection = 2;
                    Provider.of<DrawerSelectionSub>(context, listen: false).selectionsub = 1;
                  });
                });


              }),
            ),

          ],
        ),
      ),
    );
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
class PickPhotoBox extends StatefulWidget {
  Function(dynamic) onPhotoPicked;
  PickPhotoBox({required this.onPhotoPicked});

  @override
  State<PickPhotoBox> createState() => _PickPhotoBoxState();
}

class _PickPhotoBoxState extends State<PickPhotoBox> {
  XFile? image;
  Uint8List? imgData ;
  @override
  Widget build(BuildContext context) {
    return Container(width: 300,height: 200,child: InkWell(child: imgData==null?Center(child: Text("Click to choose photo"),):Image.memory(imgData!),
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        // Pick an image.
        //   image = await picker.pickImage(source: source);
        //   setState(() {
        //      image!.readAsBytes().then((value) => imgData = value);
        //   });
      },
    ),);
  }
}
