import 'package:flutter/material.dart';
import 'package:oneroom_ex/common/colors.dart';
import 'package:oneroom_ex/community/custom_text_field.dart';
import 'package:oneroom_ex/community/FreeBoard/freeboard.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class BoardWrite extends StatefulWidget {
  const BoardWrite({Key? key}) : super(key: key);

  @override
  State<BoardWrite> createState() => _BoardWriteState();
}

class _BoardWriteState extends State<BoardWrite> {
  XFile? _image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
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
              ),
              SizedBox(
                height: 20.0,
              ),
              CustomTextField_Content(
                label: '내용',
              ),
              SizedBox(
                height: 20.0,
              ),
              _buildPhotoArea(),
              SizedBox(height: 20.0),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => FreeBoardScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 150.0, vertical: 10.0),
                    textStyle:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                  ),
                  child: Text('작성하기')),
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
                )),
            width: 60,
            height: 60,
            color: Colors.grey[200],
          );
  }
}
