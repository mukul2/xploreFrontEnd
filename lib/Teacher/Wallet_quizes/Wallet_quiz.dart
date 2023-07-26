import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../RestApi.dart';

class WalletQuiz extends StatefulWidget {
  // GlobalKey<ScaffoldState> scaffoldKey;
  //CourseTable({required this.scaffoldKey});
  WalletQuiz();
  @override
  State<WalletQuiz> createState() => _WalletState();
}
// The "soruce" of the table
class MyDataWallet extends DataTableSource {
  MyDataWallet(this._data);
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

      DataCell(Text(_data[index]['quiz']==null?"--":(  _data[index]['quiz']["title"]??"--"))),
      DataCell(Text(_data[index]['student']??"--")),
      DataCell(Text(_data[index]['paid'].toString()??"--")),




      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}


class _WalletState extends State<WalletQuiz> {
  double earning = 0.0;
  List paidStudents = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Data().myquizeearnings(id: FirebaseAuth.instance.currentUser!.uid).then((value) {
      setState(() {
        earning = value["total_earning"];
        paidStudents = value["list"];
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget actions = Row(children: [
      TextButton(onPressed: (){}, child: Text("Create Batch"))
    ],);
//Batchprovider

    if(paidStudents.length==0)return Center(child: Text("No data"),);
    int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
    final DataTableSource _allUsers = MyDataWallet(paidStudents);

    return SingleChildScrollView(
      child: PaginatedDataTable(

        header:Text("Total Earning "+earning.toString()),
        rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,
        // rowsPerPage: 10,

        columns:  [

          DataColumn(label: Text('Quiz')),
          DataColumn(label: Text('Student')),
          DataColumn(label: Text('Paid')),


          // DataColumn(label: Text('Id')),
          // DataColumn(label: Text('Phone'))
        ],
        source: _allUsers,
      ),
    );





  }
}