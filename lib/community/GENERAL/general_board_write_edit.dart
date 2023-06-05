import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oneroom_ex/common/colors.dart';

class GeneralBoardWriteEdit extends StatefulWidget {
  final int id;

  const GeneralBoardWriteEdit({Key? key, required this.id}) : super(key: key);

  @override
  State<GeneralBoardWriteEdit> createState() => _GeneralBoardWriteEditState();
}

class _GeneralBoardWriteEditState extends State<GeneralBoardWriteEdit> {
  //get
  Map<String, dynamic>? postData;
  List<Map<String, dynamic>> images = [];
  List<Map<String, dynamic>> selectedImages = [];
  List<PickedFile> pickedFiles = [];
  final ImagePicker picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  //get
  Future<void> fetchData() async {
    var url =
        Uri.parse('http://10.0.2.2:8080/community/GENERAL/${widget.id}/modify');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        postData = responseData;
        images = List<Map<String, dynamic>>.from(responseData['images']);

        selectedImages = List<Map<String, dynamic>>.from(images);

        // 수정된 데이터로 초기값 설정
        titleController.text = postData?['title'] ?? "";
        bodyController.text = postData?['body'] ?? "";
      });
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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

  void _generalBoardWriteEditState() async {
    final dio = Dio();
    var url = 'http://10.0.2.2:8080/community/GENERAL/${widget.id}/modify';

    Map<String, dynamic> postDto = {
      'memberId': 'abc',
      'title': titleController.text,
      'body': bodyController.text,
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

    if (selectedImages.isNotEmpty) {
      for (var image in selectedImages) {
        print('Selected Image: $image');
        var contentType = image['headers']['Content-Type'][0];
        var body = image['body'];
        var decodedImage = base64Decode(body);

        formData.files.add(
          MapEntry(
            'files', // 서버에서 사용할 파일 필드 이름
            MultipartFile.fromBytes(
              decodedImage,
              filename: 'image.jpg',
              contentType: MediaType.parse(contentType),
            ),
          ),
        );
      }
    }

    if (titleController.text.isEmpty || bodyController.text.isEmpty) {
      // 제목 또는 내용이 비어있으면, 수정하기 버튼을 눌러도 동작하지 않도록 합니다.
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

        // 이전 화면인 GeneralBoardScreen으로 돌아가며 새로운 글 데이터를 전달합니다
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
    void _handleImageDelete(int index) {
      setState(() {
        if (index < images.length) {
          selectedImages.remove(images[index]); // 선택된 이미지 리스트에서 제거
        }

        if (images.isNotEmpty) {
          images.removeAt(index); // 이미지 삭제
        }
      });
    }

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
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  label: '제목',
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: titleController, // 컨트롤러 설정
                ),
                CustomTextFieldContent(
                  label: '내용',
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: bodyController, // 컨트롤러 설정
                ),

                //DB사진 받아올때
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPhotoArea(), //사진을 넣었을때 보이게 함
                      //for (var image in images)
                      for (var image in images)
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(3),
                              width: 76,
                              height: 76,
                              child: Image.memory(
                                base64Decode(image['body']),
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
                                  _handleImageDelete(images.indexOf(image));
                                },
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: (titleController.text.isEmpty ||
                          bodyController.text.isEmpty)
                      ? null
                      : _generalBoardWriteEditState,
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
                  child: Text('수정하기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //글쓰기에서 사진을 넣었을때 보이게 함
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
  final TextEditingController? controller; // 컨트롤러 추가

  const CustomTextField({
    required this.label,
    required this.onChanged,
    this.controller, // 컨트롤러 추가
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
          autofocus: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[200],
          ),
          onChanged: onChanged,
          controller: controller, // 컨트롤러 설정
        ),
      ],
    );
  }
}

class CustomTextFieldContent extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller; // 컨트롤러 추가

  const CustomTextFieldContent({
    required this.label,
    required this.onChanged,
    this.controller, // 컨트롤러 추가
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
          height: 120,
          color: Colors.grey[200],
          child: TextField(
            maxLines: null,
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[200],
            ),
            onChanged: onChanged,
            controller: controller, // 컨트롤러 설정
          ),
        ),
      ],
    );
  }
}
