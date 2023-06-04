import 'package:flutter/material.dart';
import 'package:oneroom_ex/common/colors.dart';
import 'package:oneroom_ex/common/default_layout.dart';

import 'marketboard.dart';

class communityScreen extends StatelessWidget {
  const communityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      //title: '커뮤니티',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'asset/img/logo/small_logo.png',
                height: 70,
              ),
              OutlinedButton(
                onPressed: () {},
                child: Text('search'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: BODY_TEXT_COLOR,
                  textStyle:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  side: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 130),
                ),
              ),
              //자유게시판
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.black,
                ))),
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.chat_bubble_outline),
                  label:
                      Text('자유게시판                                       더보기>'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    textStyle:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(height: 20),
              //자취 꿀팁
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.black,
                ))),
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.chat_bubble_outline),
                  label: Text(
                      '자취 꿀팁                                          더보기>'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    textStyle:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.black,
                ))),
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => MarketBoardScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.chat_bubble_outline),
                  label:
                      Text('장터게시판                                       더보기>'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    textStyle:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
