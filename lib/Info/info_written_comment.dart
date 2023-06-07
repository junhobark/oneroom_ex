import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:oneroom_ex/common/colors.dart';
import 'package:oneroom_ex/common/default_layout.dart';
import 'package:oneroom_ex/community/GENERAL/general_board_postId.dart';
import 'package:provider/provider.dart';
import '../login/uid_provider.dart';

class WrittenCommentScreen extends StatefulWidget {
  const WrittenCommentScreen({Key? key}) : super(key: key);

  @override
  State<WrittenCommentScreen> createState() => _WrittenCommentScreenState();
}

class _WrittenCommentScreenState extends State<WrittenCommentScreen> {
  List<dynamic> comments = [];

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    //final url = Uri.parse('http://10.0.2.2:8080/user/abc/comment');
    final url = Uri.parse('http://10.0.2.2:8080/user/${Provider.of<UIDProvider>(context, listen: false).uid}/comment');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = utf8.decode(response.bodyBytes); // UTF-8로 디코딩

      setState(() {
        comments = json.decode(data);
      });
    } else {
      print('Failed to fetch posts. Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
     title:'내가 쓴 댓글',
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
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
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            GeneralBoardPostId(comment['id']), //id값을 넘김
                      ),
                    ).then((value) {
                      setState(() {
                        fetchComments();
                      });
                    });
                  },
                  title: Text(
                    '${comment['title'].length > 20 ? '${comment['title'].substring(0, 18)} ⋯' : comment['title']}',
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
                        '${comment['body'].length > 20 ? '${comment['body'].substring(0, 20)} ⋯' : comment['body']}',
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
                                '${comment['likes']}',
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
                                '${comment['commentCount']}',
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
                            DateFormat('HH:mm').format(DateTime.parse(comment['createdAt'])),
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
                            '${comment['authorName'].replaceFirst('경남 진주시 ', '')}***',
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
      ),
    );
  }
}
