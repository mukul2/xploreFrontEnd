import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:provider/provider.dart';

import 'AppProviders/DrawerProvider.dart';
import 'edit_question_activity.dart';

class QuestionsTable extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  QuestionsTable({required this.scaffoldKey});
  @override
  State<QuestionsTable> createState() => _StudentsState();
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
      DataCell(Text(_data[index].data()['q'])),
       DataCell(Text(_data[index].data()["quize_type"])),
       DataCell(Text(_data[index].data()["score"].toString())),
    //   DataCell(Text(_data[index].data()["course_id"])),

   if(false)   DataCell(TextButton(onPressed: (){

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


class _StudentsState extends State<QuestionsTable> {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(

        stream:FirebaseFirestore.instance.collection("questionsN").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snap) {

        //  final DataTableSource _allUsers = MyData(snap.data!.docs,widget.scaffoldKey);
          if(snap.hasData){
            final DataTableSource _allUsers = MyData(snap.data!.docs,widget.scaffoldKey);
            return SingleChildScrollView(
              child: PaginatedDataTable(
                header: const Text("Questions"),
                rowsPerPage: 15,
                columns: const [
                  DataColumn(label: Text('Question title')),
                  DataColumn(label: Text('Question')),
                   DataColumn(label: Text('Question type')),
                   DataColumn(label: Text('Score')),

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
