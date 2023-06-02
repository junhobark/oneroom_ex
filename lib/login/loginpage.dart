import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:oneroom_ex/login/uid_provider.dart';
import 'package:provider/provider.dart';

class SampleScreen extends StatefulWidget {
  const SampleScreen({Key? key}) : super(key: key);

  @override
  State<SampleScreen> createState() => _SampleScreenState();
}

// StatefulWidget 으로 만들고 현재 로그인한 플랫폼을 저장할 변수를 선언
class _SampleScreenState extends State<SampleScreen> {
  final _authentication = FirebaseAuth.instance;
  bool isSignupScreen = true;
  String userName = '';
  String userEmail = '';
  String userPassword = '';
  String userNickname = '';
  String location = '';

  Future<void> sendPostRequest(uuid, location, username, usernickname) async {
    var url = Uri.parse('http://10.0.2.2:8080/user/sign');
    Map data = {
      "id": uuid,
      "valid": null,
      "location": location,
      "name": username,
      "nickName": usernickname,
    };
    var body = json.encode(data);
    try {
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);
      if (response.statusCode == 200) {
        Provider.of<UIDProvider>(context, listen: false).setAccessToken(uuid);
        print('POST 요청 성공!');
        print('POST 요청 상태 코드: ${response.statusCode}');
        print('오류 응답 본문: ${response.body}');
      } else {
        // POST 요청이 실패한 경우
        print('POST 요청 실패. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      // 네트워크 오류 등 예외 처리
      print('POST 요청 오류: $e');
    }
  }

  //path = 이미지 경로, VoidCallback 으로 로그인 처리 함수를 받음
  Widget _loginButton() {
    return Card(
      //Card = 버튼에 그림자 효과
      elevation: 5.0,
      //그림자의 높이
      shape: const RoundedRectangleBorder(),
      //버튼모양
      clipBehavior: Clip.antiAlias,
      //클리핑 방법 : 경계가 부드럽게
      color: Colors.transparent,
      //InkWell위젯 사용시 버튼 아래 흰색 제거
      child: Ink.image(
        //ripple효과 주기 위해 자식으로 Ink 위젯 사용
        image: AssetImage('asset/img/logo/naver_logo.png'),
        width: 250,
        height: 70,
        child: InkWell(
          onTap: () async {
            final NaverLoginResult result = await FlutterNaverLogin.logIn();
            if (result.status == NaverLoginStatus.loggedIn) {
              userName = result.account.name;
              userEmail = result.account.email;
              userNickname = result.account.nickname;
              try {
                final newUser1 =
                    await _authentication.signInWithEmailAndPassword(
                  email: userEmail,
                  password: 'password',
                );
                String uid = newUser1.user!.uid;
                print('UID: ${uid}');
                sendPostRequest(uid, location, result.account.name,
                    result.account.nickname);
              } catch (e) {
                try {
                  final newUser =
                      await _authentication.createUserWithEmailAndPassword(
                    email: userEmail,
                    password: 'password',
                  );
                  String uid = newUser.user!.uid;
                  print('UID: ${uid}');
                  sendPostRequest(uid, location, result.account.name,
                      result.account.nickname);
                  await FirebaseFirestore.instance
                      .collection('user')
                      .doc(newUser.user!.uid)
                      .set({
                    'nickName': result.account.nickname,
                    'userName': userName,
                    'email': userEmail,
                  });
                } catch (e) {
                  print(e);
                }
              }
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'asset/img/logo/login_logo.png',
                  width: 300,
                ),
                SizedBox(height: 16),
                _loginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
