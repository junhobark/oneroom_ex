import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:oneroom_ex/common/colors.dart';
import 'package:oneroom_ex/common/default_layout.dart';
import 'package:oneroom_ex/community/GENERAL/general_board_postId.dart';

class GeneralBoardSearch extends StatefulWidget {
  const GeneralBoardSearch({Key? key}) : super(key: key);

  @override
  _GeneralBoardSearchState createState() => _GeneralBoardSearchState();
}

class _GeneralBoardSearchState extends State<GeneralBoardSearch> {
  final baseBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: INPUT_BORDER_COLOR,
      width: 1.0,
    ),
  );

  List<dynamic> searchData = [];
  String searchKeyword = '';
  final FocusNode _focusNode = FocusNode();

  Future<void> fetchData() async {
    if (searchKeyword.trim().replaceAll(' ', '').length < 2) {
      setState(() {
        searchData = [];
      });
      return;
    }

    final url = Uri.parse(
        'http://10.0.2.2:8080/community/GENERAL/search?word=$searchKeyword');
    final headers = {'Accept-Charset': 'UTF-8'}; // UTF-8 인코딩 설정
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = utf8.decode(response.bodyBytes); // UTF-8로 디코딩

      setState(() {
        searchData = json.decode(data);
      });
    } else {
      print('Request failed with status: ${response.statusCode}');
      setState(() {
        searchData = [];
      });
    }
  }

  void search() {
    if (searchKeyword.trim().replaceAll(' ', '').length >= 2) {
      fetchData();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Search',
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            // 검색창 외부를 탭하면 키보드 숨기기
            _focusNode.unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  cursorColor: PRIMARY_COLOR,
                  autofocus: true,
                  focusNode: _focusNode,
                  onChanged: (String value) {
                    setState(() {
                      searchKeyword = value;
                    });
                  },
                  onFieldSubmitted: (String value) {
                    setState(() {
                      searchKeyword = value;
                    });
                    search();
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: '자유게시판의 글을 검색해보세요',
                    hintStyle: TextStyle(
                      color: BODY_TEXT_COLOR,
                      fontSize: 16.0,
                    ),
                    fillColor: INPUT_BG_COLOR,
                    filled: true,
                    border: baseBorder,
                    focusedBorder: baseBorder.copyWith(
                      borderSide: baseBorder.borderSide.copyWith(
                        color: PRIMARY_COLOR,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (searchData.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: searchData.length,
                      itemBuilder: (context, index) {
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
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      GeneralBoardPostId(
                                          searchData[index]['id']), //id값을 넘김
                                ),
                              ).then((value) {
                                setState(() {
                                  fetchData();
                                });
                              });
                            },
                            title: Text(
                              '${searchData[index]['title'].length > 15 ? '${searchData[index]['title'].substring(0, 15)} ⋯' : searchData[index]['title']}',
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
                                  '${searchData[index]['body'].length > 15 ? '${searchData[index]['body'].substring(0, 15)} ⋯' : searchData[index]['body']}',
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
                                          '${searchData[index]['likes']}',
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
                                          '${searchData[index]['commentCount']}',
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
                                      DateFormat('HH:mm').format(DateTime.parse(
                                          searchData[index]['createdAt'])),
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
                                      '${searchData[index]['authorName'].replaceFirst('경남 진주시 ', '')}***',
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
        ),
      ),
    );
  }
}
