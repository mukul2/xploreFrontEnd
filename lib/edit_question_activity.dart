import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'RestApi.dart';
import 'enums.dart';

class Edit_quiz_activity extends StatefulWidget {
  QueryDocumentSnapshot ref;
  Edit_quiz_activity({required this.ref});

  @override
  State<Edit_quiz_activity> createState() => _Edit_quiz_activityState();
}

class _Edit_quiz_activityState extends State<Edit_quiz_activity> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller1.text = widget.ref.get("title");
    controller2.text = widget.ref.get("num_retakes");
    controller3.text = widget.ref.get("course_id");
    controller4.text = widget.ref.get("exam_time");
    controller5.text = widget.ref.get("total_point");
    controller6.text = widget.ref.get("pass_mark");
    controller7.text =  DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(widget.ref.get("exam_start"))) ;
    //controller7.text = "";

    controller8.text = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(widget.ref.get("exam_end"))) ;;
    controller9.text = widget.ref.get("status");
    controller10.text = widget.ref.get("section_details");
    setState(() {

    });
  }
  questionType qt = questionType.singleChoice;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();
  TextEditingController controller7 = TextEditingController();
  TextEditingController controller8 = TextEditingController();
  TextEditingController controller9 = TextEditingController();
  TextEditingController controller10 = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return  StreamBuilder<DocumentSnapshot>(
        stream: widget.ref.reference.snapshots(), // a previously-obtained Future<String> or null
       builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if(snapshot.hasData){
            List allQuestions  =  snapshot.data!.get("quiz");
            return ListView(shrinkWrap: true,
              children: [
                Row(
                  children: [
                    Expanded(flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(onChanged: (String s){
                          widget.ref.reference.update({"title":s});
                        },controller: controller1,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Title")),),
                      ),
                    ),
                    Expanded(flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(onChanged: (String s){
                          widget.ref.reference.update({"num_retakes":s});
                        },controller: controller2,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Number of quiz takes")),),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:true?FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance.collection("courses").orderBy("course_title").get(), // a previously-obtained Future<String> or null
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if(snapshot.hasData){
                                List<String>all = [];
                                List<String>allId = [];
                                for(int  i = 0; i < snapshot.data!.docs.length ; i++){
                                  all.add(snapshot.data!.docs[i].get("course_title"));
                                  allId.add(snapshot.data!.docs[i].id);
                                }

                                return DropdownSearch<String>(selectedItem:all[allId.indexOf(widget.ref.get("course_id"))] , onChanged: (String? s){
                                  controller3.text =allId[all.indexOf(s!)];
                                  widget.ref.reference.update({"course_id":allId[all.indexOf(s!)]});
                                },
                                  items: all,
                                );
                              }else{
                                return CupertinoActivityIndicator();
                              }
                            }): TextField(controller: controller3,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Course")),),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(textAlign: TextAlign.end,onTap: () async {
                          var duration = await showDurationPicker(
                            context: context,
                            initialTime: Duration(minutes: 30),
                          );
                          setState(() {
                            String twoDigits(int n) => n.toString().padLeft(2, "0");
                            String twoDigitMinutes = twoDigits(duration!.inMinutes.remainder(60));
                            String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

                            controller4.text = "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";

                              widget.ref.reference.update({"exam_time":controller4.text});

                          });

                        },controller: controller4,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Eaxm Duration Time(H:M:S)")),),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(onChanged: (String s){
                          widget.ref.reference.update({"total_point":s});
                        },controller: controller5,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Total Exam Marks")),),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(onChanged: (String s){
                          widget.ref.reference.update({"pass_mark":s});
                        },controller: controller6,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Pass Mark")),),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:  EdgeInsets.all(8.0),
                        child:  Wrap(
                          children: [
                            Text("Exam start time"),
                            DateTimeField(
                              controller:controller7 ,
                              format: DateFormat("yyyy-MM-dd HH:mm:ss"),
                              onShowPicker: (context, currentValue) async {
                                return await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100),
                                ).then((DateTime? date) async {
                                  if (date != null) {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                    );

                                      widget.ref.reference.update({"exam_start": DateTimeField.combine(date, time).millisecondsSinceEpoch });

                                    return DateTimeField.combine(date, time);
                                  } else {
                                    widget.ref.reference.update({"exam_start": currentValue!.millisecondsSinceEpoch });

                                    return currentValue;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:  Wrap(
                          children: [
                            Text("Exam end time"),
                            DateTimeField(controller:controller8 ,
                              format:  DateFormat("yyyy-MM-dd HH:mm:ss"),
                              onShowPicker: (context, currentValue) async {
                                return await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100),
                                ).then((DateTime? date) async {
                                  if (date != null) {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                    );
                                    widget.ref.reference.update({"exam_end": DateTimeField.combine(date, time).millisecondsSinceEpoch });

                                    return DateTimeField.combine(date, time);
                                  } else {
                                    widget.ref.reference.update({"exam_end":  currentValue!.millisecondsSinceEpoch });

                                    return currentValue;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: true?Wrap(
                          children: [
                            Text("Published"),
                            DropdownSearch<String>(selectedItem:widget.ref.get("status") ,
                              items: ["Yes","No"],onChanged: (String? s){
                              controller9.text = s!;
                              widget.ref.reference.update({"status": s});
                            },
                            ),
                          ],
                        ): TextField(controller: controller9,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Published")),),
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
                  child: TextField(onChanged: (String s){
                    widget.ref.reference.update({"section_details":s });
                  },controller: controller10,minLines: 7,maxLines: 10,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),label: Text("Quiz Content")),),
                ),

                ListView.builder(shrinkWrap: true,
                    itemCount:allQuestions.length,

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
                              Text( allQuestions[index]["title"]),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text("Question",style: TextStyle(color: Colors.grey),),
                              ),

                              Text( allQuestions[index]["q"]),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text("Options",style: TextStyle(color: Colors.grey),),
                              ),



                              ListView.builder(shrinkWrap: true,
                                itemCount:   allQuestions[index]["choice"].length,

                                itemBuilder: (context, index2) {
                                  return  Container(margin:EdgeInsets.symmetric(vertical: 5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: Colors.grey.shade100),width: 300,
                                    child: CheckboxListTile(title: Text( allQuestions[index]["choice"][index2]),value: index2 ==   allQuestions[index]["correctOption"] , onChanged: (bool? b){
                                      setState(() {
                                        allQuestions[index]["correctOption"] = index2;
                                      });

                                      widget.ref.reference.update({"quiz":allQuestions});
                                     // widget.ref.reference.update ("quiz."+index.toString()).


                                    }),
                                  );

                                },
                              ),
                            ],
                          ),
                        ),
                      );

                    })

              ],
            );
    }else{
          return Center(child: CircularProgressIndicator(),);
    }});

  }
}



