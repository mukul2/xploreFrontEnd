import 'dart:convert';

import 'package:http/http.dart' as http;
class Data{
  String base ="https://quizhub.online";
  Future<List>quizesX () async {

   try{
     http.Response r =  await http.get(Uri.parse(base+"/quizes"));
     return jsonDecode(r.body);
   }catch(e){
     return [];

   }
  }  Future<List>quizesHandelerid ({required String id}) async {

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
  Future<List>chaptersidx ({required String id}) async {
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

    try{
      http.Response r =  await http.post(Uri.parse(base+"/savequiz",),headers: {'Content-Type': 'application/json',},body: jsonEncode( data));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return{};

    }
  }
  Future<List>studentsid ({required String id}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/getstudents"),headers: {'Content-Type': 'application/json',},body: jsonEncode({"created_by":id}));
      return jsonDecode(r.body);
    }catch(e){
      return [];

    }
  }
  Future<List>students () async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/getstudents"));
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
  Future saveTeacher ({required dynamic data}) async {

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
  Future<List>classes () async {

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
  Future saveClasses ({required dynamic data}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/saveclass",),headers: {'Content-Type': 'application/json',},body: jsonEncode( data));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return{};

    }
  }
}
