import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oneroom_ex/common/colors.dart';
import '../common/default_layout.dart';
import 'myInfo/info_checking.dart';

void main() {
  runApp(const CertificationScreen());
}

class CertificationScreen extends StatefulWidget {
  const CertificationScreen({Key? key}) : super(key: key);

  @override
  State<CertificationScreen> createState() => _CertificationScreenState();
}

class _CertificationScreenState extends State<CertificationScreen> {
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '거주지 인증',
      child: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '계약서를 첨부해야만 리뷰등록이 가능합니다.'
                '\n계약서는 거주지 인증 용도로만 사용됩니다'
                '\n인증까지 최대 3일까지 시간이 소요될 수 있습니다.',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: BODY_TEXT_COLOR,
                ),
              ),
              _buildPhotoArea(),
              _buildButton(),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            informationCheckingScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 135.0, vertical: 15.0),
                    textStyle:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                  ),
                  child: Text('제출하기')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
            width: 330,
            height: 330,
            child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄워주는 코드
          )
        : Container(
            width: 330,
            height: 330,
            color: INPUT_BORDER_COLOR,
          );
  }

  Widget _buildButton() {
    return Row(
      children: [
        SizedBox(width: 40),
        IconButton(
          icon: Icon(
            Icons.camera_alt_outlined,
            size: 50,
          ),
          onPressed: () {
            getImage(ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
          },
        ),
        SizedBox(
          width: 50,
        ),
        IconButton(
          icon: Icon(
            Icons.photo_library_outlined,
            size: 50,
          ),
          onPressed: () {
            getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
        ),
      ],
    );
  }
}
