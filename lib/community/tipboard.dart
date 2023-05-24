import 'package:flutter/material.dart';
import '../common/default_layout.dart';

class TipBoardScreen extends StatelessWidget {
  const TipBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '자취 꿀팁',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text('자취 꿀팁 리스트')),
            ],
          ),
        ),
      ),
    );
  }
}
