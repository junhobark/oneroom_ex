import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:oneroom_ex/common/default_layout.dart';
import 'package:oneroom_ex/community/GENERAL/general_board_screen.dart';
import 'package:oneroom_ex/community/TIPS/tipsboard.dart';
import 'MARKET/marketboard.dart';
import 'package:http/http.dart' as http;

class communityScreen extends StatefulWidget {
  const communityScreen({Key? key}) : super(key: key);

  @override
  State<communityScreen> createState() => _communityScreenState();
}

class _communityScreenState extends State<communityScreen> {
  List<dynamic> generalData = [];
  List<dynamic> tipsData = [];
  List<dynamic> marketData = [];


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var url = Uri.parse('http://10.0.2.2:8080/community');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes)); //한글 안깨지게
        setState(() {
          generalData = data['GENERAL'];
          tipsData = data['TIPS'];
          marketData = data['MARKET'];
        });
      } else {
        print('Failed to fetch data. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'asset/img/logo/small_logo.png',
                height: 100,
              ),
              //자유게시판
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => GeneralBoardScreen(),
                              ),
                            ).then((value) {
                              setState(() {
                                fetchData();
                              });
                            });
                          },
                          icon: Icon(Icons.chat_bubble_outline),
                          label: Text('자유게시판                                 더보기>'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //자유게시판 리스트
                  Column(
                    children: [
                      for (var item in generalData)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item['title']}',
                                style: TextStyle(color: Colors.black, fontSize: 18.0),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.thumb_up_alt_outlined,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    '${item['likes']}',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  SizedBox(width: 20),
                                  Icon(
                                    Icons.mode_comment_outlined,
                                    size: 15,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    '${item['commentCount']}',
                                    style: TextStyle(color: Colors.blue),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              //자취 꿀팁
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => TipsBoardScreen(),
                              ),
                            ).then((value) {
                              setState(() {
                                fetchData();
                              });
                            });
                          },
                          icon: Icon(Icons.chat_bubble_outline),
                          label: Text('자취 꿀팁                                   더보기>'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //자취 꿀팁 리스트
                  Column(
                    children: [
                      for (var item in tipsData)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item['title']}',
                                style: TextStyle(color: Colors.black, fontSize: 18.0),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.thumb_up_alt_outlined,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    '${item['likes']}',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  SizedBox(width: 20),
                                  Icon(
                                    Icons.mode_comment_outlined,
                                    size: 15,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    '${item['commentCount']}',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              //장터 게시판
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => MarketBoardScreen(),
                              ),
                            ).then((value) {
                              setState(() {
                                fetchData();
                              });
                            });
                          },
                          icon: Icon(Icons.chat_bubble_outline),
                          label: Text('장터게시판                                 더보기>'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //장터게시판 리스트
                  Column(
                    children: [
                      for (var item in marketData)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item['title']}',
                                style: TextStyle(color: Colors.black, fontSize: 18.0),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.thumb_up_alt_outlined,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    '${item['likes']}',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  SizedBox(width: 20),
                                  Icon(
                                    Icons.mode_comment_outlined,
                                    size: 15,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    '${item['commentCount']}',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
