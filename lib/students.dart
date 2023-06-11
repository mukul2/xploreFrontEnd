import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

class Students extends StatefulWidget {
  const Students({Key? key}) : super(key: key);

  @override
  State<Students> createState() => _StudentsState();
}
// The "soruce" of the table
class MyData extends DataTableSource {
  MyData(this._data);
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
      DataCell(Text(_data[index].data()['firstname'])),
      DataCell(Text(_data[index].data()["email"])),
      DataCell(Text(_data[index].data()["user_id"])),
      DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}
class _StudentsState extends State<Students> {
  @override
  Widget build(BuildContext context) {

    return  StreamBuilder(

        stream:FirebaseFirestore.instance.collection('users') .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snap) {


          if(snap.hasData){
            final DataTableSource _allUsers = MyData(snap.data!.docs);
            return SingleChildScrollView(
              child: PaginatedDataTable(
                header: const Text("Students"),
                rowsPerPage: 15,
                columns: const [
                  DataColumn(label: Text('User Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('Phone'))
                ],
                source: _allUsers,
              ),
            );
          }
          else{
            return new Text('No data...');
          }
        });

    return FirestoreQueryBuilder<Map<String, dynamic>>(
      pageSize: 5,
      query: FirebaseFirestore.instance.collection('users'),
      builder: (context, snapshot, _) {
        return PaginatedDataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text('User Name'),
            ),
            DataColumn(
              label: Text('User email'),
            ),
            DataColumn(
              label: Text('User Id'),
            ),DataColumn(
              label: Text('User Id'),
            ),
          ],
          source: MyData(snapshot.docs),
         onPageChanged:(int i){
           snapshot.fetchMore();
         },
        );
      },
    );

    return  FirestoreListView<Map<String, dynamic>>(shrinkWrap: true,
      query: FirebaseFirestore.instance.collection("users").orderBy("create_date",descending: true),
      itemBuilder: (context, snapshot) {
        Map<String, dynamic> user = snapshot.data();
        return  Row(
          children: [

            Expanded(child: Text(user["firstname"])),
            Expanded(child: Text(user["email"])),
            Expanded(child: Text(user["phone"])),
            Expanded(child: Text(user["user_id"])),



          ],
        );

        return Text('User name is ${user['name']}');
      },
    );

  }
}
