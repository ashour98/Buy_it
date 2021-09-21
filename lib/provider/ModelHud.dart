import 'package:flutter/cupertino.dart';

class ModelHud extends ChangeNotifier
{
  bool isLoding= false;
  changeisLoading(bool value){
    isLoding=value;
    notifyListeners();
  }
}