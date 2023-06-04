import 'package:flutter/foundation.dart';

class POSProvider extends ChangeNotifier {
  double posx;
  double posy;

  POSProvider({
    required this.posx,
    required this.posy,
  });

  void setpos(double posx, double posy) {
    this.posx = posx;
    this.posy = posy;
    notifyListeners();
  }
}
