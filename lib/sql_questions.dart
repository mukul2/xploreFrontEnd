import 'package:admin/students_activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:provider/provider.dart';

import 'AppProviders/DrawerProvider.dart';
import 'RestApi.dart';
import 'create_question_activity.dart';
import 'edit_question_activity.dart';

class QuestionsActivitySQL extends StatefulWidget {
  // GlobalKey<ScaffoldState> scaffoldKey;
  //CourseTable({required this.scaffoldKey});
  QuestionsActivitySQL();
  @override
  State<QuestionsActivitySQL> createState() => _StudentsState();
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
      DataCell(Text(_data[index]['class'].toString())),
      DataCell(Text(_data[index]['subject'].toString())),
      DataCell(Text(_data[index]['chapter'].toString())),
      DataCell(Text(_data[index]['title']??"--")),
      DataCell(Text(_data[index]['q']??"--")),
      DataCell(Text(_data[index]['ans']??"--")),
      DataCell(ElevatedButton(onPressed: (){
//saveoptions
      List newOptions = [];
      List allOptions = [];
        //options
        showDialog(
            context: context,
            builder: (_) => StatefulBuilder(
              builder: (context,setS) {
                return AlertDialog(actions: [
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("Close")),
                  TextButton(onPressed: (){

                    Map data = {"id":_data[index]['id'].toString(),"options":newOptions};
                    print(data);
                    Data().saveoptions(data: data).then((value) {
                      Navigator.pop(context);

                    });

                  }, child: Text("Update",style: TextStyle(color: Colors.redAccent),)),
                ],title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Text("Question"),
                  IconButton(onPressed: (){
                    Navigator.pop(context);

                  },  icon: Icon(Icons.close))
                ],),
                  content:Container(width: 800,height: MediaQuery.of(context).size.height,
                    child:true?Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 400,child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(initialValue:_data[index]['title']??"--" ,enabled: false,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Title")),),
                            ),
                            // Row(
                            //   children: [
                            //     Text(_data[index]['title']??"--",style: TextStyle(color: Colors.black54,fontSize:15 ),),
                            //   ],
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(initialValue:_data[index]['q']??"--" ,enabled: false,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Question")),),
                            ),
                            // Row(
                            //   children: [
                            //     Text(_data[index]['q']??"--",style: TextStyle(color: Colors.black54,fontSize:15 ),),
                            //   ],
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(initialValue:_data[index]['ans']??"--" ,enabled: false,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Right ans")),),
                            ),

                          ],
                        ),),
                        Container(width: 400,child:Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Options"),
                                  ElevatedButton(onPressed: (){

                                    setS(() {
                                      newOptions.add("");
                                    });
                                  }, child: Text("Add option"))
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                FutureBuilder(

                                    future:Data().options(id: _data[index]['id'].toString()),
                                    builder: (context, AsyncSnapshot<List> snap) {
                                      if(snap.hasData && snap.data!.length>0){
                                        allOptions = snap.data!;
                                        //    return Text(snap.data!.toString());
                                        return ListView.builder(shrinkWrap: true,
                                            itemCount: allOptions.length,
                                            itemBuilder: (BuildContext context, int index) {
                                          try{
                                            return Container(margin: EdgeInsets.all(5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                                border: Border.all(color: Colors.blue,width: 0.3)),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                                child: Row(children: [
                                                  Text( allOptions[index]["body"],style: TextStyle(color: Colors.blue),),
                                                ],),
                                              ),
                                            );
                                          }catch(e){
                                            return Container(height: 0,width: 0,);
                                          }

                                            });
                                        return Wrap(children: allOptions.map((e) => Container(margin: EdgeInsets.all(5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                            border: Border.all(color: Colors.blue,width: 0.3)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                            child: Row(children: [
                                              Text( e["body"],style: TextStyle(color: Colors.blue),),
                                            ],),
                                          ),
                                        )).toList(),);
                                        return ListView.builder(shrinkWrap: true,
                                            itemCount: snap.data!.length,

                                            // display each item of the product list
                                            itemBuilder: (context, index) {
                                              return Text(snap.data![index]["body"].toString());
                                            });
                                      }else{
                                        return Container(height: 100,child: Center(child: CupertinoActivityIndicator(),));
                                      }

                                    }),
                                ListView.builder(shrinkWrap: true,
                                    itemCount: newOptions.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(margin: EdgeInsets.all(0),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                          child:true?TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 8,)),initialValue:newOptions[index] ,onChanged: (String s){
                                            newOptions[index] = s ;
                                          },): Row(children: [
                                            Text( newOptions[index]["body"],style: TextStyle(color: Colors.blue),),
                                          ],),
                                        ),
                                      );
                                    }),
                                // Wrap(children: newOptions.map((e) => Container(margin: EdgeInsets.all(5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                //     border: Border.all(color: Colors.blue,width: 0.3)),
                                //   child: Padding(
                                //     padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 10),
                                //     child: Row(children: [
                                //       Text( e["body"],style: TextStyle(color: Colors.blue),),
                                //     ],),
                                //   ),
                                // )).toList(),),
                              ],
                            ),
                          ],
                        ) ,),

                      ],
                    ): Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(initialValue:_data[index]['title']??"--" ,enabled: false,decoration: InputDecoration(label: Text("Title")),),
                        ),
                        // Row(
                        //   children: [
                        //     Text(_data[index]['title']??"--",style: TextStyle(color: Colors.black54,fontSize:15 ),),
                        //   ],
                        // ),
                        Row(
                          children: [
                            Text(_data[index]['q']??"--",style: TextStyle(color: Colors.black54,fontSize:15 ),),
                          ],
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Right ans : ",style: TextStyle(color: Colors.grey,fontSize:13 ),),
                            Text(_data[index]['ans']??"--",style: TextStyle(color: Colors.black54,fontSize:13 ),)
                          ],
                        ),
                        Text("Options are",style: TextStyle(color: Colors.grey,fontSize:13 ),),
                      ],
                    ),
                  ),
                );
              }
            ));
      },child: Text("View options"),)),



      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}


