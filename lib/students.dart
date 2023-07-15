import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

class StudentsX extends StatefulWidget {
  @override
  State<StudentsX> createState() => _StudentsState();
}
// The "soruce" of the table
class MyData extends DataTableSource {
  MyData(this._data);
  final List<QueryDocumentSnapshot> _data;


  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index].get('firstname'))),
      DataCell(Text(_data[index].get("email"))),
      DataCell(Text(_data[index].get("user_id"))),
      DataCell(Text(_data[index].get("phone"))),
      DataCell(ElevatedButton(onPressed: (){},child: Text("Actions"),)),
      // DataCell(TextButton(onPressed: (){
      //   context!.showBottomSheet((context) => Container(height: MediaQuery.of(context).size.height,child: ListView(shrinkWrap: true,
      //     children: [
      //       InkWell(onTap: (){
      //         Navigator.pop(context);
      //       },
      //         child: Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Row(crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Icon(Icons.navigate_before),
      //               Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: Text("Close"),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //      // Text(_data[index].data().toString()),
      //       Padding(
      //         padding: const EdgeInsets.only(top: 15,left: 8,right: 8,bottom: 8),
      //         child: TextFormField(onChanged: (String s){
      //           _data[index].reference.update({"firstname":s});
      //         },initialValue:_data[index].get("firstname") ,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12),label: Text("First name of the student"),),),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: TextFormField(onChanged: (String s){
      //           _data[index].reference.update({"lastname":s});
      //         },initialValue:_data[index].get("lastname") ,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12),label: Text("Last name of the student"),),),
      //       ),
      //
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: TextFormField(onChanged: (String s){
      //           _data[index].reference.update({"father_name":s});
      //         },initialValue:_data[index].get("father_name") ,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12),label: Text("Father"),),),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: TextFormField(onChanged: (String s){
      //           _data[index].reference.update({"mother_name":s});
      //         },initialValue:_data[index].get("mother_name") ,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12),label: Text("Mother"),),),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: TextFormField(onChanged: (String s){
      //           _data[index].reference.update({"school":s});
      //         },initialValue:_data[index].get("school") ,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12),label: Text("School"),),),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: TextFormField(onChanged: (String s){
      //           _data[index].reference.update({"address":s});
      //         },initialValue:_data[index].get("address") ,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12),label: Text("Address"),),),
      //       ),
      //
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: TextFormField(onChanged: (String s){
      //           _data[index].reference.update({"email":s});
      //         },initialValue:_data[index].get("email") ,enabled: false,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12),label: Text("Email"),),),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: TextFormField(onChanged: (String s){
      //           _data[index].reference.update({"phone":s});
      //         },initialValue:_data[index].get("phone") ,enabled: false,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12),label: Text("Phone"),),),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: TextFormField(onChanged: (String s){
      //           _data[index].reference.update({"batch":s});
      //         },initialValue:_data[index].get("batch") ,enabled: false,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12),label: Text("Batch"),),),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.only(left: 8,top: 8),
      //         child: Text("Batch / Course"),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: FutureBuilder<QuerySnapshot>(
      //             future: FirebaseFirestore.instance.collection("courses").orderBy("course_title").get(), // a previously-obtained Future<String> or null
      //             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //               if(snapshot.hasData){
      //                 List<String>all = [];
      //                 List<String>allId = [];
      //                 for(int  i = 0; i < snapshot.data!.docs.length ; i++){
      //                   all.add(snapshot.data!.docs[i].get("course_title"));
      //                   allId.add(snapshot.data!.docs[i].id);
      //                 }
      //                // return Text(allId.toString());
      //
      //                 try{
      //                   return DropdownSearch<String>(
      //                     selectedItem:all[allId.indexOf(_data[index].get("batch"))] ,
      //                     onChanged: (String? s){
      //                       //controller3.text =allId[all.indexOf(s!)];
      //                         _data[index].reference.update({"batch":allId[all.indexOf(s!)]});
      //                     },
      //                     items: all,
      //                   );
      //                 }catch(e){
      //                   return DropdownSearch<String>(
      //
      //                     onChanged: (String? s){
      //                       //controller3.text =allId[all.indexOf(s!)];
      //                         _data[index].reference.update({"batch":allId[all.indexOf(s!)]});
      //                     },
      //                     items: all,
      //                   );
      //                 }
      //
      //
      //               }else{
      //                 return CupertinoActivityIndicator();
      //               }
      //             }),
      //       )
      //     ],
      //   ),));
      //
      // },child: Text("Edit"),)),
    ]);
  }
}
class _StudentsState extends State<StudentsX> {
  List<QueryDocumentSnapshot> searched = [];
  List<QueryDocumentSnapshot> all = [];
  bool loading = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection('users') .get().then((value) {

      setState(() {
        all = value.docs;
        searched=  all ;
        allUsers = MyData(searched);
        loading = false;
      });

    });
  }
  String key = "";
  DataTableSource? allUsers ;
  @override
  Widget build(BuildContext context) {

    return  Scaffold(appBar: PreferredSize(preferredSize: Size(0,60),child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(onChanged: (String s){

        key =s.trim();



        if(key.trim().length==0){
          setState(() {

            searched=  all ;
            allUsers = MyData(searched);

          });
        }else{
          searched= [];

          for(int j = 0 ; j < all.length ; j++){

            if(all[j].data().toString().toLowerCase().contains( key.toLowerCase())){
              searched.add(all[j]);
            }



          }


          setState(() {


            allUsers =MyData(searched);
          });

        }
      },decoration: InputDecoration(hintText: "Search  here",contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 15)),),
    ),),
      body: loading?Center(child: CircularProgressIndicator(),):PaginatedDataTable(
        // header: const Text("Reports"),
        rowsPerPage: (MediaQuery.of(context).size.height / 65).toInt(),
        columns:  [

          DataColumn(label: Text('First name')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('User id')),
          DataColumn(label:Text("Phone")),
          DataColumn(label:Text("Actions")),
          //   DataColumn(label: Text('Question')),
          //    DataColumn(label: Text('Question type')),
          //   DataColumn(label: Text('Score')),

          // DataColumn(label: Text('Id')),
          // DataColumn(label: Text('Phone'))
        ],
        source: allUsers!,
      ),
    );



  }
}
