import 'dart:convert';

import 'package:http/http.dart' as http;
class Data{
String base ="https://quizhub.online";
//  String base = "http://139.59.74.58";
  Future<List>quizesX () async {

   try{
     http.Response r =  await http.get(Uri.parse(base+"/quizes"));
     return jsonDecode(r.body);
   }catch(e){
     return [];

   }
  }
  Future<dynamic >userInfo ({required String id}) async {

   try{
     http.Response r =  await http.get(Uri.parse(base+"/user/"+id));
     return jsonDecode(r.body);
   }catch(e){
     return {};

   }
  }

  Future<List>quizesHandelerid ({required String id}) async {

   try{
     print("quizes");
     http.Response r =  await http.post(Uri.parse(base+"/quizes"),headers: {'Content-Type': 'application/json',},body: jsonEncode({"uid":id}));
     print(r.body);
     return jsonDecode(r.body);
   }catch(e){
     print(e);
     return [];

   }
  }

  Future<List>chaptersonsubject (String subjectId) async {
    print("subjectsidx");

    try{
      http.Response r =  await http.get(Uri.parse(base+"/chaptersonsubject/"+subjectId,));
      print("res start");
      print(r.body);
      print("res end");
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return [];

    }
  }

  Future<List>chapters () async {
    print("subjectsidx");

    try{
      http.Response r =  await http.get(Uri.parse(base+"/chapters",));
      print("res start");
      print(r.body);
      print("res end");
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return [];

    }
  }  Future<List>chaptersidx ({required String id}) async {
    print("subjectsidx");

    try{
      http.Response r =  await http.post(Uri.parse(base+"/getchaptersbyteacher",),headers: {'Content-Type': 'application/json',},body: jsonEncode({"created_by":id}));
      print("res start");
      print(r.body);
      print("res end");
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return [];

    }
  }
  Future<List>subjectsidx ({required String id}) async {
    print("subjectsidx");

    try{
      http.Response r =  await http.post(Uri.parse(base+"/getsubjects",),headers: {'Content-Type': 'application/json',},body: jsonEncode({"created_by":id}));
      print("res start");
      print(r.body);
      print("res end");
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return [];

    }
  }
  Future<List>quizesidx ({required String id}) async {

   try{
     http.Response r =  await http.post(Uri.parse(base+"/quizes",),headers: {'Content-Type': 'application/json',},body: jsonEncode({"uid":id}));
     return jsonDecode(r.body);
   }catch(e){
     return [];

   }
  }
  Future<List>batchesid ({required String id}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/batches"),headers: {'Content-Type': 'application/json',},body: jsonEncode({"created_by":id}));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      return [];

    }
  }
  Future<List>batches () async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/batches"));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      return [];

    }
  }

  Future saveBatches ({required dynamic data}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/savebatch",),headers: {'Content-Type': 'application/json',},body: jsonEncode( data));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return{};

    }
  }
  Future buycuize ({required dynamic data}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/savequizpurchase",),headers: {'Content-Type': 'application/json',},body: jsonEncode( data));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return{};

    }
  }
  Future buycourse ({required dynamic data}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/buycourse",),headers: {'Content-Type': 'application/json',},body: jsonEncode( data));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return{};

    }
  }
  Future savequestion ({required dynamic data}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/savesquestion",),headers: {'Content-Type': 'application/json',},body: jsonEncode( data));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return{};

    }
  }

  Future saveQuiz ({required dynamic data}) async {
    print("Save quiz api start");
    try{
      http.Response r =  await http.post(Uri.parse(base+"/savequiz",),headers: {'Content-Type': 'application/json',},body: jsonEncode( data));
      print(r.body);
      print("Save quiz response");
      return jsonDecode(r.body);
    }catch(e){
      print("Save quiz response catches");
      print(e);
      return e;

    }
  }
  Future<List>teachers () async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/teachers"),);

      return jsonDecode(r.body);
    }catch(e){
      return [];

    }
  }

  Future<dynamic>subject ({required String id}) async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/subject/"+id),);

      return jsonDecode(r.body);
    }catch(e){
      return {};

    }
  }
  Future<dynamic>coursedetails ({required String id}) async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/course-details/"+id),);

      return jsonDecode(r.body);
    }catch(e){
      return {};

    }
  }
  Future<dynamic>lectures ({required String id}) async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/lectures/"+id),);

      return jsonDecode(r.body);
    }catch(e){
      return {};

    }
  }
  Future<dynamic>deletecourse ({required String id}) async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/deletecourse/"+id),);
      return jsonDecode(r.body);
    }catch(e){
      return {};

    }
  }
  Future<dynamic>deletequize ({required String id}) async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/deletequize/"+id),);
      return jsonDecode(r.body);
    }catch(e){
      return {};

    }
  }  Future<dynamic>quize ({required String id}) async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/quize/"+id),);
      return jsonDecode(r.body);
    }catch(e){
      return {};

    }
  }
  Future<dynamic>myquizeearnings ({required String id}) async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/myquizeearnings/"+id),);
      print(base+"/myquizeearnings/"+id);
      return jsonDecode(r.body);
    }catch(e){
      return {};

    }
  }
  Future<dynamic>myearning ({required String id}) async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/myearnings/"+id),);
      return jsonDecode(r.body);
    }catch(e){
      return {};

    }
  }
  Future<List>mystudents ({required String id}) async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/mystudents/"+id),);
      return jsonDecode(r.body);
    }catch(e){
      return [];

    }
  }
  Future<List>studentsid ({required String id}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/getstudents"),headers: {'Content-Type': 'application/json',},body: jsonEncode({"created_by":id}));
      return jsonDecode(r.body);
    }catch(e){
      return [];

    }
  }  Future<List>mypurchasedquizes ({required String id}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/mypurchasedquizes"),headers: {'Content-Type': 'application/json',},body: jsonEncode({"uid":id}));
      return jsonDecode(r.body);
    }catch(e){
      return [];

    }
  }

  Future<List>getcourse ({required String id}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/getcourse"),headers: {'Content-Type': 'application/json',},body: jsonEncode({"uid":id}));
      return jsonDecode(r.body);
    }catch(e){
      return [];

    }
  }
  Future<List>classes () async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/classes"));
      return jsonDecode(r.body);
    }catch(e){
      return [];

    }
  }
  Future<List>subjectsinclass (String classId) async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/subjectsinclass/"+classId));
      return jsonDecode(r.body);
    }catch(e){
      return [];

    }
  }  Future<List>subjects () async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/subjects"));
      return jsonDecode(r.body);
    }catch(e){
      return [];

    }
  }
  Future<List>students () async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/students"));
      return jsonDecode(r.body);
    }catch(e){
      return [];

    }
  }
  Future saveoptions ({required Map data}) async {
    print("get questions");

    try{
      http.Response r =  await http.post(Uri.parse(base+"/options"),headers: {'Content-Type': 'application/json',},body: jsonEncode(data));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return [];

    }
  }
  Future<List>myquizes ({required String id}) async {
    print("get questions");

    try{
      http.Response r =  await http.get(Uri.parse(base+"/myquizes/"+id));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return [];

    }
  }
  Future<List>options ({required String id}) async {
    print("get questions");

    try{
      http.Response r =  await http.get(Uri.parse(base+"/options/"+id));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return [];

    }
  }

  Future<List>mysubmittedQuizes ({required String id}) async {
    print("get questions");

    try{
      http.Response r =  await http.post(Uri.parse(base+"/mysubmittedQuizes"),headers: {'Content-Type': 'application/json',},body: jsonEncode({"student_id":id}));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return [];

    }
  }
  Future<List>questionsbyid ({required String id}) async {
    print("get questions");

    try{
      http.Response r =  await http.post(Uri.parse(base+"/questions"),headers: {'Content-Type': 'application/json',},body: jsonEncode({"created_by":id}));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return [];

    }
  }
  Future<List>questions () async {
    print("get questions");

    try{
      http.Response r =  await http.get(Uri.parse(base+"/questions"));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return [];

    }
  }
  Future<List>quizAuestions ({required String id}) async {
    print("get questions");
    try{
      http.Response r =  await http.get(Uri.parse(base+"/quizequestions/"+id));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return [];

    }
  }
  Future quizsubmit ({required dynamic data}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/quiz-submit",),headers: {'Content-Type': 'application/json',},body: jsonEncode( data));
      print(r.body);
      return r.body;
    }catch(e){
      print(e);
      return e;

    }
  }  Future saveTeacher ({required dynamic data}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/saveteacher",),headers: {'Content-Type': 'application/json',},body: jsonEncode( data));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return{};

    }
  }
  Future saveStudents ({required dynamic data}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/savestudent",),headers: {'Content-Type': 'application/json',},body: jsonEncode( data));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return{};

    }
  }
  Future<List>classesid ({required String id}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/getclasses"),headers: {'Content-Type': 'application/json',},body: jsonEncode({"created_by":id}));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return [];

    }
  }
  Future<List>classesx () async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/getclasses"));
      return jsonDecode(r.body);
    }catch(e){
      return [];

    }
  }
  Future saveChapters ({required dynamic data}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/saveschapters",),headers: {'Content-Type': 'application/json',},body: jsonEncode( data));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return{};

    }
  }
  Future saveSubjects ({required dynamic data}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/savesubjects",),headers: {'Content-Type': 'application/json',},body: jsonEncode( data));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return{};

    }
  }

  Future deletequestion ({required String id}) async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/deletequestion/"+id,),);
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return{};

    }
  }
  Future deletesubject ({required String id}) async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/deletesubject/"+id,),);
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return{};

    }
  }
  Future deletechapter ({required String id}) async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/deletechapter/"+id,),);
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return{};

    }
  }
  Future deleteClasses ({required String id}) async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/deleteclass/"+id,),);
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return{};

    }
  }
  Future saveClasses ({required dynamic data}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/saveclass",),headers: {'Content-Type': 'application/json',},body: jsonEncode( data));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return{};

    }
  }  Future updatequestion ({required dynamic data}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/updatequestion",),headers: {'Content-Type': 'application/json',},body: jsonEncode( data));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return{};

    }
  }
}
