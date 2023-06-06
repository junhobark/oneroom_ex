import 'package:flutter/foundation.dart';

class SortedProvider extends ChangeNotifier {
  int sorted;


  SortedProvider(
      {required this.sorted,
   });

  void sort0() {
    this.sorted = 0;
    notifyListeners();
  }
  void sort1() {
    this.sorted = 1;
    notifyListeners();
  }
  void sort2() {
    this.sorted = 2;
    notifyListeners();
  }
}
