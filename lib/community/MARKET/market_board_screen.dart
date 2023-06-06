import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:oneroom_ex/common/colors.dart';
import 'package:oneroom_ex/community/MARKET/market_board_postId.dart';
import 'package:oneroom_ex/community/MARKET/market_board_search.dart';
import 'package:oneroom_ex/community/MARKET/market_board_write.dart';
import 'package:provider/provider.dart';
import '../../login/uid_provider.dart';

class MarketBoardScreen extends StatefulWidget {
  @override
  _MarketBoardScreenState createState() => _MarketBoardScreenState();
}

class _MarketBoardScreenState extends State<MarketBoardScreen> {
  dynamic Market_PopularPost;
  List<dynamic> Market_NormalPost = [];

  Future<void> fetchData() async {
    final response =
    await http.get(Uri.parse('http://10.0.2.2:8080/community/MARKET'));

    if (response.statusCode == 200) {
      final data = utf8.decode(response.bodyBytes); // UTF-8로 디코딩

      setState(() {
        final decodedData = json.decode(data);
        Market_PopularPost = decodedData['popular'];
        Market_NormalPost = decodedData['normal'];
      });
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          '장터게시판',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: Provider.of<UIDProvider>(context, listen: false).valid !=
                "CERTIFIED"
                ? () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                      '거주지 인증을 먼저 완료해주세요!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: TextButton(
                              child: Text(
                                '확인',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            }
                : () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (BuildContext context) => MarketBoardSearch(),
                ),
              ) //.then~ //실행 후 게시판을 최신화
                  .then(
                    (value) {
                  setState(
                        () {
                      fetchData();
                    },
                  );
                },
              );
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: Provider.of<UIDProvider>(context, listen: false).valid !=
                "CERTIFIED"
                ? () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                      '거주지 인증을 먼저 완료해주세요!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: TextButton(
                              child: Text(
                                '확인',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            }
                : () async {
              final newPost = await Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (BuildContext context) => MarketBoardWrite(),
                ),
              )
                  .then(
                    (value) {
                  setState(
                        () {
                      fetchData();
                    },
                  );
                },
              );

              if (newPost != null) {
                setState(
                      () {
                        Market_NormalPost.add(newPost);
                  },
                );
              }
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            //인기글
            if (Market_PopularPost != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 16.0, 10.0, 8.0),
                child: Container(
                  padding: EdgeInsets.only(top: 5.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: ListTile(
                    onTap: Provider.of<UIDProvider>(context, listen: false)
                        .valid !=
                        "CERTIFIED"
                        ? () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                              '거주지 인증을 먼저 완료해주세요!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    child: TextButton(
                                      child: Text(
                                        '확인',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    }
                        : () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              MarketBoardPostId(
                                  Market_PopularPost['id']), //id값을 넘김
                        ),
                      )
                          .then(
                            (value) {
                          setState(
                                () {
                              fetchData();
                            },
                          );
                        },
                      );
                    },
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '인기     ',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18.0,
                              color: Colors.red, // '인기' 텍스트의 색상을 빨간색으로 지정
                            ),
                          ),
                          TextSpan(
                            text:
                            '${Market_PopularPost['title'].length > 15 ? '${Market_PopularPost['title'].substring(0, 15)} ⋯' : Market_PopularPost['title']}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              DateFormat('HH:mm').format(DateTime.parse(
                                  Market_PopularPost['createdAt'])),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 230.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.thumb_up_alt_outlined,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  '${Market_PopularPost['likes']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Row(
                              children: [
                                Icon(
                                  Icons.mode_comment_outlined,
                                  size: 15,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  '${Market_PopularPost['commentCount']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(width: 5),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            //일반 게시판 리스트
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Market_NormalPost.length,
                itemBuilder: (context, index) {
                  final MNP = Market_NormalPost[index];
                  return Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.0,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    //일반글
                    child: ListTile(
                      onTap: Provider.of<UIDProvider>(context, listen: false)
                          .valid !=
                          "CERTIFIED"
                          ? () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(
                                '거주지 인증을 먼저 완료해주세요!',
                                style: TextStyle(
                                  fontSize: 22,
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
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      }
                          : () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                MarketBoardPostId(MNP['id']), //id값을 넘김
                          ),
                        )
                            .then(
                              (value) {
                            setState(
                                  () {
                                fetchData();
                              },
                            );
                          },
                        );
                      },
                      title: Text(
                        '${MNP['title'].length > 15 ? '${MNP['title'].substring(0, 15)} ⋯' : MNP['title']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 1),
                          Text(
                            '${MNP['body'].length > 15 ? '${MNP['body'].substring(0, 15)} ⋯' : MNP['body']}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: BODY_TEXT_COLOR,
                            ),
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.thumb_up_alt_outlined,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    '${MNP['likes']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.mode_comment_outlined,
                                    size: 15,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    '${MNP['commentCount']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '|',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                ],
                              ),
                              Text(
                                DateFormat('HH:mm')
                                    .format(DateTime.parse(MNP['createdAt'])),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                '|',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                '${MNP['authorName'].replaceFirst('경남 진주시 ', '')}***',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
