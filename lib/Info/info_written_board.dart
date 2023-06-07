import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:oneroom_ex/common/colors.dart';
import 'package:oneroom_ex/community/GENERAL/general_board_postId.dart';
import 'package:oneroom_ex/community/MARKET/market_board_postId.dart';
import 'package:oneroom_ex/community/TIPS/tips_board_postId.dart';
import 'package:provider/provider.dart';
import '../../login/uid_provider.dart';
import '../common/default_layout.dart';

class WrittenBoardScreen extends StatefulWidget {
  const WrittenBoardScreen({Key? key}) : super(key: key);

  @override
  State<WrittenBoardScreen> createState() => _WrittenBoardScreenState();
}

class _WrittenBoardScreenState extends State<WrittenBoardScreen> {
  List<dynamic> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final url = Uri.parse(
        'http://10.0.2.2:8080/user/${Provider.of<UIDProvider>(context, listen: false).uid}/post');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = utf8.decode(response.bodyBytes);

      setState(() {
        posts = json.decode(data);
      });
    } else {
      print('Failed to fetch posts. Error: ${response.statusCode}');
    }
  }

  void navigateToPostScreen(dynamic post) {
    if (post['category'] == 'GENERAL') {
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (BuildContext context) => GeneralBoardPostId(post['id']),
        ),
      )
          .then((value) {
        setState(() {
          fetchPosts();
        });
      });
    } else if (post['category'] == 'MARKET') {
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (BuildContext context) => MarketBoardPostId(post['id']),
        ),
      )
          .then((value) {
        setState(() {
          fetchPosts();
        });
      });
    } else if (post['category'] == 'TIPS') {
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (BuildContext context) => TipsBoardPostId(post['id']),
        ),
      )
          .then((value) {
        setState(() {
          fetchPosts();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title:'내가 쓴 글',
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
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
                    navigateToPostScreen(post);
                  },
                  title: Text(
                    '${post['title'].length > 20 ? '${post['title'].substring(0, 18)} ⋯' : post['title']}',
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
                        '${post['body'].length > 20 ? '${post['body'].substring(0, 20)} ⋯' : post['body']}',
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
                                '${post['likes']}',
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
                                '${post['commentCount']}',
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
                                .format(DateTime.parse(post['createdAt'])),
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
                            '${post['authorName'].replaceFirst('경남 진주시 ', '')}***',
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
