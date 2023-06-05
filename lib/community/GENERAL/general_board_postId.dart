import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:oneroom_ex/common/colors.dart';
import 'package:oneroom_ex/community/GENERAL/general_board_screen.dart';
import 'package:oneroom_ex/community/GENERAL/general_board_write_edit.dart';

class GeneralBoardPostId extends StatefulWidget {
  final int id;

  GeneralBoardPostId(this.id);

  @override
  _GeneralBoardPostIdState createState() => _GeneralBoardPostIdState();
}

class _GeneralBoardPostIdState extends State<GeneralBoardPostId> {
  Map<String, dynamic>? postData;
  List<Map<String, dynamic>> images = [];
  TextEditingController commentController = TextEditingController();
  bool liked = false; //초기엔 본문 공감 안된 상태
  bool isliked = false; //초기엔 댓글 공감 안된 상태

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  //데이터 받아올때
  Future<void> fetchData() async {
    var url = Uri.parse('http://10.0.2.2:8080/community/GENERAL/${widget.id}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        postData = responseData;
        images = List<Map<String, dynamic>>.from(responseData['images']);
      });
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  //게시글 삭제
  Future<void> deletePost() async {
    var url = Uri.parse('http://10.0.2.2:8080/community/GENERAL/${widget.id}');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      // 게시물이 성공적으로 삭제되었을 때의 처리
      Navigator.pushReplacement(
        //pop으로 뒤로못가게push
        context,
        MaterialPageRoute(builder: (context) => GeneralBoardScreen()),
      );
    } else {
      print('Failed to delete post: ${response.statusCode}');
    }
  }

  //게시글 댓글 삭제
  Future<void> deleteComment(int commentId) async {
    var url = Uri.parse(
        'http://10.0.2.2:8080/community/GENERAL/${widget.id}/${commentId}');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      // 댓글이 성공적으로 삭제되었을 때의 처리
      fetchData();
    } else {
      print('Failed to delete comment: ${response.statusCode}');
    }
  }

  //게시글 좋아요
  Future<void> postLike() async {
    var url =
        Uri.parse('http://10.0.2.2:8080/community/GENERAL/${widget.id}/like');
    var body = {"memberId": "abc"};

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      setState(() {
        liked = true; // 공감 상태로 변경
      });
      fetchData();
    } else {
      print('Failed to post like: ${response.statusCode}');
    }
  }

  //게시글 댓글 좋아요
  Future<void> commentLike(int commentId) async {
    var url = Uri.parse(
        'http://10.0.2.2:8080/community/GENERAL/${widget.id}/${commentId}/like');
    var body = {"memberId": "abc"};

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      setState(() {
        isliked = true; // 공감 상태로 변경
      });
      fetchData();
    } else {
      print('Failed to post like: ${response.statusCode}');
    }
  }

  //게시글 댓글 추가
  Future<void> postComment() async {
    var url = Uri.parse(
        'http://10.0.2.2:8080/community/GENERAL/${widget.id}/writeComment');
    var body = {
      "memberId": "abc",
      "postId": "${widget.id}",
      "body": commentController.text,
    };

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      fetchData();
      commentController.clear();
    } else {
      print('Failed to post comment: ${response.statusCode}');
    }
  }

  //게시글 댓글 수정 get
  Future<Map<String, dynamic>> fetchComment(int commentId) async {
    var url =
        'http://10.0.2.2:8080/community/GENERAL/${widget.id}/${commentId}';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var commentData = json.decode(response.body);
      return commentData;
    } else {
      throw Exception('Failed to fetch comment');
    }
  }

  //게시글 댓글 수정 put
  Future<void> updateComment(int commentId, String body) async {
    var url = Uri.parse(
        'http://10.0.2.2:8080/community/GENERAL/${widget.id}/${commentId}');
    var requestBody = {'body': body};

    try {
      var response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('댓글이 성공적으로 수정되었습니다.');
        fetchData();
        commentController.clear();
      } else {
        print('Failed to update comment: ${response.statusCode}');
      }
    } catch (error) {
      print('댓글 수정 중 오류가 발생했습니다: $error');
    }
  }

  int? commentid = 0;
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '자유게시판',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          // 키보드가 사라지도록 포커스 해제
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            Expanded(
              //본문(작성자)
              child: SingleChildScrollView(
                child: postData != null
                    ? Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(6, 3, 10, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'asset/img/logo/Info_profile.png',
                                  width: 60,
                                  height: 60,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${postData!['authorName']}****',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('MM/dd  HH:mm').format(
                                        DateTime.parse(postData!['createdAt']),
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.0,
                                        color: BODY_TEXT_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            //본문(게시글)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${postData!['title']}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${postData!['body']}',
                                    style: TextStyle(
                                      color: BODY_TEXT_COLOR,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Column(
                                    children: <Widget>[
                                      for (var image in images)
                                        Column(
                                          children: [
                                            Image.memory(
                                              base64Decode(image['body']),
                                              fit: BoxFit.cover,
                                              width: 200,
                                              height: 200,
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 14),
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
                                          //본문 추천 likes
                                          Text(
                                            '${postData!['likes']}',
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
                                            '${postData!['commentCount']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 14),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //본문 추천(공감) 버튼
                                      Container(
                                        width: 85.0,
                                        height: 30.0,
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            if (liked) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text('이미 공감한 글입니다.'),
                                                ),
                                              );
                                            } else {
                                              postLike();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content:
                                                      Text('이 글을 공감하셨습니다.'),
                                                ),
                                              );
                                            }
                                          },
                                          icon: Icon(
                                            Icons.thumb_up_alt_outlined,
                                            color: liked
                                                ? Colors.black
                                                : Colors.black,
                                            size: 16,
                                          ),
                                          label: Text(
                                            '공감',
                                            style: TextStyle(
                                              color: liked
                                                  ? Colors.black
                                                  : Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: INPUT_BG_COLOR,
                                          ),
                                        ),
                                      ),
                                      //본문 수정
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          GeneralBoardWriteEdit(
                                                    id: postData!['id'],
                                                  ),
                                                ),
                                              ) //.then~ //실행 후 게시판을 최신화
                                                  .then((value) {
                                                setState(() {
                                                  fetchData();
                                                });
                                              });
                                            },
                                            child: Text(
                                              '수정',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w700,
                                                color: BODY_TEXT_COLOR,
                                              ),
                                            ),
                                          ),

                                          //본문 삭제
                                          TextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      '이 글을 삭제하시겠습니까?',
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text(
                                                          '네',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // 다이얼로그 닫기
                                                          Navigator.of(context)
                                                              .pop(); // 다이얼로그 닫기
                                                          deletePost();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          '아니오',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // 다이얼로그 닫기
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Text(
                                              '삭제',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w700,
                                                color: BODY_TEXT_COLOR,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 14),
                            Divider(
                              color: Colors.grey[200],
                              thickness: 4.0,
                            ),
                            //댓글
                            SingleChildScrollView(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: postData!['comments'].length,
                                itemBuilder: (context, index) {
                                  var comment = postData!['comments'][index];
                                  var commentId = comment['id'];
                                  // ignore: unused_local_variable
                                  var commentCreatedAt = comment['createdAt'];
                                  return ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'asset/img/logo/Info_profile.png',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                                Text(
                                                  '익명$commentId',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    comment['body'],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        DateFormat(
                                                                'MM/dd  HH:mm')
                                                            .format(
                                                          DateTime.parse(
                                                              postData![
                                                                  'createdAt']),
                                                        ),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14.0,
                                                          color:
                                                              BODY_TEXT_COLOR,
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      //댓글추천 카운트
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .thumb_up_alt_outlined,
                                                            size: 14,
                                                            color: Colors.red,
                                                          ),
                                                          SizedBox(width: 3),
                                                          Text(
                                                            '${comment['likes']}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14.0,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 6),
                                                  Divider(
                                                    color: Colors.grey[200],
                                                    thickness: 1.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 65.0),
                                                //댓글 추천 버튼
                                                Container(
                                                  width: 40.0,
                                                  height: 40.0,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      if (isliked) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                '이미 공감한 댓글입니다.'),
                                                          ),
                                                        );
                                                      } else {
                                                        commentLike(commentId);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                '이 댓글을 공감하셨습니다.'),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons
                                                          .thumb_up_alt_outlined,
                                                      color: isliked
                                                          ? Colors.black
                                                          : Colors.black,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                //댓글 수정
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      String commentText =
                                                          comment['body'];
                                                      commentController.text =
                                                          commentText;
                                                      commentid =
                                                          comment != null
                                                              ? comment['id']
                                                                  as int?
                                                              : null;
                                                      isEditing = true;
                                                    });
                                                  },
                                                  child: Text(
                                                    '수정',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: BODY_TEXT_COLOR,
                                                    ),
                                                  ),
                                                ),
                                                //댓글 삭제 버튼
                                                TextButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                            '이 댓글을 삭제하시겠습니까?',
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text(
                                                                '네',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                deleteComment(
                                                                    commentId);
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text(
                                                                '아니오',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(); // 다이얼로그 닫기
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text(
                                                    '삭제',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: BODY_TEXT_COLOR,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            ),

            //하단 댓글
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 37.0,
                      child: TextField(
                        controller: commentController,
                        style: TextStyle(fontSize: 12.0),
                        decoration: InputDecoration(
                          hintText: '댓글을 입력하세요',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: BODY_TEXT_COLOR,
                          ),
                          contentPadding: EdgeInsets.all(6.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: PRIMARY_COLOR,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: PRIMARY_COLOR,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: PRIMARY_COLOR,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // 댓글 작성 버튼을 눌렀을 때 키보드가 사라지도록 포커스 해제
                      FocusScope.of(context).requestFocus(FocusNode());
                      String commentText = commentController.text
                          .trim(); // Trim leading/trailing whitespaces
                      if (commentText.isNotEmpty) {
                        if (isEditing && commentid != null) {
                          updateComment(commentid!, commentText);
                          commentController.clear(); // 수정 후 입력 필드 비우기
                        } else {
                          postComment();
                        }
                        setState(() {
                          isEditing = false;
                        });
                      }
                    },
                    child: Text(isEditing ? '댓글 수정' : '댓글 작성'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(PRIMARY_COLOR),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
