import 'package:flutter/foundation.dart';

class LocationProvider extends ChangeNotifier {
  double lat;
  double lng;
  String loca;
  int cnt;

  LocationProvider(
      {required this.lat,
      required this.lng,
      required this.loca,
      required this.cnt});

  void setlocation(double lat, double lng, String loca, int cnt) {
    this.lat = lat;
    this.lng = lng;
    this.loca = loca;
    this.cnt = cnt;
    notifyListeners();
  }
}
