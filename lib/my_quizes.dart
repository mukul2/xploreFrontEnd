import 'package:admin/student_side.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'RestApi.dart';

class MyQuizes extends StatelessWidget {
  const MyQuizes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   FutureBuilder<List>(
        future: Data().myquizes(id: FirebaseAuth.instance.currentUser!.uid), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if(snapshot.hasData && snapshot.data!.length>0){
            Text(snapshot.data!.toString());
            int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
            final DataTableSource _allUsers = MyQuizesTable(snapshot.data!);
            return   PaginatedDataTable(
             // columnSpacing: 10,
              horizontalMargin: 5,

              header:null,
              rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

              columns: const [
                DataColumn(label: Text('Course Name',style: TextStyle(color: Colors.blue),)),
                DataColumn(label: Text('Instructor',style: TextStyle(color: Colors.blue),)),
                DataColumn(label: Text('Quiz title',style: TextStyle(color: Colors.blue),)),
                DataColumn(label: Text('Starts',style: TextStyle(color: Colors.blue),)),
                DataColumn(label: Text('Ends',style: TextStyle(color: Colors.blue),)),
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
  MyQuizesTable(this._data);
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
      DataCell(Text(_data[index]['course']??"--")),
      DataCell(Text(_data[index]['teacher']??"--")),

      DataCell(Text(_data[index]['title'].toString()??"--")),
      DataCell(Text(DateFormat('yyyy-MM-dd hh:mm').format( DateTime.fromMillisecondsSinceEpoch(_data[index]['exam_start']*1000)))),
      DataCell(Text(DateFormat('yyyy-MM-dd hh:mm').format( DateTime.fromMillisecondsSinceEpoch(_data[index]['exam_end']*1000)))),
      DataCell(ElevatedButton(onPressed: (){},child: Text("Start Exam"),)),



      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}