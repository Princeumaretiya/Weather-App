import 'package:flutter/material.dart';

import '../variable/thememodel.dart';


class providers extends ChangeNotifier {
  ThemeDetails themeDetails = ThemeDetails(isdark: false);

  void themeToggle(){
    themeDetails.isdark =! themeDetails.isdark;
    notifyListeners();
  }

}
