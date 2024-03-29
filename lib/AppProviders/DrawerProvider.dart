import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


class DrawerProviderProvider extends ChangeNotifier {



  List<String> drawerItems= ["Question bank","Quiz","New Quiz","New Questions"];
  int _selectedMenu = 0 ;

  int get selectedMenu => _selectedMenu;

  set selectedMenu(int value) {
    _selectedMenu = value;
    notifyListeners();
  }




}

class QuestionsSelectedProvider extends ChangeNotifier {

  int _totalMarks = 0;

  int get totalMarks => _totalMarks;

  set totalMarks(int value) {
    _totalMarks = value;
    notifyListeners();
  }
  void addMarks(int v){
    _totalMarks = _totalMarks+v;
    notifyListeners();
  }
  void removeMarks(int v){
    _totalMarks = _totalMarks-v;
    notifyListeners();
  }


  List<String> _selectedQuestions= [];
  List _selectedQuestionsBody= [];

  List get selectedQuestionsBody => _selectedQuestionsBody;

  set selectedQuestionsBody(List value) {
    _selectedQuestionsBody = value;
    notifyListeners();
  }

  List<String> get selectedQuestions => _selectedQuestions;

  set selectedQuestions(List<String> value) {
    _selectedQuestions = value;
    notifyListeners();
  }
  void add(String id,QueryDocumentSnapshot qds){
    _selectedQuestions.add(id);
    _selectedQuestionsBody.add(qds);
    addMarks(int.parse(qds.get("score").toString()));

    notifyListeners();
  }
  void remove(String id){
    _selectedQuestions.remove(id);
    for(int i = 0 ; i < _selectedQuestionsBody.length ; i++){
      if(_selectedQuestionsBody[i].id == id){
        removeMarks(int.parse(_selectedQuestionsBody[i].get("score").toString()));
        _selectedQuestionsBody.removeAt(i);
        break;

      }
    }
    notifyListeners();
  }





}


class AddedProvider extends ChangeNotifier {

  List _questions = [];

  List get questions => _questions;

  set questions(List value) {
    _questions = value;
    notifyListeners();
  }
  void add(dynamic s){
    _questions.add(s);
    notifyListeners();
  }

  void remove(dynamic s){
    _questions.remove(s);
    notifyListeners();
  }



}
class AddedProviderOnlyNew extends ChangeNotifier {

  List _questions = [];

  List get questions => _questions;

  set questions(List value) {
    _questions = value;
    notifyListeners();
  }
  void add(dynamic s){
    _questions.add(s);
    notifyListeners();
  }





}
class Batchprovider extends ChangeNotifier {

  List _items = [];

  List get items => _items;

  set items(List value) {
    _items = value;
    notifyListeners();
  }






}
class Classprovider extends ChangeNotifier {

  List _items = [];

  List get items => _items;

  set items(List value) {
    _items = value;
    notifyListeners();
  }






}
class Quizessprovider extends ChangeNotifier {

  List _items = [];

  List get items => _items;

  set items(List value) {
    _items = value;
    notifyListeners();
  }
}
class Studentsprovider extends ChangeNotifier {

  List _items = [];

  List get items => _items;

  set items(List value) {
    _items = value;
    notifyListeners();
  }
}

class Questionsprovider extends ChangeNotifier {

  List _items = [];

  List get items => _items;

  set items(List value) {
    _items = value;
    notifyListeners();
  }
}
class Chapterprovider extends ChangeNotifier {

  List _items = [];

  List get items => _items;

  set items(List value) {
    _items = value;
    notifyListeners();
  }
}
class Subjectsprovider extends ChangeNotifier {

  List _items = [];

  List get items => _items;

  set items(List value) {
    _items = value;
    notifyListeners();
  }
}
class QuestionSortsprovider extends ChangeNotifier {

  int? _class_id;

  int? get class_id => _class_id;

  set class_id(int? value) {
    _class_id = value;
    notifyListeners();
  }
  int? _subject_id;

  int? get subject_id => _subject_id;

  set subject_id(int? value) {
    _subject_id = value;
    notifyListeners();

  }
  int? _chapter_id;

  int? get chapter_id => _chapter_id;

  set chapter_id(int? value) {
    _chapter_id = value;
    notifyListeners();

  }
}

class Questionprovider extends ChangeNotifier {

  List _data = [];

  List get data => _data;

  set data(List value) {
    _data = value;
  }
  List _items = [];

  List get items => _items;

  set items(List value) {
    _items = value;
    notifyListeners();
  }
  addData(int i,dynamic data){
    _items.add(i);
    _data.add(data);
    notifyListeners();
  }
  removeData(int i,dynamic data){
    _items.remove(i);
    _data.remove(data);
    notifyListeners();
  }
}

class AppRouter extends ChangeNotifier {

  String _path="";

  String get path => _path;

  set path(String value) {
    _path = value;
    notifyListeners();
  }

}
class CurrentLesson extends ChangeNotifier {

  Map<String,dynamic>? _lesson;

  Map<String,dynamic>? get lesson => _lesson;

  set lesson(Map<String,dynamic>? value) {
    _lesson = value;
  }

}
class DrawerSelection extends ChangeNotifier {

  int _selection = 0;

  int get selection => _selection;

  set selection(int value) {
    _selection = value;
    notifyListeners();
  }

}
class DrawerSelectionSub extends ChangeNotifier {
  int _selection = 0;
  int _selectionsub = 0;

  int get selectionsub => _selectionsub;

  set selectionsub(int value) {
    _selectionsub = value;
    notifyListeners();
  }
  int get selection => _selection;
  set selection(int value) {
    _selection = value;
    notifyListeners();
  }

}