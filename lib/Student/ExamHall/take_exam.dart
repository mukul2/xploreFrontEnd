import 'dart:convert';

import 'package:admin/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../RestApi.dart';

class TakeExam extends StatefulWidget {
  String id;
  TakeExam({required this.id});
  @override
  State<TakeExam> createState() => _TakeExamState();
}

class _TakeExamState extends State<TakeExam> {
  List questionAnswers = [];
  Map<int,dynamic> questionAnswersMap = {};

  double marks = 0.0;
  int rightAns = 0;
  int wrongAns = 0;
  int unanswered = 0;
  @override
  Widget build(BuildContext context) {
    //quize

    return WillPopScope(onWillPop: ()async{
     return Future.value(false);
    },
      child: Scaffold(backgroundColor: Colors.grey.shade100,bottomNavigationBar: InkWell(onTap: (){
        showDialog(
            context: context,
            builder: (_) =>Dialog(backgroundColor: Colors.transparent,child: ClipRRect(borderRadius: BorderRadius.circular(10),
              child: Container(color: Colors.white,width: 500,height: 220,
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 500,height: 150,color: Colors.grey.shade500,child: Center(child: Text("Are you sure to finish and submit?",textAlign: TextAlign.center,style: TextStyle(fontSize: 25),)),),
                    Row(
                      children: [
                        Expanded(child: InkWell( onTap: (){
                           marks = 0.0;
                           rightAns = 0;
                           wrongAns = 0;
                          for(int i = 0 ; i < questionAnswers.length ; i++){
                           try{
                             if(questionAnswersMap[questionAnswers[i]["id"]] ==questionAnswers[i]["correct_ans"] ){
                               rightAns++;
                               marks = marks + questionAnswers[i]["score"];
                             }else{
                               wrongAns++;
                             }
                           }catch(e){
                             unanswered++;
                           }
                          }
                          Map<String,dynamic> submitExmBody = {"unanswer":unanswered,
                            "rightanswer":rightAns,
                            "wrong":wrongAns,
                            "totalQues":questionAnswers.length,
                            "marks":marks,
                            "ansMap":questionAnswersMap.toString(),
                            "quiz_id":widget.id,
                            "student_id":FirebaseAuth.instance.currentUser!.uid};
                          Data().quizsubmit(data: submitExmBody).then((value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (_) =>AlertDialog(content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Submission compleated successfully"),
                                )));
                          });


                        },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(width: double.infinity,decoration: boxShadow,child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: Text("Yes")),
                              )),
                            ),
                          ),
                        )),
                        Expanded(child: InkWell( onTap: (){
                          Navigator.pop(context);

                        },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(width: double.infinity,decoration: boxShadow2,child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: Text("No")),
                              )),
                            ),
                          ),
                        )),
                      ],
                    ),

                  ],
                ),
              ),
            ),));
      },child: Container(height: 45,width: MediaQuery.of(context).size.width,color: Colors.blue,child: Center(child: Text("Finish & Submit",style: TextStyle(color: Colors.white),),),)),body: FutureBuilder<dynamic>(
          future: Data().quize(id:widget.id), // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.hasData){
              return Column(
                children: [
                  Container(height: 95,width: MediaQuery.of(context).size.width,color: Color.fromARGB(255, 93, 109, 126),child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Wrap(
                      //   children: [
                      //     Text(snapshot.data!.toString(),style: TextStyle(color: Colors.white),),
                      //   ],
                      // ),
                      Text(snapshot.data!["title"].toString(),style: TextStyle(color: Colors.white,fontSize: 25),),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(snapshot.data!["exam_time_minute"].toString()+" minutes",style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Total Marks "+snapshot.data!["total_point"].toString(),style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Pass Marks "+snapshot.data!["pass_mark"].toString(),style: TextStyle(color: Colors.white),),
                          ),

                        ],
                      ),

                      //questionsbyid

                    ],
                  ),),

                  Expanded(
                    child: Center(
                      child: Container(width:MediaQuery.of(context).size.width>600?600:MediaQuery.of(context).size.width ,
                        child: FutureBuilder<dynamic>(
                        future: Data().quizAuestions(id:widget.id), // a previously-obtained Future<String> or null
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if(snapshot.hasData){
                          for(int i  = 0 ; i < snapshot.data!.length ; i++){
                            questionAnswers.add({"id":snapshot.data![i]["id"],"selected_answer":"","correct_ans":snapshot.data![i]["ans"],"score":snapshot.data![i]["score"]});
                           // questionAnswersMap.putIfAbsent(snapshot.data![i]["id"], () => "") ;
                            questionAnswersMap[snapshot.data![i]["id"]] = "";
                          }
                         return ListView.builder(shrinkWrap: true,
                            itemCount: snapshot.data!.length,

                            itemBuilder: (context, index) {

                              return Container(margin: EdgeInsets.all(15),decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.grey)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Question # "+(1+index).toString(),style: TextStyle(color: Colors.grey),),
                                          Text("Score : "+snapshot.data![index]["score"].toString(),style: TextStyle(color: Colors.grey),),

                                        ],
                                      ),
                                     if(snapshot.data![index]["title"].toString().length>0)  SelectableText( snapshot.data![index]["title"],style: TextStyle(color: Colors.grey),),
                                      if(snapshot.data![index]["q"].toString().length>0)   SelectableText( snapshot.data![index]["q"]),
                                      if(snapshot.data![index]["explanation"].toString().length>0)   SelectableText( snapshot.data![index]["explanation"],style: TextStyle(color: Colors.grey),),
                                        Padding(
                                          padding:  EdgeInsets.symmetric(horizontal: 20),
                                          child: true?SingleQuestion(options:  snapshot.data![index]["options"] ,onSelected: (Map<String,dynamic> data){
                                            questionAnswersMap[snapshot.data![index]["id"]] =  data["body"];
                                          },): ListView.builder(shrinkWrap: true,
                                          itemCount: snapshot.data![index]["options"].length,

                                          itemBuilder: (context, index2) {
                                          return  InkWell(onTap: (){
                                            questionAnswersMap[snapshot.data![index]["id"]] =  snapshot.data![index]["options"][index2]["body"];
                                            for(int i = 0 ; i< questionAnswers.length ; i++){

                                              if(questionAnswers[i]["id"]==snapshot.data![index]["id"] ){
                                                questionAnswers[i]["selected_answer"] = snapshot.data![index]["options"][index2]["body"];
                                                break;
                                              }
                                              setState(() {

                                              });

                                            }

                                          },
                                            child: Container(margin: EdgeInsets.all(5), decoration: boxShadow,child:Padding(
                                              padding:  EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Container(height: 10,width: 10,margin: EdgeInsets.symmetric(horizontal: 10),decoration: BoxDecoration(shape: BoxShape.circle,color:questionAnswersMap[snapshot.data![index]["id"]] ==snapshot.data![index]["options"][index2]["body"]?Colors.blue: Colors.grey),),
                                                  SelectableText(snapshot.data![index]["options"][index2]["body"]),
                                                ],
                                              ),
                                            ) ,),
                                          );

                                          }),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          return Text(snapshot.data!.toString());
                        }else{
                          return Center(child: CircularProgressIndicator(),);
                        }}),
                      ),
                    ),
                  ),
                ],
              );
              return Text(snapshot.data!.toString());


            }else{
              return Center(child: CircularProgressIndicator(),);
            }})),
    );
  }
}


