import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../AppProviders/DrawerProvider.dart';
import '../RestApi.dart';
import '../students_activity.dart';
import '../styles.dart';

class CreateQuize extends StatefulWidget {
  const CreateQuize({super.key});

  @override
  State<CreateQuize> createState() => _CreateQuizeState();
}

class _CreateQuizeState extends State<CreateQuize> {
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
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
  TextEditingController controller11 = TextEditingController();
  int exm_start = 0;
  int exm_end = 0;

  int? selectedClass = null;
  int? selectedsubject = null;
  int? selectedChapter = null;
  List selectedOldQuestions = [];
  @override
  Widget build(BuildContext context) {

    return Scaffold(appBar: false?null: PreferredSize(preferredSize: Size(0,60),child:Card(elevation: 1,margin: EdgeInsets.zero,
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 8,horizontal: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            ElevatedButton(onPressed: (){
              print("Save quiz clicked");
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
                    //   FirebaseFirestore.instance.collection("questions").add(d);

                    q.add(Provider.of<AddedProvider>(context, listen: false).questions[i] );
                    //  q.add(Provider.of<AddedProvider>(context, listen: false).questions[i] );
                  }

                }
                Provider.of<AddedProvider>(context, listen: false).questions = [];
                String xtm = controller4.text;
                int min = 0 ;
                List<String> allTimes = xtm.split(":");
                for(int k = 0 ; k < allTimes.length ; k++){
                  min = min+int.parse(allTimes[k]);
                }
                Map dataToSave = {
                  "class_id":selectedClass??0,
                  "subject_id":selectedsubject??0,
                  "chapter_id":selectedChapter??0,
                  "created_by":FirebaseAuth.instance.currentUser!.uid,
                  "course_id":controller3.text==""?0:controller3.text,
                  "exam_end":exm_end/1000,
                  "exam_start":exm_start/1000,
                  "exam_time_minute":min,

                  "num_retakes":int.parse(controller2.text),
                  "pass_mark":controller6.text,

                  "questions":q,
                  "retakes":int.parse(controller2.text),
                  "section_details":controller10.text,
                  "status":controller9.text,
                  "title":controller1.text,
                  "total_point":controller5.text,
                  "price":controller11.text,"question_id":selectedOldQuestions,



                };



                Data().saveQuiz(data: dataToSave).then((value) async {
               await   showDialog(
                      context: context,
                      builder: (_) =>AlertDialog(title: Text("Quize save response"),content: Text(value.toString()),));
                  Provider.of<AddedProviderOnlyNew>(context, listen: false).questions = [];
                  Provider.of<AddedProvider>(context, listen: false).questions = [];
                  Data().quizesHandelerid(id: FirebaseAuth.instance.currentUser!.uid).then((value) {
                    Provider.of<Quizessprovider>(context, listen: false).items = value;
                    //Navigator.pop(context);
                  });


                });




                // FirebaseFirestore.instance.collection("quizz2").add({"created_at":DateTime.now().millisecondsSinceEpoch,
                //   "course_id":controller3.text,
                //   "exam_end":exm_end,
                //   "exam_start":exm_start,
                //   "exam_time":controller4.text,
                //   "id":"",
                //   "num_retakes":controller2.text,
                //   "pass_mark":controller6.text,
                //
                //   "quiz":q,
                //   "retakes":"",
                //   "section_details":controller10.text,
                //   "status":controller9.text,
                //   "title":controller1.text,
                //   "total_point":controller5.text,
                //
                //
                // });



                // Provider.of<AddedProvider>(context, listen: false).add({"score":1,"correctOption":correctOption,"ans":Options[correctOption],"choice":Options,"title":c1.text,"q":c2.text,"quize_type":"SC"});
                // setState(() {
                // });
                //   Navigator.pop(context);
              }catch(e){
                showDialog(
                    context: context,
                    builder: (_) =>AlertDialog(title: Text("Quiz save error"),content: Text(e.toString()),));

              }
            }, child: Text("Save")),
          ],
        ),
      ),
    ) ,),body: Container(width: MediaQuery.of(context).size.width,
        color: Colors.grey.shade50,
        height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 15,horizontal:  MediaQuery.of(context).size.width * 0.07),
            child: Column(children: [



              Container(height: 25,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ClassSelectDropdown(onSelected: (String id){
                          print("class selested "+id);

                          if(id=="0"){
                            selectedClass = null;
                          }else{
                            selectedClass = int.parse(id);
                          }
                          //Provider.of<QuestionSortsprovider>(context, listen: false).class_id =  int.parse(id);
                          // selectedClassId = id;
                        },),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SubjectSelectDropdown(onSelected: (String id){
                          print("sub selested "+id);
                          if(id=="0"){
                            selectedsubject = null;
                          }else{
                            selectedsubject = int.parse(id);
                          }
                          //     Provider.of<QuestionSortsprovider>(context, listen: false).subject_id =  int.parse(id);

                          // selectedClassId = id;
                        },),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ChapterSelectDropdown(onSelected: (String id){
                          print("class selested "+id);
                          if(id=="0"){
                            selectedChapter = null;
                          }else{
                            selectedChapter = int.parse(id);
                          }
                          // selectedClassId = id;
                        },),
                      ),
                    ),
                  ],
                ),
              ),

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
                      child:Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: BatchSelectDropdown(onSelected: (String id){
                          print("Seleected id"+id);
                          controller3.text =id ;
                          // batch = id;
                        },),
                      ),
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
                  Consumer<AddedProvider>(
                      builder: (_, bar, __){
                        double total = 0;
                        if(bar.questions.length==0)total = 0;
                        if(bar.questions.length>0){
                          for(int i = 0 ; i <bar.questions.length ; i++){
                            total = total+bar.questions[i]["score"];
                          }
                        }
                        controller5.text = total.toString();
                       return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(controller: controller5,enabled: false,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Total Exam Marks")),),
                          ),
                        );
                      }),

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
                        child:  Wrap(
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
                                    exm_start = DateTimeField.combine(date, time).millisecondsSinceEpoch;
                                    return DateTimeField.combine(date, time);
                                  } else {
                                    exm_start =currentValue! .millisecondsSinceEpoch;
                                    return currentValue;
                                  }
                                });
                              },
                            ),
                          ],
                        )
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  Wrap(
                        children: [
                          Text("Exam end time"),
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
                                  exm_end = DateTimeField.combine(date, time).millisecondsSinceEpoch;
                                  return DateTimeField.combine(date, time);
                                } else {
                                  exm_end =currentValue! .millisecondsSinceEpoch;
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
                    child:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        children: [
                          Text("Price"),
                          TextField(controller: controller11,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            //000000000000000000000000000000000000000  label: Text("Price")
                          ),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(controller: controller10,minLines: 7,maxLines: 10,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),label: Text("Quiz Content")),),
              ),


              Container(margin: EdgeInsets.all(10), decoration: boxShadow,child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                  Text("Questions"),
                    Row(
                      children: [
                        ElevatedButton(onPressed: (){
                          //select q
                          showDialog(
                              context: context,
                              builder: (_) =>StatefulBuilder(
                                  builder: (context,setS) {
                                    return AlertDialog(actions: [
                                      Center(
                                        child: ElevatedButton(onPressed: (){
                                          Navigator.pop(context);
                                        }, child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                                          child: Container(width: 700,child: Center(child: Text("Close"))),
                                        )),
                                      ),
                                    ],content:Container(height: 300,width: 800,
                                      child: true?Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: FutureBuilder<List>(
                                            future: Data().questionsbyid(id: FirebaseAuth.instance.currentUser!.uid), // a previously-obtained Future<String> or null
                                            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                                              if(snapshot.hasData){

                                                return  ListView.builder(shrinkWrap: true,
                                                  itemCount: snapshot.data!.length,

                                                  itemBuilder: (context, index2) {

                                                    return Opacity( opacity:selectedOldQuestions==null?1: selectedOldQuestions.length>0?( selectedOldQuestions.contains(snapshot.data![index2]["id"])?0.5:1):1,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Expanded(child: Text(snapshot.data![index2]["q"])),
                                                            ElevatedButton(onPressed: (){

                                                              if(selectedOldQuestions.contains(snapshot.data![index2]["id"])){
                                                                try{
                                                                  selectedOldQuestions.remove(snapshot.data![index2]["id"]);
                                                                }catch(e){
                                                                  print(e);
                                                                }
                                                                setState(() {

                                                                });
                                                                setS(() {

                                                                });
                                                              }else{
                                                                print("add");
                                                                try{
                                                                  selectedOldQuestions.add(snapshot.data![index2]["id"]);
                                                                }catch(e){
                                                                  print(e);
                                                                }
                                                                setState(() {

                                                                });
                                                                setS(() {

                                                                });
                                                              }

                                                              Navigator.of(context);
                                                            }, child: Text(selectedOldQuestions.contains(snapshot.data![index2]["id"])?"Remove": "Select"))
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }else{
                                                return Center(child: CircularProgressIndicator(),);
                                              }
                                            }),
                                      ): Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          FutureBuilder<List>(
                                              future: Data().questionsbyid(id: FirebaseAuth.instance.currentUser!.uid), // a previously-obtained Future<String> or null
                                              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                                                if(snapshot.hasData){

                                                  return  ListView.builder(shrinkWrap: true,
                                                    itemCount: snapshot.data!.length,

                                                    itemBuilder: (context, index2) {

                                                      return Opacity( opacity:selectedOldQuestions==null?1: selectedOldQuestions.length>0?( selectedOldQuestions.contains(snapshot.data![index2]["id"])?0.5:1):1,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Expanded(child: Text(snapshot.data![index2]["q"])),
                                                              ElevatedButton(onPressed: (){

                                                                if(selectedOldQuestions.contains(snapshot.data![index2]["id"])){
                                                                  try{
                                                                    selectedOldQuestions.remove(snapshot.data![index2]["id"]);
                                                                  }catch(e){
                                                                    print(e);
                                                                  }
                                                                  setState(() {

                                                                  });
                                                                  setS(() {

                                                                  });
                                                                }else{
                                                                  print("add");
                                                                  try{
                                                                    selectedOldQuestions.add(snapshot.data![index2]["id"]);
                                                                  }catch(e){
                                                                    print(e);
                                                                  }
                                                                  setState(() {

                                                                  });
                                                                  setS(() {

                                                                  });
                                                                }

                                                                Navigator.of(context);
                                                              }, child: Text(selectedOldQuestions.contains(snapshot.data![index2]["id"])?"Remove": "Select"))
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }else{
                                                  return Center(child: CircularProgressIndicator(),);
                                                }
                                              }),
                                          Center(
                                            child: ElevatedButton(onPressed: (){
                                              Navigator.pop(context);
                                            }, child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                                              child: Text("Close"),
                                            )),
                                          )
                                        ],
                                      ),
                                    ),);
                                  }
                              ));
                        }, child: Text("Select question")),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ElevatedButton(onPressed: (){
                            List Options = [];
                            int correctOption = 0;
                            List<TextEditingController> allController = [];

                            TextEditingController c1 = TextEditingController();
                            TextEditingController c2 = TextEditingController();
                            TextEditingController c3 = TextEditingController();


                            double score = 1.0;





                            showDialog(
                                context: context,
                                builder: (_) =>StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setStateC) {
                                      return Dialog(backgroundColor: Colors.grey.shade50,child: Container(width: 1200,height: 900,
                                        child: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(margin: EdgeInsets.symmetric(horizontal: 4,),width: 600,decoration: boxShadow,
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                                                        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                                              child: TextField(controller: c1,decoration: InputDecoration(label:Text("Question title"),contentPadding: EdgeInsets.symmetric(horizontal: 8),),),
                                                            ),

                                                            Padding(
                                                              padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                                              child: TextField(controller: c2,maxLines: 5,minLines: 2,decoration: InputDecoration(label: Text("Question body"),contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 8)),),
                                                            ),


                                                            Padding(
                                                              padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                                              child: TextField(controller: c3,decoration: InputDecoration(label: Text("Explanation"),contentPadding: EdgeInsets.symmetric(horizontal: 8),),),
                                                            ),

                                                            Container(margin: EdgeInsets.symmetric(horizontal: 15),decoration: boxShadow,
                                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                    child: Text("Score"),
                                                                  ),

                                                                  Row(children: [
                                                                    InkWell( onTap: (){
                                                                      setStateC(() {
                                                                        score = 0.5;
                                                                      });

                                                                    },
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Card(color: score==0.5?Colors.blue:Colors.white,child: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Text("0.5",style: TextStyle(color:  score==0.5?Colors.white:Colors.blue),),
                                                                        ),),
                                                                      ),
                                                                    ),
                                                                    InkWell( onTap: (){
                                                                      setStateC(() {
                                                                        score = 1.0;
                                                                      });

                                                                    },
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Card(color: score==1?Colors.blue:Colors.white,child: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Text("1.0",style: TextStyle(color:  score==1.0?Colors.white:Colors.blue),),
                                                                        ),),
                                                                      ),
                                                                    ),
                                                                    InkWell( onTap: (){
                                                                      setStateC(() {
                                                                        score = 1.5;
                                                                      });

                                                                    },
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Card(color: score==1.5?Colors.blue:Colors.white,child: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Text("1.5",style: TextStyle(color:  score==1.5?Colors.white:Colors.blue),),
                                                                        ),),
                                                                      ),
                                                                    ),
                                                                    InkWell( onTap: (){
                                                                      setStateC(() {
                                                                        score = 2.0;
                                                                      });

                                                                    },
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Card(color: score==2.0?Colors.blue:Colors.white,child: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Text("2.0",style: TextStyle(color:  score==2.0?Colors.white:Colors.blue),),
                                                                        ),),
                                                                      ),
                                                                    ),
                                                                  ],),
                                                                ],
                                                              ),
                                                            ),




                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(decoration: boxShadow,child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Text("Options:", ),
                                                              ),
                                                              ElevatedButton(onPressed: (){

                                                                setStateC(() {
                                                                  Options.add("");
                                                                });



                                                              }, child: Text("Add Options")),
                                                            ],
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

                                                        ],
                                                      ),),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(20.0),
                                                  child: Center(
                                                    child: ElevatedButton( onPressed: (){



                                                      Provider.of<AddedProvider>(context, listen: false).add({"explanation":c3.text,"score":score,"correctOption":correctOption,"ans":Options[correctOption],"options":Options,"title":c1.text,"q":c2.text,"type":"SC"});
                                                      Provider.of<AddedProviderOnlyNew>(context, listen: false).add({"explanation":c3.text,"score":score,"correctOption":correctOption,"ans":Options[correctOption],"options":Options,"title":c1.text,"q":c2.text,"type":"SC"});
                                                      setState(() {
                                                      });
                                                      Navigator.pop(context);

                                                    },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: Container(width: 400,child: Center(child: Text("Save",style: TextStyle(color: Colors.white),))),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),);
                                    }
                                ));
                          }, child: Text("Add question")),
                        ),
                      ],
                    ),

                  ],
                ),
              ),),
              Consumer<AddedProvider>(
                  builder: (_, bar, __) =>bar.questions.length>0? Container(
                    margin: EdgeInsets.all(8),
                    decoration: boxShadow,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Expanded(flex: 2,child:Text("Title" )),
                          Expanded(flex: 3,child:Text("Question" )),
                          Expanded(flex: 1,child:Text("Options" )),
                          Expanded(flex: 1,child:Text("Action" )),
                          // Expanded(flex: 2,child:Text("title" )),
                          // Expanded(flex: 3,child:"Question")) ,
                          // Expanded(flex: 1,child:Text( "Options") ),
                        ],
                      ),
                    ),
                  ):Container(margin: EdgeInsets.all(8),decoration: boxShadow,child: Center(child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("No questions added",style: TextStyle(color: Colors.grey),),
                  ),),)),

              Consumer<AddedProvider>(
                builder: (_, bar, __) => bar.questions.length>0? Container(margin: EdgeInsets.symmetric(horizontal: 8),decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.grey)),
                  child: ListView.separated(shrinkWrap: true,
                      itemCount:bar.questions.length,

                      itemBuilder: (context, index) {
                        return Container(margin: EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child:  true?Row(
                              children: [
                                Expanded(flex: 2,child:Text(bar.questions[index]["title"] )),
                                Expanded(flex: 3,child:Text(bar.questions[index]["q"]) ),
                                Expanded(flex: 1,child:Text( bar.questions[index]["options"].length.toString()+" options") ),
                                Expanded(flex: 1,child:ElevatedButton(onPressed: (){
                                  bar.remove(bar.questions[index]);
                                },child: Text("Delete"),)),
                              ],
                            ):Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
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
                                  itemCount:  bar.questions[index]["options"].length,

                                  itemBuilder: (context, index2) {
                                    return  Container(margin:EdgeInsets.symmetric(vertical: 5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: Colors.grey.shade100),width: 300,
                                      child: true? true?Text(bar.questions[index]["options"][index2].toString()):CheckboxListTile(title: Text( false?"--": bar.questions[index]["choice"][index2]),

                                          value: bar.questions[index]["correctOption"]==null?false: index2 ==  bar.questions[index]["correctOption"] , onChanged: (bool? b){
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

                      }, separatorBuilder: (BuildContext context, int index) { return Divider(); },),
                ):Container(height: 0,width: 0,),
              ),


          if(false)    Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell( onTap: (){
                    //questions


                  },
                    child: Card(color: Colors.blue,child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                      child: Text("Create Question",style: TextStyle(color: Colors.white),),
                    ),),
                  ),
                  // InkWell( onTap: (){
                  //   //questions
                  //
                  //   List Options = [];
                  //   int correctOption = 0;
                  //   List<TextEditingController> allController = [];
                  //
                  //   TextEditingController c1 = TextEditingController();
                  //   TextEditingController c2 = TextEditingController();
                  //
                  //
                  //
                  //
                  //
                  //
                  //
                  //   showDialog(
                  //       context: context,
                  //       builder: (_) => true?Dialog(
                  //         child:Scaffold(appBar: PreferredSize(preferredSize: Size(0,50),child: Row(
                  //           children: [
                  //             TextButton(onPressed: (){
                  //               Navigator.pop(context);
                  //
                  //             }, child: Text("Done")),
                  //           ],
                  //         ) ,),body:  FirestoreQueryBuilder(pageSize: 20,
                  //           query: FirebaseFirestore.instance.collection( "questions").where("quize_type",isEqualTo: "SC") ,
                  //           builder: (context, snapshot, _) {
                  //             if (snapshot.isFetching) {
                  //               return Center(child: const Text("Please wait"));
                  //             }
                  //             if (snapshot.hasError) {
                  //               return Text('error ${snapshot.error}');
                  //             }
                  //
                  //             return ListView.separated(padding: EdgeInsets.all(10), shrinkWrap: true,
                  //               itemCount: snapshot.docs.length,
                  //               itemBuilder: (context, index) {
                  //                 // if we reached the end of the currently obtained items, we try to
                  //                 // obtain more items
                  //                 if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                  //                   // Tell FirestoreQueryBuilder to try to obtain more items.
                  //                   // It is safe to call this function from within the build method.
                  //                   snapshot.fetchMore();
                  //                 }
                  //
                  //                 final data = snapshot.docs[index];
                  //                 //  ccc = context;
                  //                 //QuestionsSelectedProvider
                  //                 return  true?Consumer<QuestionsSelectedProvider>(
                  //                     builder: (_, bar, __) => InkWell(onTap: (){},child: Row(children: [
                  //                       Padding(
                  //                         padding: const EdgeInsets.symmetric(horizontal: 10),
                  //                         child: Checkbox(value: bar.selectedQuestions.contains(data.id),onChanged: (val){
                  //                           if(val!){
                  //                             bar.add(data.id,data);
                  //                             //Provider.of<QuestionsSelectedProvider>(context, listen: false).
                  //
                  //                           }else{
                  //                             bar.remove(data.id);
                  //                           }
                  //
                  //                         },),
                  //                       ),
                  //                       data["title"]==""? HtmlWidget(data["q"]):  Row(
                  //                        children: [
                  //                          Text(data["title"]),
                  //                          HtmlWidget(data["q"]),
                  //                          Wrap(
                  //                            children:data["choice"].map<Widget>((e) => Padding(
                  //                              padding: const EdgeInsets.all(8.0),
                  //                              child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),border: Border.all()),width: 150,child: Center(child: Text(e,overflow: TextOverflow.fade,))),
                  //                            )).toList(),
                  //                          ),
                  //                        ],
                  //                       ),
                  //
                  //
                  //
                  //
                  //                     ],))):
                  //                 Consumer<QuestionsSelectedProvider>(
                  //                     builder: (_, bar, __) =>InkWell(onTap: (){
                  //                       Map<String,dynamic> json = data.data() as Map<String,dynamic>;
                  //                       json["created_at"] = DateTime.now().millisecondsSinceEpoch;
                  //
                  //
                  //                       showBottomSheet(
                  //                           context: context,
                  //                           builder: (context) => Container(
                  //                             color: Colors.white,
                  //                             height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
                  //                             child: Column(
                  //                               children: [
                  //                                 Row(
                  //                                   children: [
                  //                                     IconButton(onPressed: (){
                  //                                       Navigator.pop(context);
                  //                                     }, icon: Icon(Icons.arrow_back_rounded)),
                  //                                   ],
                  //                                 ),
                  //
                  //                                 Padding(
                  //                                   padding: const EdgeInsets.all(8.0),
                  //                                   child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Question")),onChanged: (String d){
                  //                                     json["q"] = d;
                  //                                   },initialValue:json["q"] ,),
                  //                                 ),
                  //
                  //                                 Padding(
                  //                                   padding: const EdgeInsets.all(8.0),
                  //                                   child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Title")),onChanged: (String d){
                  //                                     json["title"] = d;
                  //                                   },initialValue:json["title"] ,),
                  //                                 ),
                  //
                  //                                 ListView.builder(shrinkWrap: true,
                  //                                     itemCount: json["choice"].length,
                  //                                     itemBuilder: (context, index2) {
                  //                                       return Padding(
                  //                                         padding: const EdgeInsets.all(8.0),
                  //                                         child:  TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Option "+(index2+1).toString())),onChanged: (String d){
                  //                                           json["choice"][index2] = d;
                  //                                         },initialValue:json["choice"][index2]),
                  //                                       );
                  //                                     }),
                  //
                  //                                 Padding(
                  //                                   padding: const EdgeInsets.all(8.0),
                  //                                   child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Correct ans")),onChanged: (String d){
                  //                                     json["ans"] = d;
                  //                                   },initialValue:json["ans"] ,),
                  //                                 ),
                  //
                  //                                 TextButton(onPressed: (){
                  //
                  //                                   data.reference.update(json);
                  //
                  //                                   Navigator.pop(context);
                  //                                 }, child: Text("Update")),
                  //
                  //                                 if(false)   InkWell(onTap: (){
                  //                                   FirebaseFirestore.instance.collection("questions").add(json);
                  //                                   FirebaseFirestore.instance.collection("questions").add(json);
                  //                                   Navigator.pop(context);
                  //
                  //
                  //                                 },),
                  //
                  //
                  //
                  //                               ],
                  //                             ),
                  //                           ),
                  //                           ));
                  //
                  //                       // scaffoldKey.currentState!
                  //                       //     .showBottomSheet((context) => Container(
                  //                       //   color: Colors.red,
                  //                       // ));
                  //                     },
                  //                       child: Row(
                  //                         children: [
                  //                           if(false)  Container(margin: EdgeInsets.all(5), decoration: BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.circular(2)),child: Padding(
                  //                             padding: const EdgeInsets.all(8.0),
                  //                             child: Text(data.get("quize_type"),style: TextStyle(color: Colors.white),),
                  //                           )),
                  //
                  //                           Checkbox(value: bar.selectedQuestions.contains(data.id),onChanged: (val){
                  //                             if(val!){
                  //                               bar.add(data.id,data);
                  //                               //Provider.of<QuestionsSelectedProvider>(context, listen: false).
                  //
                  //                             }else{
                  //                               bar.remove(data.id);
                  //                             }
                  //
                  //                           },),
                  //
                  //
                  //                           Expanded(
                  //                             child: HoverButtons(data: data,onCl: (String d){
                  //
                  //                             },),
                  //                           ),
                  //
                  //                         ],
                  //                       ),
                  //                     ));
                  //
                  //               }, separatorBuilder: (BuildContext context, int index) { return Container(height: 0.5,width: double.infinity,color: Colors.grey,); },
                  //             );
                  //           },
                  //         ),),
                  //       ):
                  //       StatefulBuilder(
                  //           builder: (BuildContext context, StateSetter setStateC) {
                  //             return Dialog(child: Container(width: 500,height: 900,
                  //               child: SingleChildScrollView(
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.all(20.0),
                  //                   child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                  //                     children: [
                  //                       InkWell(onTap: (){
                  //                         Navigator.pop(context);
                  //                       },child: Padding(
                  //                         padding: const EdgeInsets.all(8.0),
                  //                         child: Row(
                  //                           children: [
                  //                             Icon(Icons.navigate_before_rounded,color: Colors.blue,),
                  //                             Text("Back",style: TextStyle(color: Colors.blue),),
                  //                           ],
                  //                         ),
                  //                       ),),
                  //                       Padding(
                  //                         padding: const EdgeInsets.all(8.0),
                  //                         child: TextField(controller: c1,decoration: InputDecoration(label: Text("Question title")),),
                  //                       ),
                  //                       Padding(
                  //                         padding: const EdgeInsets.all(8.0),
                  //                         child: TextField(controller: c2,decoration: InputDecoration(label: Text("Question body")),),
                  //                       ),
                  //                       Padding(
                  //                         padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 8),
                  //                         child: ClipRRect(borderRadius: BorderRadius.circular(5),child: Row(
                  //                           children: [
                  //                             Expanded(child: InkWell( onTap: (){
                  //                               setState(() {
                  //                                 qt = (qt == questionType.singleChoice)?questionType.multipleChoice:questionType.singleChoice;
                  //                               });
                  //                               print(qt);
                  //                             },
                  //                               child: Container(color: qt == questionType.singleChoice?Colors.blue:Colors.white,
                  //                                 child: Center(child: Padding(
                  //                                   padding: const EdgeInsets.all(10.0),
                  //                                   child: Text("Single choice",style: TextStyle(color: qt == questionType.multipleChoice?Colors.blue:Colors.white ),),
                  //                                 ),),),
                  //                             )),
                  //                             Expanded(child: InkWell(onTap: (){
                  //                               setState(() {
                  //                                 qt = (qt == questionType.singleChoice)?questionType.multipleChoice:questionType.singleChoice;
                  //                               });
                  //                               print(qt);
                  //                             },
                  //                               child: Container(color: qt == questionType.multipleChoice?Colors.blue:Colors.white,
                  //                                 child: Center(child: Padding(
                  //                                   padding: const EdgeInsets.all(10.0),
                  //                                   child: Text("Multiple choice",style: TextStyle(color: qt == questionType.singleChoice?Colors.blue:Colors.white ),),
                  //                                 ),),),
                  //                             )),
                  //                           ],
                  //                         ),),
                  //                       ),
                  //                       Padding(
                  //                         padding: const EdgeInsets.all(8.0),
                  //                         child: Text("Options:", ),
                  //                       ),
                  //                       ListView.builder(shrinkWrap: true,
                  //                         itemCount: Options.length,
                  //
                  //                         itemBuilder: (context, index) {
                  //                           TextEditingController c = TextEditingController(text: Options[index]);
                  //                           allController.add(c);
                  //                           return ListTile(trailing: IconButton(onPressed: (){
                  //                             allController.removeAt(index);
                  //                             Options.removeAt(index);
                  //
                  //                             setStateC(() {
                  //                             });
                  //
                  //                           },icon: Icon(Icons.delete),),leading: Checkbox(value: index==correctOption,onChanged: (bool? b){
                  //                             if(b == true){
                  //
                  //                               correctOption = index;
                  //                               setStateC(() {
                  //                               });
                  //                             }
                  //
                  //                           },),
                  //                             title: Padding(
                  //                               padding: const EdgeInsets.all(8.0),
                  //                               child: TextFormField(onChanged: (String s){
                  //                                 Options[index] = s ;
                  //                               },controller: c,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),label: Text("Option "+(index+1).toString())),),
                  //                             ),
                  //                           );
                  //                         },
                  //                       ),
                  //                       TextButton(onPressed: (){
                  //
                  //                         setStateC(() {
                  //                           Options.add("");
                  //                         });
                  //
                  //
                  //
                  //                       }, child: Text("Add Options")),
                  //                       InkWell( onTap: (){
                  //
                  //
                  //
                  //                         Provider.of<AddedProvider>(context, listen: false).add({"score":1,"correctOption":correctOption,"ans":Options[correctOption],"choice":Options,"title":c1.text,"q":c2.text,"quize_type":"SC"});
                  //                         setState(() {
                  //                         });
                  //                         Navigator.pop(context);
                  //
                  //                       },
                  //                         child: Card(color: Colors.blue,child: Padding(
                  //                           padding: const EdgeInsets.all(10.0),
                  //                           child: Text("Save",style: TextStyle(color: Colors.white),),
                  //                         ),),
                  //                       ),
                  //
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),);
                  //           }
                  //       )).whenComplete(() {
                  //
                  //     for(int  i = 0; i < Provider.of<QuestionsSelectedProvider>(context, listen: false).selectedQuestionsBody.length ; i++){
                  //       Provider.of<AddedProvider>(context, listen: false).add(Provider.of<QuestionsSelectedProvider>(context, listen: false).selectedQuestionsBody[i]);
                  //
                  //     }
                  //
                  //
                  //
                  //     Provider.of<QuestionsSelectedProvider>(context, listen: false).totalMarks = 0;
                  //     Provider.of<QuestionsSelectedProvider>(context, listen: false).selectedQuestionsBody =[];
                  //     Provider.of<QuestionsSelectedProvider>(context, listen: false).selectedQuestions = [];
                  //
                  //   });
                  // },
                  //   child: Card(color: Colors.blue,child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                  //     child: Text("Select Question",style: TextStyle(color: Colors.white),),
                  //   ),),
                  // ),
                ],
              ),






            ],),
          )),),);
  }
}
