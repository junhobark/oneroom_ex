import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:oneroom_ex/map/review_detail/review_class.dart';
import 'package:provider/provider.dart';
import '../login/uid_provider.dart';
import 'review_detail/bodyclass.dart';
import 'review_detail/gradeclass.dart';
import 'package:http/http.dart' as http;

class MyBottomSheet extends StatefulWidget {
  final String location;

  MyBottomSheet(this.location);

  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  List<Reviewdetail> reviews = [];
  bool isLiked = false;
  void favoritePostRequest(String memberId, String location) async {
    try {
      var url = Uri.parse('https://10.0.2.2:8080/map/favorite');
      var headers = {'Content-Type': 'application/json'};
      var body = jsonEncode({
        'location': location,
        'memberId': memberId,
      });

      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // POST 요청이 성공한 경우
        print('POST 요청 성공!favorite');
        print('POST 요청 상태 코드: ${response.statusCode}');
      } else {
        // POST 요청이 실패한 경우
        print('POST 요청 실패. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      // 네트워크 오류 등 예외 처리
      print('POST 요청 오류: $e');
    }
  }

  void favoriteDeleteRequest(String location) async {
    try {
      Dio dio = Dio();
      var response =
          await dio.delete('https://10.0.2.2:8080/map/favorite/${location}');

      if (response.statusCode == 200) {
        // POST 요청이 성공한 경우
        print('POST 요청 성공!delete');
        print('POST 요청 상태 코드: ${response.statusCode}');
        // POST 요청이 실패한 경우
        print('POST 요청 실패. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      // 네트워크 오류 등 예외 처리
      print('POST 요청 오류: $e');
    }
  }

  Future<List<Reviewdetail>> reviewfetchData() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8080/map/${widget.location}/detail'));
    if (response.statusCode == 200) {
      print('응답했다2');
      final datadetail =
          jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

      return datadetail.map((item) => Reviewdetail.fromJson(item)).toList();
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    reviewfetchData().then((data) {
      setState(() {
        reviews = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${widget.location.replaceFirst('경남 진주시 ', '')}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: 20,
                      );
                    },
                    onTap: onLikeButtonTapped,
                  ),
                  SizedBox(width: 20),
                  Text(
                    '${NumberFormat("#.#").format(totalgrade() / (4 * totalcount()))}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '(리뷰 ${totalcount()})',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${widget.location}", style: TextStyle(fontSize: 12)),
              RatingBarIndicator(
                rating: totalgrade() / 4,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 17.0,
                direction: Axis.horizontal,
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(
            color: Colors.grey,
            thickness: 2,
          ),
          SizedBox(height: 10),
          Text("리뷰",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 20,
          ),
          FutureBuilder<List<Reviewdetail>>(
            future: reviewfetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Reviewdetail reviews = snapshot.data![index];
                        Body body = reviews.body;
                        Grade grade = reviews.grade;
                        List<Map<String, dynamic>> images = reviews.images;

                        return Container(
                          child: ListTile(
                            title: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.account_circle,
                                      size: 35,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "익명${reviews.id}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    RatingBarIndicator(
                                      rating: (grade.lessor +
                                              grade.area +
                                              grade.noise +
                                              grade.quality) /
                                          4,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 17.0,
                                      direction: Axis.horizontal,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      '${NumberFormat("#.#").format((grade.lessor + grade.area + grade.noise + grade.quality) / 4)}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${DateFormat("yy/MM/dd HH:mm").format(reviews.modifiedAt)}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      for (var image in images)
                                        Container(
                                          padding: EdgeInsets.zero,
                                          width: 150,
                                          height: 150,
                                          child:
                                              reviews.buildImageWidget(image),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('장점',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                        fontSize: 15)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("${body.advantage}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 15)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('단점',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 15)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('${body.weakness}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 15)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('기타',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        fontSize: 15)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('${body.etc}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 15)),
                                SizedBox(
                                  height: 15,
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}에러!!");
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  int totalcount() {
    int count = 0;
    // ignore: unused_local_variable
    for (var data in reviews) {
      count = count + 1;
    }
    return count;
  }

  double totalgrade() {
    double grade = 0;
    for (var data in reviews) {
      grade = grade +
          (data.grade.area +
              data.grade.lessor +
              data.grade.noise +
              data.grade.quality);
    }
    return grade;
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    if (isLiked) {
      this.isLiked = false;
    } else {
      favoriteDeleteRequest(widget.location);
      this.isLiked = true;
    }
    favoritePostRequest(
        Provider.of<UIDProvider>(context, listen: false).uid, widget.location);
    return Future.value(this.isLiked);
  }
}
