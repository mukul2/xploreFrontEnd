import 'dart:convert';

import 'package:http/http.dart' as http;
class Data{
  String base ="http://139.59.74.58";
  Future<List>quizes () async {

   try{
     http.Response r =  await http.get(Uri.parse(base+"/quizes"));
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
  }  Future saveQuiz ({required dynamic data}) async {

    try{
      http.Response r =  await http.post(Uri.parse(base+"/savequiz",),headers: {'Content-Type': 'application/json',},body: jsonEncode( data));
      print(r.body);
      return jsonDecode(r.body);
    }catch(e){
      print(e);
      return{};

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
  Future<List>classes () async {

    try{
      http.Response r =  await http.get(Uri.parse(base+"/getclasses"));
      return jsonDecode(r.body);
    }catch(e){
      return [];

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
