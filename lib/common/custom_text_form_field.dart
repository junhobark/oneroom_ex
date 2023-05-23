import 'package:flutter/material.dart';
import 'package:oneroom_ex/common/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool autofocus;
  final ValueChanged<String>? onchanged;

  const CustomTextFormField({
    required this.onchanged,
    this.hintText,
    this.errorText,
    this.autofocus = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(  //테두리 있는 경계
      borderSide: BorderSide( //테두리
        color: INPUT_BORDER_COLOR,
        width: 1.0, //너비
      ),
    );

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      autofocus: autofocus,  //자동커서
      onChanged: onchanged,  //값이 바뀔때마다 실행되는 콜백
      decoration: InputDecoration(  //텍스트필드 안에서 패딩적용
        contentPadding: EdgeInsets.all(20), //내용물을 앞으로
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 16.0,
        ),
        fillColor: INPUT_BG_COLOR,
        //false - 배경색없음
        //true - 배경색있음
        filled: true,
        //모든 Input 상태의 기본 스타일 세팅
        border: baseBorder,
        //focusedBorder의 색깔만 변경
        focusedBorder: baseBorder.copyWith( //copyWith - 모든 특성 그대로 유지
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),

        ),
      ),
    );
  }
}
