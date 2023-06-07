import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:oneroom_ex/common/colors.dart';
import 'package:oneroom_ex/community/GENERAL/general_board_postId.dart';
import 'package:oneroom_ex/community/GENERAL/general_board_search.dart';
import 'package:oneroom_ex/community/GENERAL/general_board_write.dart';
import 'package:provider/provider.dart';

import '../../login/uid_provider.dart';

class GeneralBoardScreen extends StatefulWidget {
  @override
  _GeneralBoardScreenState createState() => _GeneralBoardScreenState();
}

class _GeneralBoardScreenState extends State<GeneralBoardScreen> {
  dynamic General_PopularPost;
  List<dynamic> General_NormalPost = [];

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8080/community/GENERAL'));

    if (response.statusCode == 200) {
      final data = utf8.decode(response.bodyBytes); // UTF-8로 디코딩

      setState(() {
        final decodedData = json.decode(data);
        General_PopularPost = decodedData['popular'];
        General_NormalPost = decodedData['normal'];
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
          '자유게시판',
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
                        builder: (BuildContext context) => GeneralBoardSearch(),
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
                        builder: (BuildContext context) => GeneralBoardWrite(),
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
                      // 새로운 글 데이터로 UI를 업데이트합니다
                      setState(
                        () {
                          // 새로운 글을 General_NormalPost 목록에 추가합니다
                          General_NormalPost.add(newPost);
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
            if (General_PopularPost != null)
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

                  //인기글
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
                                    GeneralBoardPostId(
                                        General_PopularPost['id']), //id값을 넘김
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
                                '${General_PopularPost['title'].length > 15 ? '${General_PopularPost['title'].substring(0, 15)} ⋯' : General_PopularPost['title']}',
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
                                  General_PopularPost['createdAt'])),
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
                                  '${General_PopularPost['likes']}',
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
                                  '${General_PopularPost['commentCount']}',
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
                itemCount: General_NormalPost.length,
                itemBuilder: (context, index) {
                  final GNP = General_NormalPost[index];
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
                                      GeneralBoardPostId(GNP['id']), //id값을 넘김
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
                        '${GNP['title'].length > 15 ? '${GNP['title'].substring(0, 15)} ⋯' : GNP['title']}',
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
                            '${GNP['body'].length > 15 ? '${GNP['body'].substring(0, 15)} ⋯' : GNP['body']}',
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
                                    '${GNP['likes']}',
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
                                    '${GNP['commentCount']}',
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
                                    .format(DateTime.parse(GNP['createdAt'])),
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
                                '${GNP['authorName'].replaceFirst('경남 진주시 ', '')}***',
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