class SingleQuestion extends StatefulWidget {
  List options;

  Function(Map<String,dynamic>)onSelected;
  SingleQuestion({required this.options,required this.onSelected,});

  @override
  State<SingleQuestion> createState() => _SingleQuestionState();
}

class _SingleQuestionState extends State<SingleQuestion> {

  int selectedPos= -1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(shrinkWrap: true,
          itemCount: widget.options.length,

          itemBuilder: (context, index2) {
            return  InkWell(onTap: (){
              widget.onSelected({"body": widget.options[index2]["body"]});
              selectedPos = index2;
              setState(() {

              });
              // questionAnswersMap[snapshot.data![index]["id"]] =  widget.options[index2]["body"];
              // for(int i = 0 ; i< questionAnswers.length ; i++){
              //
              //   if(questionAnswers[i]["id"]==snapshot.data![index]["id"] ){
              //     questionAnswers[i]["selected_answer"] = widget.options[index2]["body"];
              //     break;
              //   }
              //   setState(() {
              //
              //   });
              //
              // }

            },
              child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(border: Border.all(color:  selectedPos ==index2?Colors.white: Colors.black ),borderRadius: BorderRadius.circular(4), color: selectedPos ==index2?Colors.blue: Colors.white),child:Padding(
                padding:  EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(height: 10,width: 10,margin: EdgeInsets.symmetric(horizontal: 10),decoration: BoxDecoration(shape: BoxShape.circle,color:selectedPos ==index2?Colors.white: Colors.grey),),
                    SelectableText(widget.options[index2]["body"],style: TextStyle(color: selectedPos ==index2?Colors.white: Colors.black ),),
                  ],
                ),
              ) ,),
            );

          }),
    );
  }
}
