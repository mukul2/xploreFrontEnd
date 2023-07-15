import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../RestApi.dart';
import '../admin_drawer.dart';

class AllClasses extends StatefulWidget {
  const AllClasses({super.key});

  @override
  State<AllClasses> createState() => _AllStudentsState();
}
class MyData extends DataTableSource {
  Function onrelaod;
  MyData(this._data,this.onrelaod);
  final List _data;


  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]['name'])),

      DataCell(ElevatedButton(onPressed: (){
        print("delete press");
        Data().deleteClasses(id: _data[index]['id'].toString()).then((value) {
          onrelaod();


        });
      },child: Text("Delete"),)),

    ]);
  }
}
class _AllStudentsState extends State<AllClasses> {
  List data = [];
  downloadData(){
    Data().classes().then((value) {
      setState(() {
        data = value;
      });

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    downloadData();
  }
  @override
  Widget build(BuildContext context) {

    if(data.length>0){
            int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
            final DataTableSource _allUsers = MyData(data,(){
              downloadData();
            });

            return   Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: PaginatedDataTable2(

                    horizontalMargin: 20,
                    columnSpacing: 20,
                    renderEmptyRowsInTheEnd: false,
                    fit: FlexFit.tight,
                    border:true?null: TableBorder(
                        top:  BorderSide(color:  Colors.grey[300]!),
                        bottom: BorderSide(color: Colors.grey[300]!),
                        left: BorderSide(color: Colors.grey[300]!),
                        right: BorderSide(color: Colors.grey[300]!),
                        verticalInside: BorderSide(color: Colors.grey[300]!),
                        horizontalInside: const BorderSide(color: Colors.grey, width: 0.5)),
                    sortArrowIcon: Icons.keyboard_arrow_up, // custom arrow
                    sortArrowAnimationDuration:
                    const Duration(milliseconds: 0),
                    header:Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        Container(height: 45,width: 300,child: TextFormField(decoration: InputDecoration(
                          hintText: "Search"
                        ),)),
                        ElevatedButton(onPressed: (){
                          TextEditingController c = TextEditingController();
                          showDialog(
                              context: context,
                              builder: (_) =>AlertDialog(title: Text("Create Class"),actions: [
                                ElevatedButton(onPressed: (){

                                  Data().saveClasses(data: {"name":c.text,"created_by":FirebaseAuth.instance.currentUser==null?null:FirebaseAuth.instance.currentUser!.uid}).then((value) {
                                    downloadData();
                                    Navigator.pop(context);
                                  });



                                }, child: Text("Create Class")),
                              ],content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(controller:c ,decoration: InputDecoration(hintText: "Class name"),),
                              ),));

                        }, child: Text("Create Class")),
                      ],),
                    ),
                    rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,
                    empty: Center(
                        child: Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.grey[200],
                            child: const Text('No data'))),
                    columns: const [
                      DataColumn(label: Text('Class',style: TextStyle(color: Colors.blue),)),
                      DataColumn(label: Text('Actions',style: TextStyle(color: Colors.blue),)),


                    ],

                    source:_allUsers,
                  )
              ),
            );

          }else{
            return Card(child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      Container(height: 45,width: 300,child: TextFormField(decoration: InputDecoration(
                          hintText: "Search"
                      ),)),
                      ElevatedButton(onPressed: (){
                        TextEditingController c = TextEditingController();
                        showDialog(
                            context: context,
                            builder: (_) =>AlertDialog(title: Text("Create Class"),actions: [
                              ElevatedButton(onPressed: (){

                                Data().saveClasses(data: {"name":c.text,"created_by":FirebaseAuth.instance.currentUser==null?null:FirebaseAuth.instance.currentUser!.uid}).then((value) {
                                  downloadData();
                                  Navigator.pop(context);
                                });



                              }, child: Text("Create Class")),
                            ],content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(controller:c ,decoration: InputDecoration(hintText: "Class name"),),
                            ),));

                      }, child: Text("Create Class")),
                    ],),
                  ),
                ),
                Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("No Data"),
                ),),
              ],
            ),);
          }



  }
}
