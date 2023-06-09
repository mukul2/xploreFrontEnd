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