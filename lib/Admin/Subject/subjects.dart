import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../RestApi.dart';
import '../../students_activity.dart';
import '../admin_drawer.dart';

class AllSubjects extends StatefulWidget {
  const AllSubjects({super.key});

  @override
  State<AllSubjects> createState() => _AllStudentsState();
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
      DataCell(Text(_data[index]['sName'])),
      DataCell(Text(_data[index]['name'].toString())),
      DataCell(ElevatedButton(onPressed: (){
        print("delete press");
        Data().deletesubject(id: _data[index]['sid'].toString()).then((value) {
          onrelaod();


        });
      },child: Text("Delete"),)),

    ]);
  }
}
class _AllStudentsState extends State<AllSubjects> {

  List data = [];
  downloadData(){
    Data().subjects().then((value) {
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
    ElevatedButton eb =   ElevatedButton(onPressed: (){
      TextEditingController c = TextEditingController();
      String selectedClassId= "";


      showDialog(
          context: context,
          builder: (_) =>AlertDialog(title: Text("Create Subject"),actions: [
            ElevatedButton(onPressed: (){

              Data().saveSubjects(data: {"class_id":selectedClassId,"name":c.text,}).then((value) {
                downloadData();

              });

              Navigator.pop(context);

            }, child: Text("Create Class")),
          ],content: Wrap(
            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClassSelectDropdown(onSelected: (String id){

                  selectedClassId = id;
                },),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(controller:c ,decoration: InputDecoration(hintText: "Subject"),),
              ),
            ],
          ),));

    }, child: Text("Create Subject"));

    if(data.length>0){
      int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
      final DataTableSource _allUsers = MyData(data,(){
        downloadData();
      });

      return   Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: PaginatedDataTable(

            //  horizontalMargin: 20,
            //  columnSpacing: 20,
             // renderEmptyRowsInTheEnd: false,


              header:Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Container(height: 45,width: 300,child: TextFormField(decoration: InputDecoration(
                      hintText: "Search"
                  ),)),
                  eb,
                ],),
              ),
              rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

              columns: const [
                DataColumn(label: Text('Subject',style: TextStyle(color: Colors.blue),)),
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
                eb,

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
