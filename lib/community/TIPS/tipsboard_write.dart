import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oneroom_ex/common/colors.dart';

class TipsBoardWrite extends StatefulWidget {
  const TipsBoardWrite({Key? key}) : super(key: key);

  @override
  State<TipsBoardWrite> createState() => _TipsBoardWriteState();
}

class _TipsBoardWriteState extends State<TipsBoardWrite> {
  XFile? _image;
  final ImagePicker picker = ImagePicker();
  String titleInput = "";
  String bodyInput = "";

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  void _tipsBoardWriteState() async {
    final dio = Dio();
    var url = 'http://10.0.2.2:8080/community/TIPS/write';

    Map<String, dynamic> postDto = {
      'memberId': 'abc',
      'title': titleInput,
      'body': bodyInput,
    };

    FormData formData = FormData.fromMap({
      'postDto': MultipartFile.fromString(
        jsonEncode(postDto),
        contentType: MediaType('application', 'json'),
      ),
    });

    if (_image != null) {
      formData.files.add(
        MapEntry(
          'file',
          await MultipartFile.fromFile(_image!.path, filename: _image!.name),
        ),
      );
    }

    try {
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      if (response.statusCode == 200) {
        // POST 요청이 성공한 경우
        print('POST 요청 성공!');
        print('POST 요청 상태 코드: ${response.statusCode}');
      } else {
        // POST 요청이 실패한 경우
        print(' ${_image!.name}');
        print('POST 요청 실패. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      // 네트워크 오류 등 예외 처리
      print('POST 요청 오류: $e');
      print(' ${_image!.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //키보드 누르다 다른곳 누르면 키보드 사라지게 설정
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          title: Text(
            '글쓰기',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: '제목',
                onChanged: (value) {
                  setState(() {
                    titleInput = value;
                  });
                },
              ),
              SizedBox(height: 20.0),
              CustomTextFieldContent(
                label: '내용',
                onChanged: (value) {
                  setState(() {
                    bodyInput = value;
                  });
                },
              ),
              SizedBox(height: 20.0),
              _buildPhotoArea(),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _tipsBoardWriteState,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                  foregroundColor: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 150.0, vertical: 10.0),
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: Text('작성하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
            width: 60,
            height: 60,
            child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄워주는 코드
          )
        : Container(
            child: IconButton(
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              icon: Icon(
                Icons.photo_library_rounded,
                size: 30,
                color: BODY_TEXT_COLOR,
              ),
            ),
            width: 60,
            height: 60,
            color: Colors.grey[200],
          );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;

  const CustomTextField({
    required this.label,
    required this.onChanged,
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
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class CustomTextFieldContent extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;

  const CustomTextFieldContent({
    required this.label,
    required this.onChanged,
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
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
