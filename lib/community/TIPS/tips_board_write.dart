import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oneroom_ex/common/colors.dart';
import 'package:oneroom_ex/login/uid_provider.dart';
import 'package:provider/provider.dart';


class TipsBoardWrite extends StatefulWidget {
  const TipsBoardWrite({Key? key}) : super(key: key);

  @override
  State<TipsBoardWrite> createState() => _TipsBoardWriteState();
}

class _TipsBoardWriteState extends State<TipsBoardWrite> {
  List<PickedFile> pickedFiles = [];
  final ImagePicker picker = ImagePicker();
  String titleInput = "";
  String bodyInput = "";

  Future<void> selectImages(BuildContext context) async {
    final selectedFiles = await picker.pickMultiImage(
      maxWidth: 640,
      maxHeight: 280,
      imageQuality: 100,
    );

    if (selectedFiles.isNotEmpty) {
      pickedFiles =
          selectedFiles.map((xFile) => PickedFile(xFile.path)).toList();

      // 선택한 이미지에 대한 작업 수행
      for (var file in selectedFiles) {
        print('Selected image path: ${file.path}');
      }
    } else {
      // 이미지 선택이 취소되었을 때 실행할 작업
      print('Image selection canceled.');
    }

    // 이미지 선택 완료 후 UI 갱신
    refreshUI(context);
  }

  void removeImage(int index, BuildContext context) {
    pickedFiles.removeAt(index);

    // 이미지 삭제 후 UI 갱신
    refreshUI(context);
  }

  void refreshUI(BuildContext context) {
    setState(() {});
  }

  void _tipsBoardWriteState() async {  //1
    final dio = Dio();
    var url = 'http://10.0.2.2:8080/community/TIPS/write';

    Map<String, dynamic> postDto = {
      'memberId': '${Provider.of<UIDProvider>(context,listen: false).uid}',
      'title': titleInput,
      'body': bodyInput,
    };

    FormData formData = FormData.fromMap({
      'postDto': MultipartFile.fromString(
        jsonEncode(postDto),
        contentType: MediaType('application', 'json'),
      ),
    });

    if (pickedFiles.isNotEmpty) {
      for (PickedFile pickedFile in pickedFiles) {
        File imageFile = File(pickedFile.path);
        String fileName = imageFile.path.split('/').last;
        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(
            imageFile.path,
            filename: fileName,
          ),
        ));
      }
    }

    if (titleInput.isEmpty || bodyInput.isEmpty) {
      // 제목 또는 내용이 비어있으면, 작성하기 버튼을 눌러도 동작하지 않도록 합니다.
      return;
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

        // 응답에서 생성된 글 데이터를 가져옵니다
        dynamic newPost = response.data;

        // 이전 화면인 TipsBoardScreen으로 돌아가며 새로운 글 데이터를 전달합니다
        _handlePostSubmit(newPost);
      } else {
        // POST 요청이 실패한 경우
        print('POST 요청 실패. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      // 네트워크 오류 등 예외 처리
      print('POST 요청 오류: $e');
    }
  }

  void _handlePostSubmit(dynamic newPost) {
    Navigator.pop(context, newPost);
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
          actions: <Widget>[
            IconButton(
              onPressed: () {
                selectImages(context);
              },
              icon: Icon(
                Icons.photo_camera,
                size: 24,
                color: Colors.black,
              ),
            ),
          ],
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildPhotoArea(),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: (titleInput.isEmpty || bodyInput.isEmpty)
                    ? null
                    : _tipsBoardWriteState,
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
    return pickedFiles.isNotEmpty
        ? Row(
      children: List.generate(
        pickedFiles.length,
            (index) => Stack(
          children: [
            Container(
              padding: EdgeInsets.all(3),
              child: Image.file(
                File(pickedFiles[index].path),
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.close),
                iconSize: 20,
                onPressed: () {
                  removeImage(index, context);
                },
              ),
            ),
          ],
        ),
      ),
    )
        : Container();
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
        //내용 텍스트필드 크기
        Container(
          height: 120,
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
