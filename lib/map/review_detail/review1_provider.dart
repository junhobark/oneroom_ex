import 'package:flutter/foundation.dart';

class REVIEWProvider extends ChangeNotifier {
  double review_lessor;
  double review_quality;
  double review_area;
  double review_noise;

  REVIEWProvider(
      {required this.review_area,
      required this.review_lessor,
      required this.review_noise,
      required this.review_quality});

  void setall(double review_lessor, double review_noise, double review_quality,
      double review_area) {
    this.review_lessor = review_lessor;
    this.review_noise = review_noise;
    this.review_quality = review_quality;
    this.review_area = review_area;
    notifyListeners();
  }

  void set1(double review_lessor) {
    this.review_lessor = review_lessor;
    notifyListeners();
  }

  void set2(double review_noise) {
    this.review_noise = review_noise;
    notifyListeners();
  }

  void set3(double review_quality) {
    this.review_quality = review_quality;
    notifyListeners();
  }

  void set4(double review_area) {
    this.review_area = review_area;
    notifyListeners();
  }
}
