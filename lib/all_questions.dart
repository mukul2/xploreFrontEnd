import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:admin/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';

import 'AppProviders/DrawerProvider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:pdf/widgets.dart' as pw;
class Questions_All extends StatefulWidget {
  questionbank type ;
  Questions_All({required this.type});

  @override
  State<Questions_All> createState() => _Questions_AllState();
}
enum questionType{singleChoice,multipleChoice}
class _Questions_AllState extends State<Questions_All> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext? ccc;
  questionType qt = questionType.singleChoice;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AddedProvider>(context, listen: false).questions = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: PreferredSize(preferredSize: Size(0,60),child: Container(height: 60,child: Column(
      children: [
        Container(color: Colors.white,height: 59,child: Row(
          children: [
            InkWell( onTap: (){

              BuildContext cN ;

              showBottomSheet(
                  context:ccc??context,
                  builder: (context) {
                    cN = context;
                    return Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(children: [
                            Padding(
                              padding:  EdgeInsets.only(bottom: 10),
                              child: InkWell( onTap: (){
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
                            ),
                            Row(
                              children: [
                                Expanded(flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Title")),),
                                  ),
                                ),
                                Expanded(flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Number of quiz takes")),),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Course")),),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Eaxm Duration Time(H:M:S)")),),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Total Exam Marks")),),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Pass Mark")),),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Exam Start Date")),),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Exam End Date")),),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Published")),),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    // child: TextField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Pass Mark")),),
                                  ),
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(minLines: 7,maxLines: 10,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),label: Text("Quiz Content")),),
                            ),
                            Consumer<AddedProvider>(
                              builder: (_, bar, __) =>ListView.builder(shrinkWrap: true,
                                  itemCount:bar.questions.length,

                                  itemBuilder: (context, index) {
                                    return Container(margin: EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.grey)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Question title",style: TextStyle(color: Colors.grey),),
                                                TextButton(onPressed: (){}, child: Text("Edit"))
                                              ],
                                            ),
                                            Text(bar.questions[index]["title"]),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10),
                                              child: Text("Question",style: TextStyle(color: Colors.grey),),
                                            ),

                                            Text( bar.questions[index]["q"]),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10),
                                              child: Text("Options",style: TextStyle(color: Colors.grey),),
                                            ),

                                             ListView.builder(shrinkWrap: true,
                                              itemCount:  bar.questions[index]["choice"].length,

                                              itemBuilder: (context, index2) {
                                                return  Container(margin:EdgeInsets.symmetric(vertical: 5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: Colors.grey.shade100),width: 300,
                                                  child: true?CheckboxListTile(title: Text( bar.questions[index]["choice"][index2]),value: index2 ==  bar.questions[index]["correctOption"] , onChanged: (bool? b){
                                                    setState(() {
                                                      bar.questions[index]["correctOption"] = index2;
                                                    });
                                                    bar.notifyListeners();

                                                  }): Row(
                                                    children: [

                                                      Checkbox(value: index2 ==  bar.questions[index]["correctOption"], onChanged: (bool? b){
                                                        setState(() {
                                                          bar.questions[index]["correctOption"] = index2;
                                                        });
                                                        bar.notifyListeners();

                                                      }),

                                                      Text( bar.questions[index]["choice"][index2]),
                                                    ],
                                                  ),
                                                );

                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );

                                  }),
                            ),


                            InkWell( onTap: (){
                              //questions

                              List Options = [];
                              int correctOption = 0;
                              List<TextEditingController> allController = [];

                              TextEditingController c1 = TextEditingController();
                              TextEditingController c2 = TextEditingController();





                              showDialog(
                                  context: context,
                                  builder: (_) =>StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setStateC) {
                                        return Dialog(child: Container(width: 500,height: 900,
                                          child: SingleChildScrollView(
                                            child: Padding(
                                              padding: const EdgeInsets.all(20.0),
                                              child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(onTap: (){
                                                    Navigator.pop(context);
                                                  },child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.navigate_before_rounded,color: Colors.blue,),
                                                        Text("Back",style: TextStyle(color: Colors.blue),),
                                                      ],
                                                    ),
                                                  ),),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: TextField(controller: c1,decoration: InputDecoration(label: Text("Question title")),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: TextField(controller: c2,decoration: InputDecoration(label: Text("Question body")),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 8),
                                                    child: ClipRRect(borderRadius: BorderRadius.circular(5),child: Row(
                                                      children: [
                                                        Expanded(child: InkWell( onTap: (){
                                                          setState(() {
                                                            qt = (qt == questionType.singleChoice)?questionType.multipleChoice:questionType.singleChoice;
                                                          });
                                                          print(qt);
                                                        },
                                                          child: Container(color: qt == questionType.singleChoice?Colors.blue:Colors.white,
                                                            child: Center(child: Padding(
                                                              padding: const EdgeInsets.all(10.0),
                                                              child: Text("Single choice",style: TextStyle(color: qt == questionType.multipleChoice?Colors.blue:Colors.white ),),
                                                            ),),),
                                                        )),
                                                        Expanded(child: InkWell(onTap: (){
                                                          setState(() {
                                                            qt = (qt == questionType.singleChoice)?questionType.multipleChoice:questionType.singleChoice;
                                                          });
                                                          print(qt);
                                                        },
                                                          child: Container(color: qt == questionType.multipleChoice?Colors.blue:Colors.white,
                                                            child: Center(child: Padding(
                                                              padding: const EdgeInsets.all(10.0),
                                                              child: Text("Multiple choice",style: TextStyle(color: qt == questionType.singleChoice?Colors.blue:Colors.white ),),
                                                            ),),),
                                                        )),
                                                      ],
                                                    ),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text("Options:", ),
                                                  ),
                                                  ListView.builder(shrinkWrap: true,
                                                    itemCount: Options.length,

                                                    itemBuilder: (context, index) {
                                                      TextEditingController c = TextEditingController(text: Options[index]);
                                                      allController.add(c);
                                                      return ListTile(trailing: IconButton(onPressed: (){
                                                        allController.removeAt(index);
                                                        Options.removeAt(index);

                                                        setStateC(() {
                                                        });

                                                      },icon: Icon(Icons.delete),),leading: Checkbox(value: index==correctOption,onChanged: (bool? b){
                                                        if(b == true){

                                                          correctOption = index;
                                                          setStateC(() {
                                                          });
                                                        }

                                                      },),
                                                        title: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: TextFormField(onChanged: (String s){
                                                            Options[index] = s ;
                                                          },controller: c,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),label: Text("Option "+(index+1).toString())),),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  TextButton(onPressed: (){

                                                    setStateC(() {
                                                      Options.add("");
                                                    });



                                                  }, child: Text("Add Options")),
                                                  InkWell( onTap: (){



                                                    Provider.of<AddedProvider>(context, listen: false).add({"score":1,"correctOption":correctOption,"ans":Options[correctOption],"choice":Options,"title":c1.text,"q":c2.text,"quize_type":"SC"});
                                                    setState(() {
                                                    });
                                                    Navigator.pop(context);

                                                  },
                                                    child: Card(color: Colors.blue,child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Text("Save",style: TextStyle(color: Colors.white),),
                                                    ),),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ),);
                                      }
                                  ));
                            },
                              child: Card(color: Colors.blue,child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                                child: Text("Add Question",style: TextStyle(color: Colors.white),),
                              ),),
                            ),



                          ],),
                        )));
                  });

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
                          context:ccc??context,
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
                          context:ccc!,
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
                                          FirebaseFirestore.instance.collection("questionsN").add(json);
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
        Container(height: 0.5,width: double.infinity,color: Colors.grey,),
      ],
    )),),body: Container(margin: EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2)),
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
      child: Column(
        children: [
          Container(color: Colors.blue,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Checkbox(value: false, onChanged: (b){}),
                  Expanded(child: Text("Question",style: TextStyle(color: Colors.white),)),
                  Container(width: 100,child: Center(child: Text("Marks",style: TextStyle(color: Colors.white)))),
                ],
              ),
            ),
          ),
          Expanded(
            child: FirestoreQueryBuilder(pageSize: 20,
              query: FirebaseFirestore.instance.collection(widget.type ==questionbank.type1? "questions":"questionsN").where("quize_type",isEqualTo: "SC") ,
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
                    ccc = context;
                    //QuestionsSelectedProvider
                    return  true?HoverButtons(data: data,onCl: (String d){

                    },): Consumer<QuestionsSelectedProvider>(
                        builder: (_, bar, __) =>InkWell(onTap: (){
                          Map<String,dynamic> json = data.data() as Map<String,dynamic>;
                          json["created_at"] = DateTime.now().millisecondsSinceEpoch;


                          showBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                color: Colors.white,
                                height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
                                  child: Column(
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

                       TextButton(onPressed: (){

                         data.reference.update(json);

                         Navigator.pop(context);
                       }, child: Text("Update")),

                       if(false)   InkWell(onTap: (){
                          FirebaseFirestore.instance.collection("questions").add(json);
                          FirebaseFirestore.instance.collection("questionsN").add(json);
                          Navigator.pop(context);


                          },),



                                  ],
                              ),
                                ),
                              ));

                          // scaffoldKey.currentState!
                          //     .showBottomSheet((context) => Container(
                          //   color: Colors.red,
                          // ));
                        },
                          child: Row(
                            children: [
                              if(false)  Container(margin: EdgeInsets.all(5), decoration: BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.circular(2)),child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(data.get("quize_type"),style: TextStyle(color: Colors.white),),
                              )),

                                Checkbox(value: bar.selectedQuestions.contains(data.id),onChanged: (val){
                                if(val!){
                                  bar.add(data.id,data);
                                  //Provider.of<QuestionsSelectedProvider>(context, listen: false).

                                }else{
                                  bar.remove(data.id);
                                }

                              },),


                              Expanded(
                                child: HoverButtons(data: data,onCl: (String d){

                                },),
                              ),

                            ],
                          ),
                        ));

                  }, separatorBuilder: (BuildContext context, int index) { return Container(height: 0.5,width: double.infinity,color: Colors.grey,); },
                );
              },
            ),
          ),
        ],
      ),
    ),);
    return Scaffold(appBar: PreferredSize(preferredSize: Size(0,60),child: Row(
      children: [
    Consumer<QuestionsSelectedProvider>(
    builder: (_, bar, __) =>bar.selectedQuestions.length>0?Row(
      children: [
        InkWell( onTap: (){
          TextEditingController c = TextEditingController();
          showDialog(
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
        InkWell( onTap: (){
          showDialog(
              context: context,
              builder: (_) => Dialog(
                child: Container(height: MediaQuery.of(context).size.height * 0.8,width: MediaQuery.of(context).size.width * 0.8 ,child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Modify and save as new question"),
                      ),
                      ListView.builder(shrinkWrap: true,
                        itemCount: bar.selectedQuestions.length,

                        itemBuilder: (context, index) {
                          Map<String,dynamic> json = bar.selectedQuestionsBody[index].data() as Map<String,dynamic>;
                          json["created_at"] = DateTime.now().millisecondsSinceEpoch;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                //bar.selectedQuestionsBody[index].get("choice")

                                Row(
                                  children: [
                                    Text("TYPE :"),
                                    Text(json["quize_type"]=="SC"?"Single choice":"Multiple choice"),
                                  ],
                                ),


                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Question")),onChanged: (String d){
                                    json["q"] = d;
                                  },initialValue:json["q"] ,),
                                ),
                               // HtmlWidget(bar.selectedQuestionsBody[index].get("q")),

                                //Text(bar.selectedQuestionsBody[index].get("title")),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Title")),onChanged: (String d){
                                    json["title"] = d;
                                  },initialValue:json["title"] ,),
                                ),
                                //Text("Choices :"),
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
                               // Text("Correct Ans :"),
                                //Text(bar.selectedQuestionsBody[index].get("title")),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Correct ans")),onChanged: (String d){
                                    json["ans"] = d;
                                  },initialValue:json["ans"] ,),
                                ),
                                //
                                InkWell(onTap: (){
                                  FirebaseFirestore.instance.collection("questions").add(json);
                                  FirebaseFirestore.instance.collection("questionsN").add(json);
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
                          );
                        },
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
              child: Text("Copy and edit",style: TextStyle(color: Colors.blue),),
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
    ),),body: Row(
      children: [
        Expanded(
          child: FirestoreQueryBuilder(pageSize: 20,
            query: FirebaseFirestore.instance.collection("questions").where("quize_type",isEqualTo: "SC") ,
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

                        Checkbox(value: bar.selectedQuestions.contains(data.id),onChanged: (val){
                          if(val!){
                            bar.add(data.id,data);
                            //Provider.of<QuestionsSelectedProvider>(context, listen: false).

                          }else{
                            bar.remove(data.id);
                          }

                        },),
                        Text(data.get("title")),
                        HtmlWidget(data.get("q")),
                      ],
                    ));

                }, separatorBuilder: (BuildContext context, int index) { return Container(height: 0.5,width: double.infinity,); },
              );
            },
          ),
        ),
   if(false)     Expanded(
          child: FirestoreQueryBuilder(pageSize: 20,
            query: FirebaseFirestore.instance.collection("questions").where("quize_type",isEqualTo: "MC") ,
            builder: (context, snapshot, _) {
              if (snapshot.isFetching) {
                return Center(child: const Text("Please wait"));
              }
              if (snapshot.hasError) {
                return Text('error ${snapshot.error}');
              }

              return ListView.builder(shrinkWrap: true,
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
                          Container(margin: EdgeInsets.all(5), decoration: BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.circular(2)),child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(data.get("quize_type"),style: TextStyle(color: Colors.white),),
                          )),
                          Expanded(
                            child: CheckboxListTile(value: bar.selectedQuestions.contains(data.id),onChanged: (val){
                              if(val!){
                                bar.add(data.id,data);

                              }else{
                                bar.remove(data.id);
                              }

                            },title: Text(data.get("title")),subtitle:HtmlWidget(data.get("q")) ,),
                          ),
                        ],
                      ));

                },
              );
            },
          ),
        ),
      ],
    ),);
  }
}

