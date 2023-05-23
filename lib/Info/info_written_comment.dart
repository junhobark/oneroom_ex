import 'package:flutter/material.dart';

import '../common/default_layout.dart';

class WrittenCommentScreen extends StatelessWidget {
  const WrittenCommentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '내가 쓴 댓글',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text('내가 쓴 댓글')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
