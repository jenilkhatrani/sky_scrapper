import 'package:flutter/cupertino.dart';
import 'package:sky_scrapper/Model/ThemeModel.dart';

class ThemeProvider with ChangeNotifier{

  ThemeModel themeModel = ThemeModel(isdark: false);

void theme(){
themeModel.isdark= !themeModel.isdark;
notifyListeners();
}
}