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