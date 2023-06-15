import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:provider/provider.dart';

import 'AppProviders/DrawerProvider.dart';
import 'edit_question_activity.dart';

class QuestionsTable extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  QuestionsTable({required this.scaffoldKey});
  @override
  State<QuestionsTable> createState() => _StudentsState();
}
// The "soruce" of the table
class MyData extends DataTableSource {
  MyData(this._data,this.key);
  GlobalKey<ScaffoldState> key;
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
      DataCell(Text(_data[index].get('title'))),
      DataCell(Text(_data[index].get('q'))),
       DataCell(Text(_data[index].get("quize_type"))),
       DataCell(Text(_data[index].get("score").toString())),
       DataCell(TextButton(onPressed: (){



         //_data[index].reference



         key.currentState!.showBottomSheet((context) => Container(
           color: Colors.white,
           height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
           child:   StreamBuilder(

               stream:_data[index].reference.snapshots(),
               builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {


                 if(snap.hasData){

                   List ch =   snap.data!.get("choice");
                   return  Column(
                     children: [
                       Row(
                         children: [
                           IconButton(onPressed: (){
                             Navigator.pop(context);
                           }, icon: Icon(Icons.arrow_back_rounded)),
                         ],
                       ),

                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Question")),onChanged: (String d){
                           snap.data!.reference.update({"q":d});
                         },initialValue:snap.data!.get("q") ,),
                       ),

                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Title")),onChanged: (String d){
                           snap.data!.reference.update({"title":d});

                         },initialValue:snap.data!.get("title") ,),
                       ),

                       ListView.builder(shrinkWrap: true,
                           itemCount:ch.length,
                           itemBuilder: (context, index2) {
                             return Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: true?  true?Row(
                                 children: [
                                   Checkbox(value:  index2 == (snap.data!["correctOption"]??0) , onChanged: (bool? changed){

                                     if(changed == true)snap.data!.reference.update({"correctOption":index2});

                                   }),
                                   Text(ch[index2]),
                                 ],
                               ): CheckboxListTile(title: Text(ch[index2]),value: true, onChanged:(bool? b){

                               } ): TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Option "+(index2+1).toString())),onChanged: (String d){
                                 ch[index2] = d;
                               },initialValue:ch[index2]),
                             );
                           }),

                       // Padding(
                       //   padding: const EdgeInsets.all(8.0),
                       //   child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Correct ans")),onChanged: (String d){
                       //     json["ans"] = d;
                       //   },initialValue:json["ans"] ,),
                       // ),

                       TextButton(onPressed: (){
                         snap.data!.reference.update({"choice":ch});
                         // data.reference.update(json);

                         Navigator.pop(context);
                       }, child: Text("Close")),





                     ],
                   );
                 }else{
                   return Center(child: CircularProgressIndicator(),);
                 }}),
         ),
         ));




       },child: Text("Edit"),)),

   if(false)   DataCell(TextButton(onPressed: (){

        key.currentState!.showBottomSheet((context) => Container(height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
          child: Column(
            children: [
              Card(margin: EdgeInsets.zero,shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ) ,
                child: Padding(
                  padding:  EdgeInsets.only(bottom: 10,top: 15),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell( onTap: (){

                        Provider.of<QuestionsSelectedProvider>(context, listen: false).totalMarks = 0;
                        Provider.of<QuestionsSelectedProvider>(context, listen: false).selectedQuestionsBody =[];
                        Provider.of<QuestionsSelectedProvider>(context, listen: false).selectedQuestions = [];

                        Navigator.pop(context);
                      },
                        child: Row(
                          children: [
                            Icon(Icons.navigate_before,color: Colors.blue,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("Close",style: TextStyle(color: Colors.blue),),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text("Edit",style: TextStyle(fontSize: 25),),
                      ),
                    ],
                  ),
                ),
              ),

              Container(height: 25,),
              Edit_quiz_activity(ref:_data[index]),

            ],
          ),
        ),));

      },child: Text("Edit"),)),
      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}


class _StudentsState extends State<QuestionsTable> {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(

        stream:FirebaseFirestore.instance.collection("questions").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snap) {

          int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;

        //  final DataTableSource _allUsers = MyData(snap.data!.docs,widget.scaffoldKey);

          if(snap.hasData && snap.data!.docs.length>0){
            final DataTableSource _allUsers = MyData(snap.data!.docs,widget.scaffoldKey);
            return SingleChildScrollView(
              child: PaginatedDataTable(
                header: null,
                rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,
                columns: const [
                  DataColumn(label: Text('Question title')),
                  DataColumn(label: Text('Question')),
                   DataColumn(label: Text('Question type')),
                   DataColumn(label: Text('Score')),
                   DataColumn(label: Text('Actions')),

                  // DataColumn(label: Text('Id')),
                  // DataColumn(label: Text('Phone'))
                ],
                source: _allUsers,
              ),
            );
          }
          else{
            return Center(child: new Text('No data...'));
          }
        });



  }
}
