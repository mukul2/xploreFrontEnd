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

        //options
        showDialog(
            context: context,
            builder: (_) => AlertDialog(actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Close")),
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Delete",style: TextStyle(color: Colors.redAccent),)),
            ],title: Wrap(
              children: [
                Row(
                  children: [
                    Text(_data[index]['title']??"--",style: TextStyle(color: Colors.black54,fontSize:15 ),),
                  ],
                ),
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
              content: FutureBuilder(

                  future:Data().options(id: _data[index]['id'].toString()),
                  builder: (context, AsyncSnapshot<List> snap) {
                    if(snap.hasData && snap.data!.length>0){
                  //    return Text(snap.data!.toString());
                      return Wrap(children: snap.data!.map((e) => Container(margin: EdgeInsets.all(5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: Colors.blue,width: 0.3)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
    return Scaffold(
      appBar: false?null: PreferredSize(preferredSize: Size(0,50),child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
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
      ),),
      body: true?Consumer<Questionsprovider>(
        builder: (_, bar, __) {

          if(bar.items.isEmpty)return Center(child: Text("No data"),);

          int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
          final DataTableSource _allUsers = MyData(bar.items,context);
          return SingleChildScrollView(
            child: PaginatedDataTable(

              header:Text("Questions"),
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
            ),
          );

        },
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