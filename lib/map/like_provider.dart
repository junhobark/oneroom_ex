import 'package:flutter/material.dart';

class LikeProvider extends ChangeNotifier {
  bool isLiked;
  LikeProvider({required this.isLiked});

  void toggleLike() {
    isLiked = !isLiked;
    notifyListeners;
  }

  void Liketrue() {
    isLiked = true;
    notifyListeners;
  }

  void Likefalse() {
    isLiked = false;
    notifyListeners;
  }
}
