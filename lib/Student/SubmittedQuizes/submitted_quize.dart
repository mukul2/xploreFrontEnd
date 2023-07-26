import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../RestApi.dart';

class MySubmittedQuizes extends StatefulWidget {
  const MySubmittedQuizes({super.key});

  @override
  State<MySubmittedQuizes> createState() => _MySubmittedQuizesState();
}
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
      // Questionprovider

      DataCell(Text(_data[index]["quize"].toString())),
      DataCell(Text(_data[index]["marks"].toString()??"--".toString())),
      DataCell(Text(_data[index]["rightanswer"].toString()??"--".toString())),
      DataCell(Text(_data[index]["wrong"].toString()??"--".toString())),
      DataCell(Text(_data[index]["unanswer"].toString()??"--".toString())),



      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}
class _MySubmittedQuizesState extends State<MySubmittedQuizes> {
  @override
  Widget build(BuildContext context) {
    return   FutureBuilder<List>(
        future: Data().mysubmittedQuizes(id:FirebaseAuth.instance.currentUser!.uid), // a previously-obtained Future<String> or null
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    if(snapshot.hasData){
      int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
      final DataTableSource _allUsers = MyData(snapshot.data,context);
      return PaginatedDataTable(header: Text("Submitted Quizes"),
        //   columnSpacing: 10,
        horizontalMargin: 10,showCheckboxColumn: true,showFirstLastButtons: true,


        rowsPerPage:snapshot.data.length==0?1:( _allUsers.rowCount>n?n:_allUsers.rowCount),

        columns:  [

          DataColumn(label: Text('Quize')),
          DataColumn(label: Text('Obtained marks')),
          DataColumn(label: Text('Right')),
          DataColumn(label: Text('Wrong')),
          DataColumn(label: Text('Un answered')),


          // DataColumn(label: Text('Id')),
          // DataColumn(label: Text('Phone'))
        ],
        source: _allUsers,
      );

    }else{
      return Text("No data");
    }});
    return const Placeholder();
  }
}
