import 'package:admin/students_activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:provider/provider.dart';

import 'AppProviders/DrawerProvider.dart';
import 'RestApi.dart';
import 'edit_question_activity.dart';

class SubjectActivity extends StatefulWidget {
  // GlobalKey<ScaffoldState> scaffoldKey;
  //CourseTable({required this.scaffoldKey});
  SubjectActivity();
  @override
  State<SubjectActivity> createState() => _StudentsState();
}
// The "soruce" of the table
class MyData extends DataTableSource {
  MyData(this._data);
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
      DataCell(Text(_data[index]["sid"].toString()??"--")),
      DataCell(Text(_data[index]['sName']??"--")),
      DataCell(Text(_data[index]['cname']??"--")),
      //DataCell(Text(_data[index]['created_at']??"--")),



      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}


class _StudentsState extends State<SubjectActivity> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Data().subjectsidx(id: FirebaseAuth.instance.currentUser!.uid).then((value) {
      Provider.of<Subjectsprovider>(context, listen: false).items = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget actions = Row(children: [
      TextButton(onPressed: (){}, child: Text("Create Subject"))
    ],);
//Batchprovider
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size(0,50),child:    Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ElevatedButton(onPressed: (){
              TextEditingController c = TextEditingController();
              String selectedClassId= "";


              showDialog(
                  context: context,
                  builder: (_) =>AlertDialog(title: Text("Create Subject"),actions: [
                    ElevatedButton(onPressed: (){

                      Data().saveSubjects(data: {"class_id":selectedClassId,"name":c.text,"created_by":FirebaseAuth.instance.currentUser!.uid,}).then((value) {
                        Data().subjectsidx(id: FirebaseAuth.instance.currentUser!.uid).then((value) {
                          Provider.of<Subjectsprovider>(context, listen: false).items = value;
                        });

                      });

                      Navigator.pop(context);

                    }, child: Text("Create Class")),
                  ],content: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(controller:c ,decoration: InputDecoration(hintText: "Class Subject"),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClassSelectDropdown(onSelected: (String id){

                          selectedClassId = id;
                        },),
                      ),
                    ],
                  ),));

            }, child: Text("Create Subject")),
          ],
        ),
      ),),
      body: true?Consumer<Subjectsprovider>(
        builder: (_, bar, __) {

          if(bar.items.isEmpty)return Center(child: Text("No data"),);

          int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
          final DataTableSource _allUsers = MyData(bar.items);
          return SingleChildScrollView(
            child: PaginatedDataTable(

              header:null,
              rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

              columns: const [
                DataColumn(label: Text('Id')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Class')),
                //DataColumn(label: Text('Created at')),

                // DataColumn(label: Text('Id')),
                // DataColumn(label: Text('Phone'))
              ],
              source: _allUsers,
            ),
          );

        },
      ): FutureBuilder(

          future:Data().batches(),
          builder: (context, AsyncSnapshot<List> snap) {
            if(snap.hasData && snap.data!.length>0){

              int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
              final DataTableSource _allUsers = MyData(snap.data!);
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
              final DataTableSource _allUsers = MyData(snap.data!.docs);
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