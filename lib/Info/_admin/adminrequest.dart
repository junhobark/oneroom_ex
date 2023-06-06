import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:oneroom_ex/Info/_admin/requestclass.dart';
import 'package:provider/provider.dart';
import '../../common/colors.dart';
import '../../common/default_layout.dart';
import '../../login/uid_provider.dart';
import '../../login/users.dart';

class Adminrequest extends StatefulWidget {
  final int id;
  Adminrequest(this.id);

  @override
  State<Adminrequest> createState() => _AdminrequestState();
}

class _AdminrequestState extends State<Adminrequest> {
  Future<String> userfetchData(uid) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8080/user/${uid}'));
    if (response.statusCode == 200) {
      print('응답했다');
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

  Future<Admin> adminfetchData(id) async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8080/admin/locRequest/${id}'));
    if (response.statusCode == 200) {
      final datadetail = jsonDecode(utf8.decode(response.bodyBytes));

      return Admin.fromJson(datadetail);
    } else {
      print('An error occurred: e');
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<String> postadminfetchData(id) async {
    final response = await http
        .post(Uri.parse('http://10.0.2.2:8080/admin/locRequest/${id}'));
    if (response.statusCode == 200) {
      print('요청성공!,인증이 성공하였습니다');
      String result = '성공';
      return result;
    } else {
      print('${response.statusCode}');
      String result = '';
      return result;
    }
  }

  Future<String> deleteadminfetchData(id) async {
    final response = await http
        .delete(Uri.parse('http://10.0.2.2:8080/admin/locRequest/${id}'));
    if (response.statusCode == 200) {
      print('요청성공!,삭제되었습니다');
      String result = '성공';
      return result;
    } else {
      print('${response.statusCode}');
      String result = '';
      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '거주지 인증요청',
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: FutureBuilder<Admin>(
            future: adminfetchData(widget.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var admin = snapshot.data;
                return Flex(
                  direction: Axis.vertical,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 233, 244, 247),
                        border: Border.all(
                          color: Colors.black,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '거주지 인증요청',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                              '${DateFormat("yy/MM/dd HH:mm").format(admin!.createdAt)}'),
                          SizedBox(
                            height: 10,
                          ),
                          Text('${admin.name}'),
                          Text('${admin.nickname}'),
                          Text('${admin.location}'),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: EdgeInsets.zero,
                            width: 350,
                            height: 350,
                            child: admin.buildImageWidget(admin.image),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  // ignore: unused_local_variable
                                  String result =
                                      await postadminfetchData(admin.id);
                                  // ignore: unused_local_variable
                                  String data = await userfetchData(
                                      Provider.of<UIDProvider>(context,
                                              listen: false)
                                          .uid);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  '승인',
                                  style: TextStyle(fontSize: 14),
                                ),
                                style: TextButton.styleFrom(
                                    fixedSize: Size(165, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    side: BorderSide(
                                      width: 1,
                                      color: PRIMARY_COLOR,
                                    ),
                                    backgroundColor: PRIMARY_COLOR,
                                    foregroundColor: Colors.white),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                onPressed: () async {
                                  // ignore: unused_local_variable
                                  String result =
                                      await deleteadminfetchData(admin.id);
                                  // ignore: unused_local_variable
                                  String data = await userfetchData(
                                      Provider.of<UIDProvider>(context,
                                              listen: false)
                                          .uid);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  '거절',
                                  style: TextStyle(fontSize: 14),
                                ),
                                style: TextButton.styleFrom(
                                    fixedSize: Size(165, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    side: BorderSide(
                                      width: 1,
                                      color: PRIMARY_COLOR,
                                    ),
                                    backgroundColor: PRIMARY_COLOR,
                                    foregroundColor: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return SnackBar(
                  content: Text('error 에러!!'),
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
