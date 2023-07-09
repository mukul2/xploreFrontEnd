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

  List _items = [];

  List get items => _items;

  set items(List value) {
    _items = value;
    notifyListeners();
  }
  addData(int i){
    _items.add(i);
    notifyListeners();
  }
  removeData(int i){
    _items.remove(i);
    notifyListeners();
  }
}