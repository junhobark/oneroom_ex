import 'package:flutter/foundation.dart';

class REVIEW2Provider extends ChangeNotifier {
  String advantage;
  String weakness;
  String etc;

  REVIEW2Provider({
    required this.advantage,
    required this.weakness,
    required this.etc,
  });

  void setall(String advantage, String weakness, String etc) {
    this.advantage = advantage;
    this.weakness = weakness;
    this.etc = etc;
    notifyListeners();
  }

  void set1(String advantage) {
    this.advantage = advantage;
    notifyListeners();
  }

  void set2(String weakness) {
    this.weakness = weakness;
    notifyListeners();
  }

  void set3(String etc) {
    this.etc = etc;
    notifyListeners();
  }
}
