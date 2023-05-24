import 'package:flutter/material.dart';
import 'package:oneroom_ex/common/colors.dart';

class BoardList extends StatelessWidget {
  final String contentTitle;
  final String content;

  const BoardList({
    required this.contentTitle,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Colors.black,
          ),
        ),
      ),
      child: Row(
        children: [
          _BoardContent(contentTitle: contentTitle, content: content),
        ],
      ),
    );
  }
}

class _BoardContent extends StatelessWidget {
  final String contentTitle;
  final String content;

  const _BoardContent({
    required this.contentTitle,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contentTitle,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 6),
            Text(
              content,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16.0,
                color: BODY_TEXT_COLOR,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
