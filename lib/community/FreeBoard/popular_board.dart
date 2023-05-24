import 'package:flutter/material.dart';
import 'package:oneroom_ex/common/colors.dart';

class PopularBoard extends StatelessWidget {
  final String popularContentTitle;
  final String popularContent;

  const PopularBoard({
    required this.popularContentTitle,
    required this.popularContent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          //color: Colors.white,
          border: Border.all(
            width: 1.0,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            _PopularBoardContent(
                popularContentTitle: popularContentTitle,
                popularContent: popularContent),
          ],
        ),
      ),
    );
  }
}

class _PopularBoardContent extends StatelessWidget {
  final String popularContentTitle;
  final String popularContent;

  const _PopularBoardContent({
    required this.popularContentTitle,
    required this.popularContent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            popularContentTitle,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20.0,
            ),
          ),
          SizedBox(height: 6),
          Text(
            popularContent,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16.0,
              color: BODY_TEXT_COLOR,
            ),
          ),
        ],
      ),
    );
  }
}
