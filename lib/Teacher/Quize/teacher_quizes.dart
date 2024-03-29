import 'package:admin/questions_table_of_quize_table.dart';
import 'package:admin/students_activity.dart';
import 'package:admin/styles.dart';
import 'package:admin/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../AppProviders/DrawerProvider.dart';
import '../../RestApi.dart';



class QuizesTable extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  QuizesTable({required this.scaffoldKey});
  @override
  State<QuizesTable> createState() => _StudentsState();
}
// The "soruce" of the table
class MyData extends DataTableSource {
  MyData(this._data,this.context,);
  BuildContext context;
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
    DataCell safeDate(dynamic d,String key){

      try{

        return DataCell(Text( DateFormat('yyyy-MM-dd').format( DateTime.fromMillisecondsSinceEpoch(_data[index][key]*1000))));
      }catch(e){
        return DataCell(Text(e.toString()));
      }
    }
    DataCell wo(){
      try{
        return DataCell(Text( _data[index]["quiz"]==null?"--": _data[index]["quiz"].length.toString()+" questions"));
      }catch(e){
        return DataCell(Text("--"));
      }
    }
    DataCell wo2(){
      try{
        return DataCell(FutureBuilder(

            future:FirebaseFirestore.instance.collection('courses').doc(_data[index]["course_id"]).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
              if(snap.hasData && snap.data!.exists){
                return Text(snap.data!.get("course_title"));

              }else{
                return Text("--");
                return Center(child: CupertinoActivityIndicator(),);
              }

            }));
      }catch(e){
        return DataCell(Text("--"));
      }
    }

    return DataRow(selected: selected_quiz.contains(_data[index]['id']),onSelectChanged: (bool? b){
      print(b);
      if( selected_quiz.contains(_data[index]['id'] )){
        selected_quiz.remove(_data[index]['id']);
      }else{
        selected_quiz.add(_data[index]['id']);
      }
      print(selected_quiz);



    },cells: [
      DataCell(Text(_data[index]['course']??"--")),
      DataCell(Text(_data[index]['class']??"--")),
      DataCell(Text(_data[index]['subject']??"--")),
      DataCell(Text(_data[index]['chapter']??"--")),
      DataCell(Text(_data[index]['title'])),

      DataCell(Text(_data[index]['section_details'])),
      DataCell(Text(_data[index]['total_point'].toString())),
      //  wo(),
      //   DataCell(Text(_data[index].data()["course_id"])),
      //  wo2(),
      //    safeDate(_data[index],"exam_start"),
      //   safeDate(_data[index],"exam_end"),
      //   DataCell(Text(DateTime.fromMillisecondsSinceEpoch(_data[index].data()["exam_start"]).toIso8601String())),
      //  DataCell(Text(DateTime.fromMillisecondsSinceEpoch(_data[index].data()["exam_end"]).toIso8601String())),
      //  DataCell(Text(_data[index]["exam_time_minute"].toString())),
      DataCell(Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(onPressed: (){
              Data().deletequize(id: _data[index]['id'].toString()).then((value) {
                Data().quizesHandelerid(id: FirebaseAuth.instance.currentUser!.uid).then((value) {
                  Provider.of<Quizessprovider>(context, listen: false).items = value;
                });



              });
            }, child: Text("Delete")),
          ),
          ElevatedButton(onPressed: (){

            //context

            showDialog(
                context: context,
                builder: (_) => Dialog(child: SingleChildScrollView(
                  child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(margin: EdgeInsets.zero,shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ) ,
                        child: Padding(
                          padding:  EdgeInsets.only(bottom: 10,top: 15),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell( onTap: (){

                                Provider.of<QuestionsSelectedProvider>(context, listen: false).totalMarks = 0;
                                Provider.of<QuestionsSelectedProvider>(context, listen: false).selectedQuestionsBody =[];
                                Provider.of<QuestionsSelectedProvider>(context, listen: false).selectedQuestions = [];

                                Navigator.pop(context);
                              },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    children: [
                                      Icon(Icons.navigate_before,color: Colors.blue,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text("Close",style: TextStyle(color: Colors.blue),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Text(_data[index]['title'],style: TextStyle(fontSize: 25),),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Container(height: 25,),
                      QuestionsofQuize(quizeId:_data[index]["id"].toString() ,),
                      //  Edit_quiz_activitySQL(ref:_data[index]),

                    ],
                  ),
                ),));



          },child: Text("Edit"),),
        ],
      )),
      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}


class _StudentsState extends State<QuizesTable> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Data().quizesHandelerid(id: FirebaseAuth.instance.currentUser!.uid).then((value) {
      Provider.of<Quizessprovider>(context, listen: false).items = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    return  Consumer<Quizessprovider>(
        builder: (_, bar, __) {
          // if (bar.items.isEmpty) return Center(child: Text("No data"),);
          //  return Text(bar.items.toString());
          int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
          final DataTableSource _allUsers = MyData(bar.items,context);
          //  return Text(_allUsers.rowCount.toString());

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: PaginatedDataTable(
              // columnSpacing: 15,
              showCheckboxColumn: true,

              header: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Container(height: 40,width: 300,child: TextFormField(decoration: InputDecoration(hintText: "Search"),),),
               if(false)   ElevatedButton(onPressed: (){
                    context.go("/home/create-quize");


                  }, child: Text("Create Course")),
                ],),
              ),
              rowsPerPage:n>0?( _allUsers.rowCount>n?n:_allUsers.rowCount):0,
            //  rowsPerPage: 1,
              columns: const [
                DataColumn(label: Text('Course')),
                DataColumn(label: Text('Class')),
                DataColumn(label: Text('Subject')),
                DataColumn(label: Text('Chapter')),
                DataColumn(label: Text('Quiz title')),
                DataColumn(label: Text('Details')),
                DataColumn(label: Text('Total')),
                //    DataColumn(label: Text('Exam start')),
                //  DataColumn(label: Text('Exam end')),
                //  DataColumn(label: Text('Exam duration')),
                DataColumn(label: Text('Actions')),
                // DataColumn(label: Text('Id')),
                // DataColumn(label: Text('Phone'))
              ],
              source: _allUsers,
            ),
          );
        });







  }
}
