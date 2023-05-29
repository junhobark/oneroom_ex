import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oneroom_ex/common/colors.dart';
import 'package:kpostal/kpostal.dart';
import 'package:provider/provider.dart';
import '../common/default_layout.dart';
import '../login/uid.dart';
import '../map/mapScreen.dart';
import 'package:http/http.dart' as http;

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
  final InputController = TextEditingController();
  String roadaddress = '';
  var model = null;
  String id = '';
  Future<void> sendPostRequest() async {
    var client = new http.Client();
    var url = Uri.parse('http://10.0.2.2:8080/user/authorization/write');
    http.MultipartRequest request = http.MultipartRequest('POST', url);
    Map<String, dynamic> jsonData = {
      'memberId': Provider.of<UIDProvider>(context, listen: false).uid,
      'location': InputController.text,
    };
    request.fields['LocRequestForm'] = json.encode(jsonData);
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));

    try {
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      print(responseString);
      if (response.statusCode == 200) {
        // POST 요청이 성공한 경우
        print('POST 요청 성공!');
        print('POST 요청 상태 코드: ${response.statusCode}');
      } else {
        // POST 요청이 실패한 경우
        print('POST 요청 실패. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      // 네트워크 오류 등 예외 처리
      print('POST 요청 오류: $e');
    } finally {
      client.close();
    }
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 260,
                    height: 50,
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: '주소를 입력해주세요',
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                          borderSide: BorderSide(width: 2, color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                          borderSide: BorderSide(width: 2, color: Colors.grey),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                      ),
                      controller: InputController,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.search),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      _addressAPI();
                    },
                  )
                ],
              ),
              _buildPhotoArea(),
              _buildButton(),
              ElevatedButton(
                  onPressed: (model != null && _image != null)
                      ? () {
                          showMyDialog();
                        }
                      : null,
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

  _addressAPI() async {
    model = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KpostalView(
          useLocalServer: false,
          localPort: 8080,
          kakaoKey: kakaoMapKey,
          callback: (Kpostal result) {
            setState(() {
              this.roadaddress = result.roadAddress;
            });
          },
        ),
      ),
    );
    if (model != null) {
      InputController.text = '${roadaddress}';
    }
  }

  void showMyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            '제출하실건가요?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Container(
                child: TextButton(
                  child: Text(
                    '네',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  onPressed: () {
                    print(
                        "${Provider.of<UIDProvider>(context, listen: false).uid},${InputController.text},${_image}");

                    sendPostRequest();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                child: TextButton(
                  child: Text(
                    '아니요',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ])
          ],
        );
      },
    );
  }
}
