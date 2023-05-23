import 'package:flutter/material.dart';

import '../common/custom_text_form_field.dart';
import '../common/default_layout.dart';

class CommunitySearchScreen extends StatelessWidget {
  const CommunitySearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Search',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextFormField(
                hintText: '글 제목, 내용',
                onchanged: (String value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}