import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:provider/provider.dart';

import 'AppProviders/DrawerProvider.dart';
import 'edit_question_activity.dart';

class QuizesTable extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  QuizesTable({required this.scaffoldKey});
  @override
  State<QuizesTable> createState() => _StudentsState();
}
// The "soruce" of the table
class MyData extends DataTableSource {
  MyData(this._data,this.key);
  GlobalKey<ScaffoldState> key;
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
      DataCell(Text(_data[index].data()['title'])),
       DataCell(Text(_data[index].data()["quiz"].length.toString()+" questions")),
    //   DataCell(Text(_data[index].data()["course_id"])),
       DataCell(FutureBuilder(

           future:FirebaseFirestore.instance.collection('courses').doc(_data[index].data()["course_id"]).get(),
           builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
             if(snap.hasData){
               return Text(snap.data!.get("course_title"));
               
             }else{
               return Center(child: CupertinoActivityIndicator(),);
             }
             
           })),
      DataCell(Text(_data[index].data()["exam_start"])),
      DataCell(Text(_data[index].data()["exam_end"])),
      DataCell(Text(_data[index].data()["exam_time"])),
      DataCell(TextButton(onPressed: (){

        key.currentState!.showBottomSheet((context) => Container(height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
          child: Column(
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
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text("Edit",style: TextStyle(fontSize: 25),),
                      ),
                    ],
                  ),
                ),
              ),

              Container(height: 25,),
              Edit_quiz_activity(ref:_data[index]),

            ],
          ),
        ),));

      },child: Text("Edit"),)),
      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}


class _StudentsState extends State<QuizesTable> {
  @override
  Widget build(BuildContext context) {

    return  StreamBuilder(

        stream:FirebaseFirestore.instance.collection('quizz2').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snap) {

        //  final DataTableSource _allUsers = MyData(snap.data!.docs,widget.scaffoldKey);
          if(snap.hasData){
            int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
            final DataTableSource _allUsers = MyData(snap.data!.docs,widget.scaffoldKey);
            return SingleChildScrollView(
              child: PaginatedDataTable(

                header: null,
                rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,
                columns: const [
                  DataColumn(label: Text('Quiz title')),
                   DataColumn(label: Text('Number of questions')),
                   DataColumn(label: Text('Course')),
                   DataColumn(label: Text('Exam start')),
                   DataColumn(label: Text('Exam end')),
                   DataColumn(label: Text('Exam duration')),
                   DataColumn(label: Text('Actions')),
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
        });



  }
}
