import 'package:flutter/material.dart';

import '../common/default_layout.dart';

class FreeBoardScreen extends StatelessWidget {
  const FreeBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '자유게시판',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text('자유게시판 리스트')),
            ],
          ),
        ),
      ),
    );
  }
}
