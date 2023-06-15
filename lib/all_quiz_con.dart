import 'package:admin/quizes_table.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'dart:convert';
import 'dart:html';
import 'package:admin/picker.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'AppProviders/DrawerProvider.dart';
import 'all_questions.dart';
import 'all_quiz_con.dart';
import 'edit_question_activity.dart';
import 'enums.dart';
import 'utils.dart';import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:pdf/widgets.dart' as pw;
class Quizes_tabs_context extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  Quizes_tabs_context({required this.scaffoldKey});

  @override
  State<Quizes_tabs_context> createState() => _Quizes_tabs_contextState();
}

class _Quizes_tabs_contextState extends State<Quizes_tabs_context> {
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
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size(0,60),child: Container(height: 60,child: Column(
      children: [
        Container(color: Colors.white,height: 59,child: Row(
          children: [
            InkWell( onTap: (){
              final format = DateFormat("yyyy-MM-dd HH:mm");
               widget. scaffoldKey.currentState!.showBottomSheet((context) => Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
                  child: Column(children: [

                    Card(margin: EdgeInsets.zero,shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                  ) ,
                      child: Padding(
                        padding:  EdgeInsets.only(bottom: 10,top: 15),
                        child: InkWell( onTap: (){

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
                      ),
                    ),

                    Container(height: 25,),


                    Row(
                      children: [
                        Expanded(flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(controller: controller1,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Title")),),
                          ),
                        ),
                        Expanded(flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(controller: controller2,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Number of quiz takes")),),
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

                                    return DropdownSearch<String>(onChanged: (String? s){
                                      controller3.text =allId[all.indexOf(s!)];
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
                              });

                            },controller: controller4,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Eaxm Duration Time(H:M:S)")),),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(controller: controller5,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Total Exam Marks")),),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(controller: controller6,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Pass Mark")),),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:  EdgeInsets.all(8.0),
                            child: true? Wrap(
                              children: [
                                Text("Exam start time"),
                                DateTimeField(controller:controller7 ,
                                  format: format,
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
                                        return DateTimeField.combine(date, time);
                                      } else {
                                        return currentValue;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ): TextField(onTap: () async {


                              // dt. DatePicker.showDateTimePicker(context,
                              //     showTitleActions: true,
                              //     minTime: DateTime(2020, 5, 5, 20, 50),
                              //     maxTime: DateTime(2020, 6, 7, 05, 09), onChanged: (date) {
                              //       print('change $date in time zone ' +
                              //           date.timeZoneOffset.inHours.toString());
                              //     }, onConfirm: (date) {
                              //       print('confirm $date');
                              //     }, locale: dt.LocaleType.en);
                              // DatePicker.showDatePicker(
                              //   context,
                              //   dateFormat: 'dd MMMM yyyy HH:mm',
                              //   initialDateTime: DateTime.now(),
                              //   minDateTime: DateTime(2000),
                              //   maxDateTime: DateTime(3000),
                              //   onMonthChangeStartWithFirstDate: true,
                              //   onConfirm: (dateTime, List<int> index) {
                              //     DateTime selectdate = dateTime;
                              //     final selIOS = DateFormat('dd-MMM-yyyy - HH:mm').format(selectdate);
                              //     print(selIOS);
                              //   },
                              // );
                              // DateTime? pickedDate = await showDatePicker(
                              //     context: context,
                              //     initialDate: DateTime.now(),
                              //     firstDate: DateTime(1950),
                              //     //DateTime.now() - not to allow to choose before today.
                              //     lastDate: DateTime(2100));
                              //
                              // if (pickedDate != null) {
                              //   print(
                              //       pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              //   String formattedDate =
                              //   DateFormat('yyyy-MM-dd HH:mm').format(pickedDate);
                              //   print(
                              //       formattedDate); //formatted date output using intl package =>  2021-03-16
                              //   setState(() {
                              //     controller7.text = formattedDate; //set output date to TextField value.
                              //   });
                              // } else {}



                            },controller: controller7,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Exam Start Date")),),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:  Wrap(
                              children: [
                                Text("Exam start time"),
                                DateTimeField(controller:controller8 ,
                                  format: format,
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
                                        return DateTimeField.combine(date, time);
                                      } else {
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
                                DropdownSearch<String>(
                                  items: ["Yes","No"],onChanged: (String? s){
                                  controller9.text = s!;
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
                      child: TextField(controller: controller10,minLines: 7,maxLines: 10,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),label: Text("Quiz Content")),),
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


                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                                Provider.of<AddedProviderOnlyNew>(context, listen: false).add({"score":1,"correctOption":correctOption,"ans":Options[correctOption],"choice":Options,"title":c1.text,"q":c2.text,"quize_type":"SC"});
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
                            child: Text("Create Question",style: TextStyle(color: Colors.white),),
                          ),),
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
                              builder: (_) => true?Dialog(
                                child:Scaffold(appBar: PreferredSize(preferredSize: Size(0,50),child: Row(
                                  children: [
                                    TextButton(onPressed: (){
                                      Navigator.pop(context);

                                    }, child: Text("Done")),
                                  ],
                                ) ,),body:  FirestoreQueryBuilder(pageSize: 20,
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
                                        //  ccc = context;
                                        //QuestionsSelectedProvider
                                        return  true?Consumer<QuestionsSelectedProvider>(
                                            builder: (_, bar, __) => InkWell(onTap: (){},child: Row(children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                child: Checkbox(value: bar.selectedQuestions.contains(data.id),onChanged: (val){
                                                  if(val!){
                                                    bar.add(data.id,data);
                                                    //Provider.of<QuestionsSelectedProvider>(context, listen: false).

                                                  }else{
                                                    bar.remove(data.id);
                                                  }

                                                },),
                                              ),
                                              data["title"]==""? HtmlWidget(data["q"]):  Row(
                                               children: [
                                                 Text(data["title"]),
                                                 HtmlWidget(data["q"]),
                                                 Wrap(
                                                   children:data["choice"].map<Widget>((e) => Padding(
                                                     padding: const EdgeInsets.all(8.0),
                                                     child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),border: Border.all()),width: 150,child: Center(child: Text(e,overflow: TextOverflow.fade,))),
                                                   )).toList(),
                                                 ),
                                               ],
                                              ),




                                            ],))): Consumer<QuestionsSelectedProvider>(
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
                                                          FirebaseFirestore.instance.collection("questions").add(json);
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
                                ),),
                              ): StatefulBuilder(
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
                              )).whenComplete(() {

                            for(int  i = 0; i < Provider.of<QuestionsSelectedProvider>(context, listen: false).selectedQuestionsBody.length ; i++){
                              Provider.of<AddedProvider>(context, listen: false).add(Provider.of<QuestionsSelectedProvider>(context, listen: false).selectedQuestionsBody[i]);

                            }



                            Provider.of<QuestionsSelectedProvider>(context, listen: false).totalMarks = 0;
                            Provider.of<QuestionsSelectedProvider>(context, listen: false).selectedQuestionsBody =[];
                            Provider.of<QuestionsSelectedProvider>(context, listen: false).selectedQuestions = [];

                          });
                        },
                          child: Card(color: Colors.blue,child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                            child: Text("Select Question",style: TextStyle(color: Colors.white),),
                          ),),
                        ),
                      ],
                    ),


                    Center(
                      child: InkWell( onTap: (){

                        try{
                          List q = [];
                          print("total AddedProvider ");
                          print(Provider.of<AddedProvider>(context, listen: false).questions.length);

                          for(int i = 0 ; i < Provider.of<AddedProvider>(context, listen: false).questions.length ; i++){
                            //print(Provider.of<AddedProvider>(context, listen: false).questions[i].data() );
                            try{
                              q.add(Provider.of<AddedProvider>(context, listen: false).questions[i].data() );
                              // q.add({"1":1} );
                            }catch(e){
                              dynamic d = Provider.of<AddedProvider>(context, listen: false).questions[i];
                              d["created_at"] = DateTime.now().millisecondsSinceEpoch;
                              FirebaseFirestore.instance.collection("questions").add(d);

                              q.add(Provider.of<AddedProvider>(context, listen: false).questions[i] );
                              //  q.add(Provider.of<AddedProvider>(context, listen: false).questions[i] );
                            }

                          }
                          Provider.of<AddedProvider>(context, listen: false).questions = [];

                          FirebaseFirestore.instance.collection("quizz2").add({"created_at":DateTime.now().millisecondsSinceEpoch,
                            "course_id":controller3.text,
                            "exam_end":controller8.text,
                            "exam_start":controller7.text,
                            "exam_time":controller4.text,
                            "id":"",
                            "num_retakes":controller2.text,
                            "pass_mark":controller6.text,

                            "quiz":q,
                            "retakes":"",
                            "section_details":controller10.text,
                            "status":controller9.text,
                            "title":controller1.text,
                            "total_point":controller5.text,


                          });



                          // Provider.of<AddedProvider>(context, listen: false).add({"score":1,"correctOption":correctOption,"ans":Options[correctOption],"choice":Options,"title":c1.text,"q":c2.text,"quize_type":"SC"});
                          // setState(() {
                          // });
                          Navigator.pop(context);
                        }catch(e){
                          showDialog(
                              context: context,
                              builder: (_) =>AlertDialog(title: Text("Quiz save error"),content: Text(e.toString()),));

                        }


                      },
                        child: Card(color: Colors.blue,child: Container(width: MediaQuery.of(context).size.width * 0.5,
                          child: Center(
                            child: Padding(
                              padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                              child: Text("Save & Close",style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),),
                      ),
                    ),



                  ],))));




            },
              child: Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.blue)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Create new quiz",style: TextStyle(color: Colors.blue),),
                ),
              ),
            ),

            Consumer<QuestionsSelectedProvider>(
                builder: (_, bar, __) =>bar.selectedQuestions.length>0?Row(
                  children: [
                    InkWell( onTap: (){
                      TextEditingController c = TextEditingController();

                      showBottomSheet(
                          context:context,
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
    )),),body:  true?QuizesTable(scaffoldKey:widget.scaffoldKey): FirestoreQueryBuilder(
      query: FirebaseFirestore.instance.collection("quizz2"),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const CircularProgressIndicator();
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

            final movie = snapshot.docs[index];
            return ListTile(onTap: (){
              widget. scaffoldKey.currentState!.showBottomSheet((context) => Container(height: MediaQuery.of(context).size.height,child: false?Edit_quiz_activity(ref:movie): SingleChildScrollView(
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
                    Edit_quiz_activity(ref:movie),

                  ],
                ),
              ),));


            },trailing: IconButton(onPressed: (){movie.reference.delete();},icon: Icon(Icons.delete),),title:Text(movie.get("title")) ,subtitle: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(movie.get("quiz").length.toString()+" questions"),
                ),
                Text(movie.get("total_point").toString()+" marks")
              ],
            ),);
            return Text(movie.get("title") );
          },
        );
      },
    ),);
  }
}
