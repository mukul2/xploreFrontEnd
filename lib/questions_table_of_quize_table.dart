import 'package:admin/sql_questions.dart';
import 'package:admin/student_side.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'RestApi.dart';

class QuestionsofQuize extends StatelessWidget {
  String quizeId;
  QuestionsofQuize({required this.quizeId});

  @override
  Widget build(BuildContext context) {
    return   FutureBuilder<List>(
        future:Data().quizAuestions(id: quizeId),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if(snapshot.hasData && snapshot.data!.length>0){
            Text(snapshot.data!.toString());
            int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
            final DataTableSource _allUsers = MyQuizesTable(snapshot.data!,context);
            return   PaginatedDataTable(
              // columnSpacing: 10,
              horizontalMargin: 5,

              header:null,
              rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

              columns: const [
                DataColumn(label: Text('Title',style: TextStyle(color: Colors.blue),)),
                DataColumn(label: Text('Question',style: TextStyle(color: Colors.blue),)),
                DataColumn(label: Text('Mark',style: TextStyle(color: Colors.blue),)),

                DataColumn(label: Text('Actions',style: TextStyle(color: Colors.blue),)),

                // DataColumn(label: Text('Id')),
                // DataColumn(label: Text('Phone'))
              ],
              source: _allUsers,
            );
          }else{
            return Center(child: Text("No data"),);
          }

        });
  }
}
class MyQuizesTable extends DataTableSource {
  BuildContext context;
  MyQuizesTable(this._data,this.context);
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
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300,minWidth: 100),child: Text(_data[index]['title']??"--"))),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300,minWidth: 100),child: Text(_data[index]['q']??"--"))),

      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300,minWidth: 100),child: Text(_data[index]['score'].toString()??"--"))),

      DataCell(ElevatedButton(onPressed: (){
        showDialog(
            context: context,
            builder: (_) =>AlertDialog(content:Container(width: 600,child: QuesionOptionsTab(mapData:_data[index] ,)) ,));

        //
      },child: Text("Edit"),)),



      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}