import 'package:flutter/material.dart';
import 'package:oneroom_ex/common/colors.dart';
import 'package:oneroom_ex/common/default_layout.dart';

class TipsBoardSearch extends StatelessWidget {
  const TipsBoardSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      ),
    );

    return DefaultLayout(
      title: 'Search',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                cursorColor: PRIMARY_COLOR,
                autofocus: true,
                onChanged: (String value) {},
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: '글 제목, 내용',
                  hintStyle: TextStyle(
                    color: BODY_TEXT_COLOR,
                    fontSize: 16.0,
                  ),
                  fillColor: INPUT_BG_COLOR,
                  filled: true,
                  border: baseBorder,
                  focusedBorder: baseBorder.copyWith(
                    borderSide: baseBorder.borderSide.copyWith(
                      color: PRIMARY_COLOR,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 80),
              Image.asset('asset/img/logo/tip_search.png')
            ],
          ),
        ),
      ),
    );
  }
}
