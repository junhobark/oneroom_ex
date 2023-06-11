import 'package:flutter/foundation.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

class UIDProvider extends ChangeNotifier {
  String uid;
  String nickname;
  String? location;
  String valid;
  late NaverAccessToken access_token;

  UIDProvider(
      {required this.uid,
      required this.nickname,
      required this.valid,
      required this.location,
  });

  void setAccessToken(String id) {
    uid = id;
  }
  void navertoken(NaverAccessToken access){
    this.access_token = access;
    notifyListeners();
  }

  void setdbToken(String nickname, String? location, String valid) {
    this.nickname = nickname;
    this.location = location;
    this.valid = valid;
    notifyListeners();
  }

  void setdbfirst(String nickname, String valid) {
    this.nickname = nickname;
    this.valid = valid;
    notifyListeners();
  }
  void setlocation(String location) {
    this.location = location;
    notifyListeners();
  }
}