class HoverButtons extends StatefulWidget {
  Function(String) onCl;
  QueryDocumentSnapshot data;
  HoverButtons({required this.onCl,required this.data});

  @override
  State<HoverButtons> createState() => _HoverButtonsState();
}

class _HoverButtonsState extends State<HoverButtons> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
   // return Text("OK");
    return  Consumer<QuestionsSelectedProvider>(
        builder: (_, bar, __) => InkWell(onTap: (){},child: Row(children: [
          Checkbox(value: bar.selectedQuestions.contains(widget.data.id),onChanged: (val){
            if(val!){
              bar.add(widget.data.id,widget.data);
              //Provider.of<QuestionsSelectedProvider>(context, listen: false).

            }else{
              bar.remove(widget.data.id);
            }

          },),
      Expanded(
        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
          Text(widget.data["title"]),
          HtmlWidget(widget.data["q"]),
        ],),
      ),



      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        AnimatedContainer( width: hovered ? 100.0 : 100.0,
          height: hovered ? 50 : 20.0,duration: Duration(milliseconds: 200),child: InkWell( onTap: (){
            Map<String,dynamic> json = widget.data.data() as Map<String,dynamic>;
            showBottomSheet(
                context: context,
                builder: (context) => Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
                  child: Column(
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

                      TextButton(onPressed: (){

                        widget.data.reference.update(json);

                        Navigator.pop(context);
                      }, child: Text("Update")),

                      if(false)   InkWell(onTap: (){
                        FirebaseFirestore.instance.collection("questions").add(json);
                        FirebaseFirestore.instance.collection("questionsN").add(json);
                        Navigator.pop(context);


                      },),



                    ],
                  ),
                ),
                ));

          },
            child: Container(
      width: 100,
      decoration: BoxDecoration(border: Border.all(color:hovered? Colors.blue:Colors.transparent,width: 0.5),borderRadius: BorderRadius.circular(2)),
      margin: EdgeInsets.all(5),
      child: Visibility(
        visible: hovered,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Edit",),
        ),
      ),
    ),
          ) ,),
    AnimatedContainer(width: hovered ? 100.0 : 100.0,
      height: hovered ? 50 : 20.0,duration: Duration(milliseconds: 200),child: InkWell( onTap: (){
        Map<String,dynamic> json = widget.data.data() as Map<String,dynamic>;
        showBottomSheet(
            context:context,
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
                            FirebaseFirestore.instance.collection("questionsN").add(json);
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
        child: Container(
        width: 100,
        decoration: BoxDecoration(border: Border.all(color:hovered? Colors.blue:Colors.transparent,width: 0.5),borderRadius: BorderRadius.circular(2)),
        margin: EdgeInsets.all(5),
        child: Visibility(
          visible: hovered,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Duplicate"),
          ),
        ),
    ),
      ),),

      ],),
          Container(width: 100,child: Center(child: Text(widget.data["score"]))),

    ],),onHover: (bool b){
      setState(() {
        hovered = b;
      });
    },));

  }
}

class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

