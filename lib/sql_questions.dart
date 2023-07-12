import 'dart:convert';
import 'dart:html';

import 'package:admin/students_activity.dart';
import 'package:admin/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
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
      // Questionprovider
      DataCell(Consumer<Questionprovider>(
    builder: (_, bar, __) =>Checkbox(value: bar.items.contains(_data[index]['id']), onChanged: (bool? b){

      if(bar.items.contains(_data[index]['id'])){
        bar.removeData(_data[index]['id'],_data[index]);
      }else{
        bar.addData(_data[index]['id'],_data[index]);
      }

    }))),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300,minWidth: 100), child: Text(_data[index]['class'].toString()))),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300,minWidth: 100), child: Text(_data[index]['subject'].toString()))),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300,minWidth: 100), child: Text(_data[index]['chapter'].toString()))),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300,minWidth: 100), child: Text(_data[index]['title']??"--"))),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300,minWidth: 100), child: Text(_data[index]['q'].toString()??"--"))),
      DataCell(Text(_data[index]['ans']??"--")),
      DataCell(ElevatedButton(onPressed: (){
//saveoptions
      List newOptions = [];
      List allOptions = [];
        //options
        showDialog(
            context: context,
            builder: (_) => StatefulBuilder(
              builder: (context,setS) {
                return AlertDialog(backgroundColor:Colors.grey.shade50,actions: [
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("Close")),
                  TextButton(onPressed: (){

                    Map data = {"id":_data[index]['id'].toString(),"options":newOptions};
                    print(data);



                 Data().saveoptions(data: data).then((value) {
                      Navigator.pop(context);

                    });

                  }, child: Text("Update",style: TextStyle(color: Colors.redAccent),)),
                ],title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Text("Question"),
                  IconButton(onPressed: (){
                    Navigator.pop(context);

                  },  icon: Icon(Icons.close))
                ],),
                  content:Container(color:Colors.grey.shade50,width:  MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,
                    child:true?Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 600,child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(margin: EdgeInsets.all(2),decoration:boxShadow,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Question Title (Optional)"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField( keyboardType: TextInputType.multiline,
                                      maxLines: null,initialValue:_data[index]['title']??"--" ,enabled: false,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                      //  label: Text("Title")
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                            Container(margin: EdgeInsets.all(2),decoration:boxShadow,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Question (Mandatory)"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField( keyboardType: TextInputType.multiline,
                                      maxLines: null,initialValue:_data[index]['q']??"--" ,enabled: false,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                         // label: Text("Question")
                                      ),),
                                  ),
                                ],
                              ),
                            ),
                            // Row(
                            //   children: [
                            //     Text(_data[index]['title']??"--",style: TextStyle(color: Colors.black54,fontSize:15 ),),
                            //   ],
                            // ),

                            // Row(
                            //   children: [
                            //     Text(_data[index]['q']??"--",style: TextStyle(color: Colors.black54,fontSize:15 ),),
                            //   ],
                            // ),
                            Container(margin: EdgeInsets.all(2),decoration:boxShadow,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Right answer"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField( keyboardType: TextInputType.multiline,
                                      maxLines: null,initialValue:_data[index]['ans']??"--" ,enabled: false,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                      // label: Text("Question")
                                    ),),
                                  ),
                                ],
                              ),
                            ),


                          ],
                        ),),
                        Expanded(
                          child: Container(decoration: boxShadow,margin: EdgeInsets.all(2),child:Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Options"),
                                    ElevatedButton(onPressed: (){

                                      setS(() {
                                        newOptions.add("");
                                      });
                                    }, child: Text("Add option"))
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  FutureBuilder(

                                      future:Data().options(id: _data[index]['id'].toString()),
                                      builder: (context, AsyncSnapshot<List> snap) {
                                        if(snap.hasData && snap.data!.length>0){
                                          allOptions = snap.data!;
                                          //    return Text(snap.data!.toString());
                                          return ListView.builder(shrinkWrap: true,
                                              itemCount: allOptions.length,
                                              itemBuilder: (BuildContext context, int index) {
                                            try{
                                              return Container(margin: EdgeInsets.all(5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(color: Colors.blue,width: 0.3)),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                                  child: Row(children: [
                                                    Text( allOptions[index]["body"],style: TextStyle(color: Colors.blue),),
                                                  ],),
                                                ),
                                              );
                                            }catch(e){
                                              return Container(height: 0,width: 0,);
                                            }

                                              });
                                          return Wrap(children: allOptions.map((e) => Container(margin: EdgeInsets.all(5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                              border: Border.all(color: Colors.blue,width: 0.3)),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
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
                                  ListView.builder(shrinkWrap: true,
                                      itemCount: newOptions.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Container(margin: EdgeInsets.all(0),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                            child:true?TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 8,)),initialValue:newOptions[index] ,onChanged: (String s){
                                              newOptions[index] = s ;
                                            },): Row(children: [
                                              Text( newOptions[index]["body"],style: TextStyle(color: Colors.blue),),
                                            ],),
                                          ),
                                        );
                                      }),
                                  // Wrap(children: newOptions.map((e) => Container(margin: EdgeInsets.all(5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                  //     border: Border.all(color: Colors.blue,width: 0.3)),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 10),
                                  //     child: Row(children: [
                                  //       Text( e["body"],style: TextStyle(color: Colors.blue),),
                                  //     ],),
                                  //   ),
                                  // )).toList(),),
                                ],
                              ),
                            ],
                          ) ,),
                        ),

                      ],
                    ):
                    Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(initialValue:_data[index]['title']??"--" ,enabled: false,decoration: InputDecoration(label: Text("Title")),),
                        ),
                        // Row(
                        //   children: [
                        //     Text(_data[index]['title']??"--",style: TextStyle(color: Colors.black54,fontSize:15 ),),
                        //   ],
                        // ),
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
                  ),
                );
              }
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
    Provider.of<QuestionSortsprovider>(context, listen: false).class_id = null;
    Provider.of<QuestionSortsprovider>(context, listen: false).subject_id = null;
    Provider.of<QuestionSortsprovider>(context, listen: false).chapter_id = null;
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
    return Scaffold(backgroundColor: Colors.grey.shade50,
      appBar: false?null: PreferredSize(preferredSize: Size(0,120),child: Card(margin: EdgeInsets.zero,shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
         child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 20),
           child: Column(
             children: [
               Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Text("Question management",style: TextStyle(fontSize: 25),),
                  ElevatedButton(onPressed: (){
                    TextEditingController c = TextEditingController();


                    showDialog(
                        context: context,
                        builder: (_) =>AlertDialog(backgroundColor:  Colors.grey.shade50,content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Create_question(),
                        ),));

                  }, child: Text("Create Question"))
                ],),
        ),
               Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ClassSelectDropdown(onSelected: (String id){
                            print("class selested "+id);
                            Provider.of<QuestionSortsprovider>(context, listen: false).class_id =  int.parse(id);
                            // selectedClassId = id;
                          },),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SubjectSelectDropdown(onSelected: (String id){
                            print("sub selested "+id);
                            Provider.of<QuestionSortsprovider>(context, listen: false).subject_id =  int.parse(id);

                            // selectedClassId = id;
                          },),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ChapterSelectDropdown(onSelected: (String id){
                            print("class selested "+id);
                            Provider.of<QuestionSortsprovider>(context, listen: false).class_id =  int.parse(id);
                            // selectedClassId = id;
                          },),
                        ),
                      ),
                    ],
                  )
             ],
           ),
         ),
      ),),
      body: true? true?Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Consumer<Questionsprovider>(
          builder: (_, bar, __) {

            if(bar.items.isEmpty)return Center(child: Text("No data"),);


            return  Consumer<QuestionSortsprovider>(
                builder: (_, bar1, __) {


                  List sorted = [];

                  if(bar1.class_id==null){
                    sorted.addAll(bar.items);
                  }else  if(bar1.class_id==0){
                    sorted.addAll(bar.items);
                  }else{
                    for(int i = 0 ; i < bar.items.length ; i++){

                      if(bar.items[i]["class_id"] == bar1.class_id){
                        sorted.add(bar.items[i]);
                      }

                    }
                  }

                  List passedClss = sorted;

                  if(bar1.subject_id==null){
                    sorted = passedClss;
                  }else  if(bar1.subject_id==0){
                    sorted = passedClss;
                    //sorted.addAll(bar.items);
                  }else{
                    List newSorted = [];
                    for(int i = 0 ; i < passedClss.length ; i++){

                      if(passedClss[i]["subject_id"] == bar1.subject_id){
                        newSorted.add(passedClss[i]);
                      }

                    }
                    sorted = newSorted;

                  }

                  List passedSubject = sorted;


                  if(bar1.chapter_id==null){
                    sorted = passedSubject;
                  }else  if(bar1.chapter_id==0){
                    sorted = passedSubject;
                    //sorted.addAll(bar.items);
                  }else{
                    List newSorted = [];
                    for(int i = 0 ; i < passedSubject.length ; i++){

                      if(passedSubject[i]["chapter_id"] == bar1.chapter_id){
                        newSorted.add(passedSubject[i]);
                      }

                    }
                    sorted = newSorted;

                  }



                  if(sorted.length == 0)return Center(child: Text("No data"),);




                  int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
                  final DataTableSource _allUsers = MyData(sorted,context);
                  return PaginatedDataTable(columnSpacing: 10,horizontalMargin: 10,showCheckboxColumn: true,showFirstLastButtons: true,

                    header:true?Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      Text("Questions"),
                      Row(children: [
                        Consumer<Questionprovider>(
                            builder: (_, bar, __) =>bar.items.isEmpty?Container(height: 0,width: 0,):ElevatedButton(onPressed: () async {
                              final pdf = pw.Document();
                              List<pw.Widget> allwidgets = [];
                              List<pw.Widget> allAnswers = [];
                              List<pw.Widget> qustions = [];

                              for(int i = 0 ; i <bar.data.length ; i++ ){
                                qustions.add( pw.Text(bar.data[i]["q"]));
                                qustions.add( pw.Text(bar.data[i]["title"]));

                                List<pw.Widget> r = [];

                               List options = await Data().options(id:bar.data[i]['id'].toString());
                               List<pw.Widget> allOptions= [];
                               for(int j = 0 ; j < options.length;j++){
                                 allOptions.add(pw.Expanded(child: pw.Text(options[j]["body"])));
                               }
                                qustions.add(pw.Row(children:allOptions ));

                                // for(int j = 0 ; j <bar.selectedQuestionsBody[i].get("choice").length ; j++ ){
                                //   r.add(pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,children: [pw.Container(margin: pw.EdgeInsets.only(left: 5,right: 5),height: 10,width: 10,decoration: pw.BoxDecoration(border: pw.Border.all())),pw.Text(bar.selectedQuestionsBody[i].get("choice")[j])]));
                                //   // r.add(pw.Row(children: [pw.Container(margin: pw.EdgeInsets.only(left: 5,right: 5),height: 10,width: 10,decoration: pw.BoxDecoration(border: pw.Border.all())),pw.Text(bar.selectedQuestionsBody[i].get("choice")[j])]));
                                // }
                                // allwidgets.add(
                                //     pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.start,
                                //         children: [
                                //           pw.Padding(padding: pw.EdgeInsets.only(top: 5,bottom: 2),child: pw.Text(bar.selectedQuestionsBody[i].get("title")),),
                                //           pw.Padding(padding: pw.EdgeInsets.only(top: 2,bottom: 5),child: pw.Text(bar.selectedQuestionsBody[i].get("q")),),
                                //
                                //           pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start,children: r)
                                //         ]
                                //     )
                                // );
                              }

                              List<List<pw.Widget>> colums = [];
                              int currentPara = 0 ;
                              List<pw.Widget> sss = [];
                              sss.add(pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Text("Text 1 "),
                                    pw.Text("Text 2 "),
                                    pw.Text("Text 3 "),
                                    pw.Container(height: 5,width: 600,color: PdfColors.grey),
                                  ]
                              ));
                              for(int i = 0 ; i < allwidgets.length ; i += 2){
                                List<pw.Widget> lll = [];
                                lll.add(pw.Expanded(child: allwidgets[i]));
                                lll.add(pw.Expanded(child: allwidgets[i+1]));
                                sss.add(pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.start,children: lll));

                                // if(colums[currentPara].length<2){
                                //   colums[currentPara].add(allwidgets[i]);
                                //
                                // }else{
                                //   currentPara++;
                                //   colums[currentPara].add(allwidgets[i]);
                                // }


                              }

                              // for(int i = 0 ; i < colums.length ; i++){
                              //   sss.add(pw.Row(children:colums[i] ));
                              // }







                              pdf.addPage(
                                pw.MultiPage(margin: pw.EdgeInsets.all(10),
                                  pageFormat: PdfPageFormat.a4,
                                  build: (context) => qustions,//here goes the widgets list
                                ),
                              );
                              pdf.addPage(
                                pw.MultiPage(margin: pw.EdgeInsets.all(20),
                                  pageFormat: PdfPageFormat.a4,
                                  build: (context) => allAnswers,//here goes the widgets list
                                ),
                              );
                              //allAnswers
                              // P
                              Uint8List uint8list2 =await pdf.save();
                              print("PDf gen compleate");
                              String content = base64Encode(uint8list2);
                              final anchor = AnchorElement(
                                  href:
                                  "data:application/octet-stream;charset=utf-16le;base64,$content")
                                ..setAttribute(
                                    "download",
                                    "file.pdf")
                                ..click();//



                            }, child: Text("Download PDF("+bar.items.length.toString()+")"))),
                      ],),

                    ],):Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClassSelectDropdown(onSelected: (String id){
                              print("class selested "+id);
                              Provider.of<QuestionSortsprovider>(context, listen: false).class_id =  int.parse(id);
                              // selectedClassId = id;
                            },),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SubjectSelectDropdown(onSelected: (String id){
                              print("class selested "+id);

                              // selectedClassId = id;
                            },),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ChapterSelectDropdown(onSelected: (String id){
                              print("class selested "+id);

                              // selectedClassId = id;
                            },),
                          ),
                        ),
                      ],
                    ),
                    rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

                    columns:  [
                      DataColumn(label:Checkbox(value: false, onChanged: (bool? b){

                      })),
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
                  );
                });



          },
        ),
      ):Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Consumer<Questionsprovider>(
          builder: (_, bar, __) {

            if(bar.items.isEmpty)return Center(child: Text("No data"),);


          return  Consumer<QuestionSortsprovider>(
            builder: (_, bar1, __) {


              List sorted = [];

              if(bar1.class_id==null){
                sorted.addAll(bar.items);
              }else  if(bar1.class_id==0){
                sorted.addAll(bar.items);
              }else{
                for(int i = 0 ; i < bar.items.length ; i++){

                  if(bar.items[i]["class_id"] == bar1.class_id){
                    sorted.add(bar.items[i]);
                  }

                }
              }

              List passedClss = sorted;

              if(bar1.subject_id==null){
                sorted = passedClss;
              }else  if(bar1.subject_id==0){
                sorted = passedClss;
                //sorted.addAll(bar.items);
              }else{
                List newSorted = [];
                for(int i = 0 ; i < passedClss.length ; i++){

                  if(passedClss[i]["subject_id"] == bar1.subject_id){
                    newSorted.add(passedClss[i]);
                  }

                }
                sorted = newSorted;

              }

              List passedSubject = sorted;


              if(bar1.chapter_id==null){
                sorted = passedSubject;
              }else  if(bar1.chapter_id==0){
                sorted = passedSubject;
                //sorted.addAll(bar.items);
              }else{
                List newSorted = [];
                for(int i = 0 ; i < passedSubject.length ; i++){

                  if(passedSubject[i]["chapter_id"] == bar1.chapter_id){
                    newSorted.add(passedSubject[i]);
                  }

                }
                sorted = newSorted;

              }



              if(sorted.length == 0)return Center(child: Text("No data"),);




              int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
              final DataTableSource _allUsers = MyData(sorted,context);
              return PaginatedDataTable(columnSpacing: 10,horizontalMargin: 0,showCheckboxColumn: true,showFirstLastButtons: true,

                header:true?null:Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClassSelectDropdown(onSelected: (String id){
                          print("class selested "+id);
                          Provider.of<QuestionSortsprovider>(context, listen: false).class_id =  int.parse(id);
                          // selectedClassId = id;
                        },),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SubjectSelectDropdown(onSelected: (String id){
                          print("class selested "+id);

                          // selectedClassId = id;
                        },),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChapterSelectDropdown(onSelected: (String id){
                          print("class selested "+id);

                          // selectedClassId = id;
                        },),
                      ),
                    ),
                  ],
                ),
                rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

                columns:  [
                  DataColumn(label:Checkbox(value: false, onChanged: (bool? b){

                  })),
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
              );
            });



          },
        ),
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