class Edit_quiz_activitySQL extends StatefulWidget {
  Map ref;
  Edit_quiz_activitySQL({required this.ref});

  @override
  State<Edit_quiz_activitySQL> createState() => _Edit_quiz_activitySQLState();
}

class _Edit_quiz_activitySQLState extends State<Edit_quiz_activitySQL> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller1.text = widget.ref["title"];
    // controller2.text = widget.ref["num_retakes"];
    // controller3.text = widget.ref["course_id"];
    // controller4.text = widget.ref["exam_time"];
    // controller5.text = widget.ref["total_point"];
    // controller6.text = widget.ref["pass_mark"];
    // controller7.text =  DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(widget.ref["exam_start"])) ;
    // //controller7.text = "";
    //
    // controller8.text = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(widget.ref["exam_end"])) ;;
    // controller9.text = widget.ref["status"];
    // controller10.text = widget.ref["section_details"];
    // setState(() {
    //
    // });
  }
  questionType qt = questionType.singleChoice;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();
  TextEditingController controller7 = TextEditingController();
  TextEditingController controller8 = TextEditingController();
  TextEditingController controller9 = TextEditingController();
  TextEditingController controller10 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //quizAuestions

    return  FutureBuilder(

        future:Data().quizAuestions(id: widget.ref["quizid"].toString()),
        builder: (context, AsyncSnapshot<List> snap) {
          if(snap.hasData && snap.data!.length>0){
         return   Wrap(children:  snap.data!.map((e) => Container(width: 300,margin: EdgeInsets.all(5), decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(  e["title"],style: TextStyle(color: Colors.grey),),
                        Text(  "Score : "+e["score"].toString(),style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                    Text( e["q"],style: TextStyle(color: Colors.blue),),
                    Text( e["explanation"],style: TextStyle(color: Colors.grey),),
                    Text("Options"),
                    ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                        itemCount:e["options"].length,
                        itemBuilder: (BuildContext context, int index2) {
                          return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text((index2+1).toString()),
                              Text(  e["options"][index2]["body"]),
                            ],
                          );
                        }),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text( "Right ans",style: TextStyle(color: Colors.grey),),
                      Text(  e["ans"],style: TextStyle(color: Colors.grey),),
                    ],
                  ),

                  ],
                ),
              ),
            )).toList(),);
          return  ListView.builder(shrinkWrap: true,
                itemCount:  snap.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(width: 300,margin: EdgeInsets.all(5), decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(4)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(  snap.data![index]["title"]),
                        Text(  snap.data![index]["q"]),
                        Text(  snap.data![index]["explanation"]),
                        ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                            itemCount: snap.data![index]["options"].length,
                            itemBuilder: (BuildContext context, int index2) {
                              return Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(  snap.data![index]["options"][index2]["body"]),
                                ],
                              );
                            }),
                        Text(  snap.data![index]["ans"]),
                      ],
                    ),
                  );
                });



          }else{
            return Text("--");
            return Center(child: CupertinoActivityIndicator(),);
          }

        });
    return  Text(widget.ref.toString());

  }
}