class _StudentsState extends State<QuestionsActivitySQL> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<QuestionSortsprovider>(context, listen: false).class_id = null;
    Provider.of<QuestionSortsprovider>(context, listen: false).subject_id = null;
    Provider.of<QuestionSortsprovider>(context, listen: false).chapter_id = null;
    Data().questionsbyid(id: FirebaseAuth.instance.currentUser!.uid).then((value) {
      Provider.of<Questionsprovider>(context, listen: false).items = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget actions = Row(children: [
      TextButton(onPressed: (){}, child: Text("Create Batch"))
    ],);
//Batchprovider
    return Scaffold(backgroundColor: Colors.grey.shade50,
      appBar: false?null: PreferredSize(preferredSize: Size(0,120),child: Card(margin: EdgeInsets.zero,shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
         child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 20),
           child: Column(
             children: [
               Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Text("Question management",style: TextStyle(fontSize: 25),),
                  ElevatedButton(onPressed: (){
                    TextEditingController c = TextEditingController();


                    showDialog(
                        context: context,
                        builder: (_) =>AlertDialog(content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Create_question(),
                        ),));

                  }, child: Text("Create Question"))
                ],),
        ),
               Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ClassSelectDropdown(onSelected: (String id){
                            print("class selested "+id);
                            Provider.of<QuestionSortsprovider>(context, listen: false).class_id =  int.parse(id);
                            // selectedClassId = id;
                          },),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SubjectSelectDropdown(onSelected: (String id){
                            print("sub selested "+id);
                       //     Provider.of<QuestionSortsprovider>(context, listen: false).subject_id =  int.parse(id);

                            // selectedClassId = id;
                          },),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ChapterSelectDropdown(onSelected: (String id){
                            print("class selested "+id);

                            // selectedClassId = id;
                          },),
                        ),
                      ),
                    ],
                  )
             ],
           ),
         ),
      ),),
      body: true?Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Consumer<Questionsprovider>(
          builder: (_, bar, __) {

            if(bar.items.isEmpty)return Center(child: Text("No data"),);


          return  Consumer<QuestionSortsprovider>(
            builder: (_, bar1, __) {


              List sorted = [];

              if(bar1.class_id==null){
                sorted.addAll(bar.items);
              }else  if(bar1.class_id==0){
                sorted.addAll(bar.items);
              }else{
                for(int i = 0 ; i < bar.items.length ; i++){

                  if(bar.items[i]["class_id"] == bar1.class_id){
                    sorted.add(bar.items[i]);
                  }

                }
              }

              List passedClss = sorted;

              if(bar1.subject_id==null){
                sorted = passedClss;
              }else  if(bar1.subject_id==0){
                sorted = passedClss;
                //sorted.addAll(bar.items);
              }else{
                List newSorted = [];
                for(int i = 0 ; i < passedClss.length ; i++){

                  if(passedClss[i]["subject_id"] == bar1.subject_id){
                    newSorted.add(passedClss[i]);
                  }

                }
                sorted = newSorted;

              }

              List passedSubject = sorted;


              if(bar1.chapter_id==null){
                sorted = passedSubject;
              }else  if(bar1.chapter_id==0){
                sorted = passedSubject;
                //sorted.addAll(bar.items);
              }else{
                List newSorted = [];
                for(int i = 0 ; i < passedSubject.length ; i++){

                  if(passedSubject[i]["chapter_id"] == bar1.chapter_id){
                    newSorted.add(passedSubject[i]);
                  }

                }
                sorted = newSorted;

              }



              if(sorted.length == 0)return Center(child: Text("No data"),);




              int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
              final DataTableSource _allUsers = MyData(sorted,context);
              return PaginatedDataTable(showCheckboxColumn: true,showFirstLastButtons: true,

                header:true?null:Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClassSelectDropdown(onSelected: (String id){
                          print("class selested "+id);
                          Provider.of<QuestionSortsprovider>(context, listen: false).class_id =  int.parse(id);
                          // selectedClassId = id;
                        },),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SubjectSelectDropdown(onSelected: (String id){
                          print("class selested "+id);

                          // selectedClassId = id;
                        },),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChapterSelectDropdown(onSelected: (String id){
                          print("class selested "+id);

                          // selectedClassId = id;
                        },),
                      ),
                    ),
                  ],
                ),
                rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

                columns: const [
                  DataColumn(label: Text('Class')),
                  DataColumn(label: Text('Subject')),
                  DataColumn(label: Text('Chapter')),
                  DataColumn(label: Text('Title')),
                  DataColumn(label: Text('Question')),
                  DataColumn(label: Text('Answer')),
                  DataColumn(label: Text('Options')),

                  // DataColumn(label: Text('Id')),
                  // DataColumn(label: Text('Phone'))
                ],
                source: _allUsers,
              );
            });



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