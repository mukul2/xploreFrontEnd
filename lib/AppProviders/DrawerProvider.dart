import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


class DrawerProviderProvider extends ChangeNotifier {
  List<String> drawerItems= ["Question bank","Quiz"];
  int _selectedMenu = 0 ;

  int get selectedMenu => _selectedMenu;

  set selectedMenu(int value) {
    _selectedMenu = value;
    notifyListeners();
  }




}

class QuestionsSelectedProvider extends ChangeNotifier {
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
    notifyListeners();
  }
  void remove(String id){
    _selectedQuestions.remove(id);
    for(int i = 0 ; i < _selectedQuestionsBody.length ; i++){
      if(_selectedQuestionsBody[i].id == id){
        _selectedQuestionsBody.removeAt(i);
        break;

      }
    }
    notifyListeners();
  }





}