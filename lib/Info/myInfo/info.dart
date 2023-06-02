import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:oneroom_ex/Info/info_certification.dart';
import 'package:oneroom_ex/Info/info_written_board.dart';
import 'package:oneroom_ex/Info/info_written_comment.dart';
import 'package:oneroom_ex/Info/info_review/info_written_review.dart';
import 'package:oneroom_ex/common/colors.dart';
import 'package:provider/provider.dart';
import '../../login/uid_provider.dart';
import '../_admin/adminlist.dart';

class informationScreen extends StatefulWidget {
  const informationScreen({Key? key}) : super(key: key);

  @override
  State<informationScreen> createState() => _informationScreen();
}

class _informationScreen extends State<informationScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  var users;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
      }
    } catch (e) {
      print(e);
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
          _signOut();
          _authentication.signOut();
          Navigator.pop(context);
        },
        child: Text('로그아웃'),
      ),
    );
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
                            TextSpan(
                              text: '내 거주지',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (Provider.of<UIDProvider>(context, listen: false)
                                    .valid ==
                                "UNCERTIFIED")
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
                                "ONGOING")
                              TextSpan(
                                text: '\n인증중입니다(기다려주세요)',
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w700,
                                  color: BODY_TEXT_COLOR,
                                ),
                              ),
                            if (Provider.of<UIDProvider>(context, listen: false)
                                    .valid ==
                                "CERTIFIED")
                              TextSpan(
                                text:
                                    '\n${Provider.of<UIDProvider>(context).location}',
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
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
                  child: Text('거주지 인증'),
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
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => Adminlist(),
                          ),
                        );
                      },
                      child: Text(
                        'go amin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
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
