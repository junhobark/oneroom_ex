import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:oneroom_ex/map/review_detail/review_class.dart';
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
                    size: 20,
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
          Text("${widget.location}", style: TextStyle(fontSize: 12)),
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
}
