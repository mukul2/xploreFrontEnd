import 'package:admin/styles.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../RestApi.dart';
import '../admin_drawer.dart';

class Teachers extends StatefulWidget {
  const Teachers({super.key});

  @override
  State<Teachers> createState() => _TeachersState();
}
class MyData extends DataTableSource {
  MyData(this._data);
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
      DataCell(Text(_data[index]['LastName'])),
      DataCell(Text(_data[index]["FirstName"])),
      DataCell(Text(_data[index]["Address"])),
      DataCell(Text(_data[index]["Email"])),
      DataCell(Text(_data[index]["Phone"])),
      DataCell(ElevatedButton(onPressed: (){},child: Text("Actions"),)),

    ]);
  }
}
class _TeachersState extends State<Teachers> {
  @override
  Widget build(BuildContext context) {
    //teachers
   return FutureBuilder<List>(
        future: Data().teachers(), // a previously-obtained Future<String> or null
    builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if(snapshot.hasData){

            int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
            final DataTableSource _allUsers = MyData(snapshot.data!);

            return   Padding(
              padding: const EdgeInsets.all(8.0),
              child: Theme(data: Theme.of(context).copyWith(
                cardTheme: CardTheme(color: Colors.white,
                  elevation: 3, // remove shadow
                  margin: const EdgeInsets.all(0), // reset margin
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // Change radius
                  ),
                ),
              ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: PaginatedDataTable2(

                    horizontalMargin: 20,
                 //   checkboxHorizontalMargin: 12,
                    columnSpacing: 20,
                 // wrapInCard: false,
                    renderEmptyRowsInTheEnd: false,
                    //headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!),




                  //  minWidth: 800,
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
                    const Duration(milliseconds: 0), // custom animation duration



                    header:null,
                    rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

                    columns: const [
                      DataColumn(label: Text('LastName',style: TextStyle(color: Colors.blue),)),
                      DataColumn(label: Text('FirstName',style: TextStyle(color: Colors.blue),)),
                      DataColumn(label: Text('Address',style: TextStyle(color: Colors.blue),)),
                      DataColumn(label: Text('Email',style: TextStyle(color: Colors.blue),)),
                      DataColumn(label: Text('Phone',style: TextStyle(color: Colors.blue),)),
                      DataColumn(label: Text('Actions',style: TextStyle(color: Colors.blue),)),

                      // DataColumn(label: Text('Id')),
                      // DataColumn(label: Text('Phone'))
                    ],
                    source: _allUsers,
                  )
                ),
              ),
            );
            return   Container(margin: EdgeInsets.all(20),decoration: boxShadow2,
              child: PaginatedDataTable(columnSpacing: 10,horizontalMargin: 5,

                header:null,
                rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

                columns: const [
                  DataColumn(label: Text('LastName',style: TextStyle(color: Colors.blue),)),
                  DataColumn(label: Text('FirstName',style: TextStyle(color: Colors.blue),)),
                  DataColumn(label: Text('Address',style: TextStyle(color: Colors.blue),)),
                  DataColumn(label: Text('Email',style: TextStyle(color: Colors.blue),)),
                  DataColumn(label: Text('Phone',style: TextStyle(color: Colors.blue),)),
                  DataColumn(label: Text('Actions',style: TextStyle(color: Colors.blue),)),

                  // DataColumn(label: Text('Id')),
                  // DataColumn(label: Text('Phone'))
                ],
                source: _allUsers,
              ),
            );
          }else{
            return Center(child: CircularProgressIndicator(),);
          }


    });

    return Scaffold(body: Center(child: Text("Teachers"),),);
  }
}
