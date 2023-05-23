import 'package:flutter/material.dart';
import '../common/default_layout.dart';

class ReviewScreen2 extends StatelessWidget {
  const ReviewScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: '리뷰 작성(2/2)',
        child: SafeArea(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.all(30),
          ),
        ])));
  }
}
