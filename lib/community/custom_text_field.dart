import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;

  const CustomTextField({
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        TextField(
          cursorColor: Colors.grey,
          //자동커서
          autofocus: true,
          decoration: InputDecoration(
            //textformfield 선 삭제
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
      ],
    );
  }
}

class CustomTextField_Content extends StatelessWidget {
  final String label;

  const CustomTextField_Content({
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        Container(
          height: 160,
          color: Colors.grey[200],
          child: TextField(
            //줄바꿈
            maxLines: null,
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              //textformfield 선 삭제
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
      ],
    );
  }
}
