import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:admin/questions_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'AppProviders/DrawerProvider.dart';
import 'all_questions.dart';
import 'create_quiz.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class tab_questions_list_items extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  tab_questions_list_items({required this.scaffoldKey});

  @override
  State<tab_questions_list_items> createState() => _tab_questions_list_itemsState();
}

class _tab_questions_list_itemsState extends State<tab_questions_list_items> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: PreferredSize(preferredSize: Size(0,130),
      child: Card(margin: EdgeInsets.zero,shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
        child: Container(height: 130,child: Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Questions",style: TextStyle(fontSize: 35),),
              Container(color: Colors.white,child: Row(
                children: [
                  InkWell( onTap: (){


                    widget.scaffoldKey.currentState!.showBottomSheet((context) => Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2),
                            topRight: Radius.circular(2),
                            bottomLeft: Radius.circular(2),
                            bottomRight: Radius.circular(2)
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset.zero, // changes position of shadow
                          ),
                        ],
                      ),
                      width: double.infinity,height: MediaQuery.of(context).size.height,
                      child: Create_quiz_activity(),
                    ));



                  },
                    child: Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.blue)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Create new question",style: TextStyle(color: Colors.blue),),
                      ),
                    ),
                  ),

                  Consumer<QuestionsSelectedProvider>(
                      builder: (_, bar, __) =>bar.selectedQuestions.length>0?Row(
                        children: [
                          InkWell( onTap: (){
                            TextEditingController c = TextEditingController();

                            showBottomSheet(
                                context:widget.scaffoldKey.currentState!.context,
                                builder: (context) =>SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text("Create new quiz"),
                                      TextField(controller: c,decoration: InputDecoration(label: Text("Title of the Quiz")),),
                                      ListView.builder(shrinkWrap: true,
                                        itemCount: bar.selectedQuestions.length,

                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                //bar.selectedQuestionsBody[index].get("choice")

                                                Row(
                                                  children: [
                                                    Text("TYPE :"),
                                                    Text(bar.selectedQuestionsBody[index].get("quize_type")=="SC"?"Single choice":"Multiple choice"),
                                                  ],
                                                ),

                                                Text("Question :"),
                                                HtmlWidget(bar.selectedQuestionsBody[index].get("q")),
                                                Text("Title :"),
                                                Text(bar.selectedQuestionsBody[index].get("title")),
                                                Text("Choices :"),
                                                ListView.builder(shrinkWrap: true,
                                                    itemCount: bar.selectedQuestionsBody[index].get("choice").length,
                                                    itemBuilder: (context, index2) {
                                                      return Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(color: Colors.blue),borderRadius: BorderRadius.circular(3) ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(bar.selectedQuestionsBody[index].get("choice")[index2]),
                                                        ),
                                                      );
                                                    }),
                                                // Wrap(children:bar.selectedQuestionsBody[index].get("choice").map((e) => Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(color: Colors.blue),borderRadius: BorderRadius.circular(3) ),
                                                //   child: Padding(
                                                //     padding: const EdgeInsets.all(8.0),
                                                //     child: Text(e),
                                                //   ),
                                                // )).toList() ,),


                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      InkWell( onTap: (){

                                        List allQ = [];

                                        for(int i = 0 ; i < bar.selectedQuestionsBody.length ; i++){
                                          allQ.add(bar.selectedQuestionsBody[i].data() as Map<String,dynamic>);
                                        }

                                        FirebaseFirestore.instance.collection("quizz2").add({"title":c.text,"questions":allQ,"totalMarks":bar.totalMarks});
                                        Navigator.pop(context);

                                      },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(color: Colors.blue,child: Padding(
                                            padding:  EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                                            child: Text("Create",style: TextStyle(color: Colors.white),),
                                          ),),
                                        ),
                                      ),


                                    ],
                                  ),
                                ));
                            if(false)  showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  child: Container(height: MediaQuery.of(context).size.height * 0.8,width: MediaQuery.of(context).size.width * 0.8 ,child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text("Create new quiz"),
                                        TextField(controller: c,decoration: InputDecoration(label: Text("Title of the Quiz")),),
                                        ListView.builder(shrinkWrap: true,
                                          itemCount: bar.selectedQuestions.length,

                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  //bar.selectedQuestionsBody[index].get("choice")

                                                  Row(
                                                    children: [
                                                      Text("TYPE :"),
                                                      Text(bar.selectedQuestionsBody[index].get("quize_type")=="SC"?"Single choice":"Multiple choice"),
                                                    ],
                                                  ),

                                                  Text("Question :"),
                                                  HtmlWidget(bar.selectedQuestionsBody[index].get("q")),
                                                  Text("Title :"),
                                                  Text(bar.selectedQuestionsBody[index].get("title")),
                                                  Text("Choices :"),
                                                  ListView.builder(shrinkWrap: true,
                                                      itemCount: bar.selectedQuestionsBody[index].get("choice").length,
                                                      itemBuilder: (context, index2) {
                                                        return Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(color: Colors.blue),borderRadius: BorderRadius.circular(3) ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(bar.selectedQuestionsBody[index].get("choice")[index2]),
                                                          ),
                                                        );
                                                      }),
                                                  // Wrap(children:bar.selectedQuestionsBody[index].get("choice").map((e) => Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(color: Colors.blue),borderRadius: BorderRadius.circular(3) ),
                                                  //   child: Padding(
                                                  //     padding: const EdgeInsets.all(8.0),
                                                  //     child: Text(e),
                                                  //   ),
                                                  // )).toList() ,),


                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        InkWell( onTap: (){

                                          List allQ = [];

                                          for(int i = 0 ; i < bar.selectedQuestionsBody.length ; i++){
                                            allQ.add(bar.selectedQuestionsBody[i].data() as Map<String,dynamic>);
                                          }

                                          FirebaseFirestore.instance.collection("quizz2").add({"title":c.text,"questions":allQ,"totalMarks":bar.totalMarks});
                                          Navigator.pop(context);

                                        },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(color: Colors.blue,child: Padding(
                                              padding:  EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                                              child: Text("Create",style: TextStyle(color: Colors.white),),
                                            ),),
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),),
                                )
                            );

                          },
                            child: Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.blue)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Generate new quiz",style: TextStyle(color: Colors.blue),),
                              ),
                            ),
                          ),
                          if(false) InkWell( onTap: (){
                            Map<String,dynamic> json = bar.selectedQuestionsBody[0].data() as Map<String,dynamic>;
                            json["created_at"] = DateTime.now().millisecondsSinceEpoch;

                            showBottomSheet(
                                context:widget.scaffoldKey.currentState!.context,
                                builder: (context) => Container(
                                    color: Colors.white,
                                    height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
                                    child: Column(
                                      children: [

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  IconButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  }, icon: Icon(Icons.arrow_back_rounded)),
                                                ],
                                              ),
                                              //bar.selectedQuestionsBody[index].get("choice")

                                              // Row(
                                              //   children: [
                                              //     Text("TYPE :"),
                                              //     Text(json["quize_type"]=="SC"?"Single choice":"Multiple choice"),
                                              //   ],
                                              // ),


                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Question")),onChanged: (String d){
                                                  json["q"] = d;
                                                },initialValue:json["q"] ,),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Title")),onChanged: (String d){
                                                  json["title"] = d;
                                                },initialValue:json["title"] ,),
                                              ),
                                              ListView.builder(shrinkWrap: true,
                                                  itemCount: json["choice"].length,
                                                  itemBuilder: (context, index2) {
                                                    return Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child:  TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Option "+(index2+1).toString())),onChanged: (String d){
                                                        json["choice"][index2] = d;
                                                      },initialValue:json["choice"][index2]),
                                                    );
                                                  }),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Correct ans")),onChanged: (String d){
                                                  json["ans"] = d;
                                                },initialValue:json["ans"] ,),
                                              ),

                                              InkWell(onTap: (){
                                                FirebaseFirestore.instance.collection("questions").add(json);
                                                FirebaseFirestore.instance.collection("questions").add(json);
                                                Navigator.pop(context);


                                              },
                                                child: Card(color: Colors.blue,child: Center(child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("Save",style: TextStyle(color: Colors.white),),
                                                ),),),
                                              ),
                                              // Wrap(children:bar.selectedQuestionsBody[index].get("choice").map((e) => Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(color: Colors.blue),borderRadius: BorderRadius.circular(3) ),
                                              //   child: Padding(
                                              //     padding: const EdgeInsets.all(8.0),
                                              //     child: Text(e),
                                              //   ),
                                              // )).toList() ,),


                                            ],
                                          ),
                                        ),

                                      ],
                                    ))));




                          },
                            child: Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.blue)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Duplicate and edit",style: TextStyle(color: Colors.blue),),
                              ),
                            ),
                          ),
                          Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.blue)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Total Question : "+bar.selectedQuestions.length.toString(),style: TextStyle(color: Colors.blue),),
                            ),
                          ),
                          Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.blue)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Total Marks : "+bar.totalMarks.toString(),style: TextStyle(color: Colors.blue),),
                            ),
                          ),
                          InkWell( onTap: () async {
                            final pdf = pw.Document();
                            List<pw.Widget> allwidgets = [];
                            List<pw.Widget> allAnswers = [];

                            for(int i = 0 ; i <bar.selectedQuestions.length ; i++ ){
                              allAnswers.add(pw.Row(
                                  children: [
                                    pw.Text((i+1).toString()),
                                    pw.Text("  :   "),
                                    pw.Text(bar.selectedQuestionsBody[i].get("ans"))
                                  ]
                              ));

                              List<pw.Widget> r = [];

                              for(int j = 0 ; j <bar.selectedQuestionsBody[i].get("choice").length ; j++ ){
                                r.add(pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,children: [pw.Container(margin: pw.EdgeInsets.only(left: 5,right: 5),height: 10,width: 10,decoration: pw.BoxDecoration(border: pw.Border.all())),pw.Text(bar.selectedQuestionsBody[i].get("choice")[j])]));
                                // r.add(pw.Row(children: [pw.Container(margin: pw.EdgeInsets.only(left: 5,right: 5),height: 10,width: 10,decoration: pw.BoxDecoration(border: pw.Border.all())),pw.Text(bar.selectedQuestionsBody[i].get("choice")[j])]));
                              }
                              allwidgets.add(
                                  pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Padding(padding: pw.EdgeInsets.only(top: 5,bottom: 2),child: pw.Text(bar.selectedQuestionsBody[i].get("title")),),
                                        pw.Padding(padding: pw.EdgeInsets.only(top: 2,bottom: 5),child: pw.Text(bar.selectedQuestionsBody[i].get("q")),),

                                        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start,children: r)
                                      ]
                                  )
                              );
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
                                build: (context) => sss,//here goes the widgets list
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


                          },
                            child: Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.blue)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Download PDF : ",style: TextStyle(color: Colors.blue),),
                              ),
                            ),
                          ),
                        ],
                      ):Container(height: 0,width: 0,)),
                ],
              )),

            ],
          ),
        )),
      ),),body:   true?QuestionsTable(scaffoldKey: widget.scaffoldKey,):  FirestoreQueryBuilder(pageSize: 20,
      //.where("quize_type",isEqualTo: "SC")
      query: FirebaseFirestore.instance.collection("questions").orderBy("created_at",descending: true) ,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return Center(child: const Text("Please wait"));
        }
        if (snapshot.hasError) {
          return Text('error ${snapshot.error}');
        }

        return ListView.separated(shrinkWrap: true,
          itemCount: snapshot.docs.length,
          itemBuilder: (context, index) {
            // if we reached the end of the currently obtained items, we try to
            // obtain more items
            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
              // Tell FirestoreQueryBuilder to try to obtain more items.
              // It is safe to call this function from within the build method.
              snapshot.fetchMore();
            }

            final data = snapshot.docs[index];
            //QuestionsSelectedProvider
            return  Consumer<QuestionsSelectedProvider>(
                builder: (_, bar, __) =>Row(
                  children: [
                    if(false)  Container(margin: EdgeInsets.all(5), decoration: BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.circular(2)),child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(data.get("quize_type"),style: TextStyle(color: Colors.white),),
                    )),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Checkbox(value: bar.selectedQuestions.contains(data.id),onChanged: (val){
                        if(val!){
                          bar.add(data.id,data);
                          //Provider.of<QuestionsSelectedProvider>(context, listen: false).

                        }else{
                          bar.remove(data.id);
                        }

                      },),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: data.get("title").toString().length==0? Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.get("title")),
                          HtmlWidget(data.get("q")),
                        ],
                      ):Text(data.get("title")),
                    ),

                  ],
                ));

          }, separatorBuilder: (BuildContext context, int index) { return Container(height: 0.5,width: double.infinity,); },
        );
      },
    ),);
    return Expanded(
      child: FirestoreQueryBuilder(pageSize: 20,
        query: FirebaseFirestore.instance.collection( "questions").where("quize_type",isEqualTo: "SC") ,
        builder: (context, snapshot, _) {
          if (snapshot.isFetching) {
            return Center(child: const Text("Please wait"));
          }
          if (snapshot.hasError) {
            return Text('error ${snapshot.error}');
          }

          return ListView.separated(padding: EdgeInsets.all(10), shrinkWrap: true,
            itemCount: snapshot.docs.length,
            itemBuilder: (context, index) {
              // if we reached the end of the currently obtained items, we try to
              // obtain more items
              if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                // Tell FirestoreQueryBuilder to try to obtain more items.
                // It is safe to call this function from within the build method.
                snapshot.fetchMore();
              }

              final data = snapshot.docs[index];
             // ccc = context;
              //QuestionsSelectedProvider
              return  HoverButtons(data: data,onCl: (String d){

              },);

            }, separatorBuilder: (BuildContext context, int index) { return Container(height: 0.5,width: double.infinity,color: Colors.grey,); },
          );
        },
      ),
    );
  }
}
