
import 'package:flutter/cupertino.dart';

class AdminMode extends ChangeNotifier
{

  bool isAdmin =false;
  ChangeisAdmin(bool value){
isAdmin=value;
notifyListeners();
}
}