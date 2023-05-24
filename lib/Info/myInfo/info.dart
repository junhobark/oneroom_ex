import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oneroom_ex/Info/info_certification.dart';
import 'package:oneroom_ex/Info/info_written_board.dart';
import 'package:oneroom_ex/Info/info_written_comment.dart';
import 'package:oneroom_ex/Info/info_written_review.dart';
import 'package:oneroom_ex/common/colors.dart';
import '../../login/loginpage.dart';

class informationScreen extends StatefulWidget {
  const informationScreen({Key? key}) : super(key: key);

  @override
  State<informationScreen> createState() => _informationScreen();
}

class _informationScreen extends State<informationScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

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
          _authentication.signOut();
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return SampleScreen();
              },
            ),
          );
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
                    'GNU18@naver.com',
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
                            TextSpan(
                              text: '\n거주지를 인증해주세요',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                                color: PRIMARY_COLOR,
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            CertificationScreen(),
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
              SizedBox(height: 4),
              Text(
                '문의메일: gnuroom9@naver.com',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
