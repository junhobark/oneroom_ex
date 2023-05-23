import 'package:flutter/material.dart';

import '../common/default_layout.dart';

class MarketBoardScreen extends StatelessWidget {
  const MarketBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '장터게시판',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text('장터게시판 리스트')),
            ],
          ),
        ),
      ),
    );
  }
}
