import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:oneroom_ex/Info/_admin/info_certification.dart';
import 'package:oneroom_ex/Info/info_written_board.dart';
import 'package:oneroom_ex/Info/info_written_comment.dart';
import 'package:oneroom_ex/Info/info_review/info_written_review.dart';
import 'package:oneroom_ex/common/colors.dart';
import 'package:provider/provider.dart';
import '../login/uid_provider.dart';
import '../login/users.dart';
import '_admin/adminlist.dart';
import 'package:http/http.dart'as http;
class informationScreen extends StatefulWidget {
  const informationScreen({Key? key}) : super(key: key);

  @override
  State<informationScreen> createState() => _informationScreen();
}

class _informationScreen extends State<informationScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  var users;
  String data = 'false';
  void initState() {
    super.initState();
    adminauthority(Provider.of<UIDProvider>(context,listen:false).uid);
  }

  void logoutFromNaver() async {
    // 네이버 로그아웃 API 호출
    final response = await http.get(Uri.parse('https://nid.naver.com/oauth2.0/token?grant_type=logout&access_token=${Provider.of<UIDProvider>(context, listen: false).access_token}'));

    if (response.statusCode == 200) {
      _signOut();
      // 로그아웃 성공
      print('Naver logout success');

    } else {
      // 로그아웃 실패
      print('Naver logout failed');
    }
  }

  Widget _logoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          textStyle: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
          foregroundColor: Colors.black,
          side: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    content: Text(
                      '로그아웃 하시겠습니까?',
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
                                      '네',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight:
                                              FontWeight
                                                  .w700,
                                          color: Colors
                                              .black),
                                    ),
                                    onPressed: () async{
                                      await _authentication.signOut();
                                      logoutFromNaver();
                                      _signOut();
                                      Navigator.pop(context);
                                      Navigator.pop(
                                          context);



                                    })),
                            Container(
                                child: TextButton(
                                    child: Text(
                                      '아니요',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight:
                                          FontWeight
                                              .w700,
                                          color: Colors
                                              .black),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(
                                          context);
                                    }))
                          ])
                    ]);
              });
        },
        child: Text('로그아웃'),
      ),
    );
  }
  Future<String> adminauthority(String id) async {
    final response =
    await http.get(Uri.parse('http://10.0.2.2:8080/user/${id}/admin'));
    if (response.statusCode == 200) {
      print('응답했다3');
      print(utf8.decode(response.bodyBytes));
      data = utf8.decode(response.bodyBytes);
      return data;
    }
    else{
      String result='fail';
      return result;
    }
  }
  Future<void> deletelocation(String id) async {
    var url = Uri.parse(
        'http://10.0.2.2:8080/user/authorization');
    var requestBody = {"memberId": id};

    try {
      var response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('성공');

      } else {
        print('Failed:${response.statusCode}');
      }
    } catch (error) {
      print(' $error');
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Image.asset(
                    'asset/img/logo/Info_profile.png',
                    width: 100,
                    height: 100,
                  ),
                  Text(
                    '${Provider.of<UIDProvider>(context).nickname}님',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
                thickness: 6.0,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  30.0,
                  10.0,
                  8.0,
                  10.0,
                ),
                child: Row(
                  children: [
                    Container(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: '내 거주지',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (Provider.of<UIDProvider>(context, listen: false)
                                        .valid ==
                                    "UNCERTIFIED" &&
                                Provider.of<UIDProvider>(context, listen: false)
                                        .location ==
                                    null)
                              TextSpan(
                                text: '\n거주지를 인증해주세요',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w700,
                                  color: PRIMARY_COLOR,
                                ),
                              ),
                            if (Provider.of<UIDProvider>(context, listen: false)
                                        .valid ==
                                    "ONGOING" &&
                                Provider.of<UIDProvider>(context, listen: false)
                                        .location ==
                                    null)
                              TextSpan(children: [
                                TextSpan(
                                  text: '\n인증중입니다(기다려주세요)             ',
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w700,
                                    color: BODY_TEXT_COLOR,
                                  ),
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                    content: Text(
                                                      '거주지 인증을 정말 취소하시겠습니까?',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    actions: [
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Container(
                                                                child:
                                                                    TextButton(
                                                                        child:
                                                                            Text(
                                                                          '확인',
                                                                          style: TextStyle(
                                                                              fontSize: 16.0,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.black),
                                                                        ),
                                                                        onPressed:
                                                                            () async{
                                                                          String id = Provider.of<UIDProvider>(context,listen: false).uid;
                                                                              await deletelocation(id);
                                                                          await userfetchData(id);
                                                                          Navigator.pop(
                                                                              context);
                                                                        })),
                                                            Container(
                                                                child:
                                                                    TextButton(
                                                                        child:
                                                                            Text(
                                                                          '취소',
                                                                          style: TextStyle(
                                                                              fontSize: 16.0,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.black),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        })),
                                                          ])
                                                    ]);
                                              });
                                        },
                                        child: Text(
                                          '취소',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w700,
                                            color: BODY_TEXT_COLOR,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            if (Provider.of<UIDProvider>(context, listen: false)
                                        .valid ==
                                    "CERTIFIED" &&
                                Provider.of<UIDProvider>(context, listen: false)
                                        .location !=
                                    null)
                              TextSpan(children: [
                                TextSpan(
                                  text:
                                      '\n${Provider.of<UIDProvider>(context).location}  ',
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                WidgetSpan(
                                  child: Icon(
                                    Icons.check_box,
                                    size: 22.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ]),
                          ],
                        ),
                      ),
                      height: 60,
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 6.0,
              ),
              SizedBox(height: 20),

              //거주지 인증
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: OutlinedButton(
                  onPressed:
                      (Provider.of<UIDProvider>(context, listen: false).valid ==
                              "UNCERTIFIED")
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CertificationScreen(),
                                ),
                              );
                            }
                          : (Provider.of<UIDProvider>(context, listen: false)
                                      .valid ==
                                  "CERTIFIED")
                              ? () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CertificationScreen(),
                                    ),
                                  );
                                }
                              : null,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    side: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                    foregroundColor: Colors.black,
                  ),
                  child:
                      (Provider.of<UIDProvider>(context, listen: false).valid ==
                              "CERTIFIED")
                          ? Text('거주지 인증 갱신')
                          : Text('거주지 인증'),
                ),
              ),
              SizedBox(height: 20),
              //내가 쓴 리뷰
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            WrittenReviewScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    side: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                    foregroundColor: Colors.black,
                  ),
                  child: Text('내가 쓴 리뷰'),
                ),
              ),
              SizedBox(height: 20),
              //내가 쓴 글
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => WrittenBoardScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    side: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                    foregroundColor: Colors.black,
                  ),
                  child: Text('내가 쓴 글'),
                ),
              ),
              SizedBox(height: 20),
              //내가 쓴 댓글
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            WrittenCommentScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    side: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                    foregroundColor: Colors.black,
                  ),
                  child: Text('내가 쓴 댓글'),
                ),
              ),
              SizedBox(height: 20),

              _logoutButton(),

              Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {

                           Navigator.of(context)
                               .push(
                             MaterialPageRoute(
                               builder: (BuildContext context) => Adminlist(),
                             ),
                           )
                               .then((value) {
                             setState(() {});
                           });
                         },

                      child:


        data =='false'? Text(
                        'go amin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ) : Text(''),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signOut() async {
    await FlutterNaverLogin.logOut();
  }
}
