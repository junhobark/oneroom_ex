import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oneroom_ex/map/review_detail/review1_provider.dart';
import 'package:oneroom_ex/map/review_detail/review2_provider.dart';
import 'package:provider/provider.dart';
import '../common/colors.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import '../common/root_tab.dart';
import '../login/uid_provider.dart';
import '../login/users.dart';
import 'locationProvider.dart';

class ReviewScreen2 extends StatefulWidget {
  final String roadaddress;
  final double review_lat;
  final double review_lng;
  final double review_area;
  final double review_lessor;
  final double review_noise;
  final double review_quality;
  ReviewScreen2(
      this.roadaddress,
      this.review_lat,
      this.review_lng,
      this.review_area,
      this.review_lessor,
      this.review_noise,
      this.review_quality);
  @override
  State<ReviewScreen2> createState() => _ReviewScreen2State();
}

class _ReviewScreen2State extends State<ReviewScreen2> {
  final addmyController = TextEditingController();
  final weaController = TextEditingController();
  final etcController = TextEditingController();
  String advantage = '';
  String weakness = '';
  String etc = '';
  final ImagePicker picker = ImagePicker();
  late final Function onMapCreated;
  List<PickedFile> pickedFiles = [];
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

  Future<String> sendPostRequest() async {
    final dio = Dio();
    var url = 'http://10.0.2.2:8080/map/${widget.roadaddress}/review/write';

    Map<String, dynamic> createReviewDto = {
      'memberId': Provider.of<UIDProvider>(context, listen: false).uid,
      'location': widget.roadaddress,
      'grade': {
        'lessor': widget.review_lessor,
        'quality': widget.review_quality,
        'area': widget.review_area,
        'noise': widget.review_noise
      },
      'body': {
        'advantage':
            Provider.of<REVIEW2Provider>(context, listen: false).advantage,
        'weakness':
            Provider.of<REVIEW2Provider>(context, listen: false).weakness,
        'etc': Provider.of<REVIEW2Provider>(context, listen: false).etc,
      },
      'posx': widget.review_lat,
      'posy': widget.review_lng,
    };

    FormData formData = FormData.fromMap({
      'createReviewDto': MultipartFile.fromString(
        jsonEncode(createReviewDto),
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

    try {
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      if (response.statusCode == 200) {
        print('POST 요청 성공!');
        print('POST 요청 상태 코드: ${response.statusCode}');
        String data = '성공';

        return data;
      } else {
        print('POST 요청 실패. 상태 코드: ${response.statusCode}');
        String data = '실패';

        return data;
      }
    } catch (e) {
      print('POST 요청 오류: $e');
      String data = '실패';

      return data;
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            title: Text(
              '리뷰 작성(2/2)',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            foregroundColor: Colors.black,
            leading: IconButton(
              onPressed: () {
                Provider.of<REVIEW2Provider>(context, listen: false)
                    .setall(advantage = '', weakness = '', etc = '');
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
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
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('장점',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(250),
                        ],
                        onChanged: _checkTextLength1,
                        controller: addmyController,
                        style: TextStyle(decorationThickness: 0),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                      width: 350,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('단점',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(250),
                        ],
                        onChanged: _checkTextLength2,
                        controller: weaController,
                        style: TextStyle(decorationThickness: 0),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                      width: 350,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('기타',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(250),
                        ],
                        onChanged: _checkTextLength3,
                        controller: etcController,
                        style: TextStyle(decorationThickness: 0),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                      width: 350,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [_buildPhotoArea()])),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: Provider.of<REVIEW2Provider>(context)
                                      .advantage ==
                                  '' ||
                              Provider.of<REVIEW2Provider>(context).weakness ==
                                  '' ||
                              Provider.of<REVIEW2Provider>(context).etc == ''
                          ? null
                          : () async {
                              if (pickedFiles.length > maxImageCount) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          content: Text(
                                            '사진은 최대 5장까지만 가능합니다',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          actions: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                      child: TextButton(
                                                          child: Text(
                                                            '확인',
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          onPressed: () {
                                                            pickedFiles.clear();
                                                            Navigator.pop(
                                                                context);
                                                          }))
                                                ])
                                          ]);
                                    });
                              } else {
                                CircularProgressIndicator();
                                // ignore: unused_local_variable
                                String data = await sendPostRequest();
                                // ignore: unused_local_variable
                                String result = await userfetchData(
                                    Provider.of<UIDProvider>(context,
                                            listen: false)
                                        .uid);
                                print(widget.review_lat);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RootTab(
                                        latitude: widget.review_lat,
                                        longitude: widget.review_lng,
                                        location: widget.roadaddress,
                                      ),
                                    ));
                                Provider.of<REVIEW2Provider>(context,
                                        listen: false)
                                    .setall(advantage = '', weakness = '',
                                        etc = '');
                                Provider.of<REVIEWProvider>(context,
                                        listen: false)
                                    .setall(0, 0, 0, 0);

                              }
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: PRIMARY_COLOR,
                        foregroundColor: Colors.white,
                      ),
                      child: Text("완료", style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void _checkTextLength1(String text) {
    setState(() {
      Provider.of<REVIEW2Provider>(context, listen: false).advantage = text;
    });
  }

  void _checkTextLength2(String text) {
    setState(() {
      Provider.of<REVIEW2Provider>(context, listen: false).weakness = text;
    });
  }

  void _checkTextLength3(String text) {
    setState(() {
      Provider.of<REVIEW2Provider>(context, listen: false).etc = text;
    });
  }

  int maxImageCount = 5; // Maximum number of images allowed

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
