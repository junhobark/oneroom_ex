import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oneroom_ex/common/colors.dart';
import 'package:kpostal/kpostal.dart';
import 'package:provider/provider.dart';
import '../../common/default_layout.dart';
import '../../login/uid_provider.dart';
import '../../login/users.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

import '../../map/mapScreen.dart';

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
  Future<String> sendPostRequest(uid, location) async {
    final dio = Dio();
    var url = 'http://10.0.2.2:8080/user/authorization/write';

    Map<String, dynamic> locRequestForm = {
      'memberId': uid,
      'location': location,
    };

    FormData formData = FormData.fromMap({
      'locRequestForm': MultipartFile.fromString(
        jsonEncode(locRequestForm),
        contentType: MediaType('application', 'json'),
      ),
      'file':
          await MultipartFile.fromFile(_image!.path, filename: _image!.name),
    });

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
        String data = '성공';
        return data;
      } else {
        // POST 요청이 실패한 경우
        print(' ${_image!.name}');
        print('POST 요청 실패. 상태 코드: ${response.statusCode}');
        String data = '실패';
        return data;
      }
    } catch (e) {
      // 네트워크 오류 등 예외 처리
      print('POST 요청 오류: $e');
      print(' ${_image!.name}');
      String data = '실패';
      return data;
    }
  }

  Future<String> userfetchData(uid) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8080/user/${uid}'));
    if (response.statusCode == 200) {
      print('응답했다3');
      print(utf8.decode(response.bodyBytes));
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      print(Users.fromJson(data));
      var _data = Users.fromJson(data);
      Provider.of<UIDProvider>(context, listen: false)
          .setdbToken(_data.nickName, _data.location, _data.valid);
      return _data.valid;
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Error: ${response.statusCode}');
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
                '           계약서 또는 지로공과금 청구서를 첨부하세요.'
          '        \n               (주소 및 이름을 포함해서 제출해주세요)'
                '\n        임대차 계약서 첨부시 본인의 정보만 첨부하세요.',

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
                  onPressed: () async {
                    print(
                        "${Provider.of<UIDProvider>(context, listen: false).uid},${InputController.text},${_image}");

                    String uid =
                        Provider.of<UIDProvider>(context, listen: false).uid;
                    String location = InputController.text;
                    CircularProgressIndicator();
                    // ignore: unused_local_variable
                    String data1 = await sendPostRequest(uid, location);
                    // ignore: unused_local_variable
                    String data2 = await userfetchData(uid);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    update();
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

  void update() {
    setState(() {});
  }
}
