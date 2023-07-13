import 'package:admin/student_side.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'RestApi.dart';
class MyQuizesTable2 extends DataTableSource {
  BuildContext context;
  MyQuizesTable2(this._data,this.context);
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
      DataCell(Text(_data[index]['class']??"--")),
      DataCell(Text(_data[index]['subject']??"--")),
      DataCell(Text(_data[index]['chapter']??"--")),
      DataCell(Text(_data[index]['title']??"--")),
      DataCell(Text(_data[index]['section_details']??"--")),
      DataCell(Text(_data[index]['price'].toString()??"--")),

   //   DataCell(Text(_data[index]['title'].toString()??"--")),
    //  DataCell(Text(DateFormat('yyyy-MM-dd hh:mm').format( DateTime.fromMillisecondsSinceEpoch(_data[index]['exam_start']*1000)))),
    //  DataCell(Text(DateFormat('yyyy-MM-dd hh:mm').format( DateTime.fromMillisecondsSinceEpoch(_data[index]['exam_end']*1000)))),
      DataCell(ElevatedButton(onPressed: (){

        showDialog(
            context: context,
            builder: (_) =>AlertDialog(actions: [
              ElevatedButton(onPressed: (){
                Navigator.pop(context);

              }, child: Text("Cancel")),
              ElevatedButton(onPressed: (){
                Map data = {"quize_id":_data[index]['id'],"price":_data[index]['price'],"teacher_id":_data[index]["created_by"],"student_id":FirebaseAuth.instance.currentUser!.uid};
                Data().buycuize(data:data ).then((value) {
                  Navigator.pop(context);

                });




              }, child: Text("Confirm")),
            ],content: Text("Pay "+_data[index]['price'].toString()??"--"+"?"),title: Text("Buy Course",style: TextStyle(fontSize: 15,color: Colors.black),),));

      },child: Text("Buy"),)),



      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}
class MyQuizes extends StatelessWidget {
  const MyQuizes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
        appBar:PreferredSize(preferredSize: Size(0,50),child: Center(
    child: TabBar(isScrollable: true,
    tabs: [
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text("Purchased",style: TextStyle(color: Colors.black),),
    ),
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text("Marketplace",style: TextStyle(color: Colors.black),),
    ),

    ],
    ),
    ),),
    body:  Padding(
    padding: const EdgeInsets.all(30.0),
    child: TabBarView(
    children: [
    FutureBuilder<List>(
    future: Data().mypurchasedquizes(id: FirebaseAuth.instance.currentUser!.uid), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if(snapshot.hasData && snapshot.data!.length>0){
          // return Text(snapshot.data!.toString());
            int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
            final DataTableSource _allUsers = MyDataPurchasedQuizes(snapshot.data!);
            return   PaginatedDataTable(
              // columnSpacing: 10,
              horizontalMargin: 5,

              header:null,
              rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

              columns: const [
                DataColumn(label: Text('Quize title',style: TextStyle(color: Colors.blue),)),

                DataColumn(label: Text('Actions',style: TextStyle(color: Colors.blue),)),

                // DataColumn(label: Text('Id')),
                // DataColumn(label: Text('Phone'))
              ],
              source: _allUsers,
            );
          }else{
            return Center(child: Text("No data"),);
          }

        }),
            FutureBuilder<List>(
                future: Data().quizesX(), // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if(snapshot.hasData && snapshot.data!.length>0){
                    Text(snapshot.data!.toString());
                    int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
                    final DataTableSource _allUsers = MyQuizesTable2(snapshot.data!,context);
                    return   PaginatedDataTable(
                      // columnSpacing: 10,
                      horizontalMargin: 5,

                      header:null,
                      rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

                      columns: const [
                        DataColumn(label: Text('Title',style: TextStyle(color: Colors.blue),)),
                        DataColumn(label: Text('Details',style: TextStyle(color: Colors.blue),)),
                        DataColumn(label: Text('Price',style: TextStyle(color: Colors.blue),)),
                        DataColumn(label: Text('Class',style: TextStyle(color: Colors.blue),)),
                        DataColumn(label: Text('Subject',style: TextStyle(color: Colors.blue),)),
                        DataColumn(label: Text('Chapter',style: TextStyle(color: Colors.blue),)),
                        DataColumn(label: Text('Action',style: TextStyle(color: Colors.blue),)),

                        // DataColumn(label: Text('Id')),
                        // DataColumn(label: Text('Phone'))
                      ],
                      source: _allUsers,
                    );
                  }else{
                    return Center(child: Text("No data"),);
                  }

                }),
    ]))));
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