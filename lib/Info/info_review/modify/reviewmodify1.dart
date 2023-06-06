import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneroom_ex/Info/info_review/modify/reviewmodify2.dart';
import 'package:oneroom_ex/map/review_detail/review1_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import '../../../common/colors.dart';
import '../../../map/review_detail/review_class.dart';

class Reviewmodify1 extends StatefulWidget {
  Reviewmodify1(this.location, this.reviewid);
  final String location;
  final int reviewid;

  @override
  State<Reviewmodify1> createState() => _Reviewmodify1State();
}

class _Reviewmodify1State extends State<Reviewmodify1> {
  Future<Reviewdetail> reviewmodify1Data() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/map/${widget.location}/review/${widget.reviewid}/modify'));
    if (response.statusCode == 200) {
      print('응답했다');
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      var _data = Reviewdetail.fromJson(data);
      return _data;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  final InputController = TextEditingController();
  var model = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          '리뷰 수정(1/2)',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder<Reviewdetail>(
          future: reviewmodify1Data(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var modify1 = snapshot.data;
              double review_lessor = modify1!.grade.lessor;
              double review_quality = modify1.grade.quality;
              double review_area = modify1.grade.area;
              double review_noise = modify1.grade.noise;
              return Flex(
                direction: Axis.vertical,
                children: [
                  Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.all(20),
                              child: Column(children: [
                                Row(children: [
                                  Text("주소",
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold)),
                                ]),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(25),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black, // 외곽선 색상 설정
                                              width: 2.0, // 외곽선 두께 설정
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                10.0), // 외곽선 둥글기 설정
                                          ),
                                          width: 350,
                                          height: 110,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${widget.location.replaceFirst('경남 진주시 ', '')}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text("${widget.location}",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          )),
                                    ],
                                  ),
                                  height: 100,
                                ),
                              ])),
                          Divider(
                            thickness: 5,
                          ),
                          Container(
                            padding: EdgeInsets.all(30),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Text(
                                      "※만족도를 평가해주세요!",
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("임대인 소통",
                                          style: TextStyle(fontSize: 20)),
                                      RatingBar.builder(
                                        initialRating: modify1.grade.lessor,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          review_lessor = rating;
                                          Provider.of<REVIEWProvider>(context,
                                                  listen: false)
                                              .set1(review_lessor);
                                          print(rating);
                                        },
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("소음",
                                          style: TextStyle(fontSize: 20)),
                                      RatingBar.builder(
                                        initialRating: modify1.grade.noise,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          review_noise = rating;
                                          Provider.of<REVIEWProvider>(context,
                                                  listen: false)
                                              .set2(review_noise);
                                          print(rating);
                                        },
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("시설",
                                          style: TextStyle(fontSize: 20)),
                                      RatingBar.builder(
                                        initialRating: modify1.grade.quality,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          review_quality = rating;
                                          Provider.of<REVIEWProvider>(context,
                                                  listen: false)
                                              .set3(review_quality);
                                          print(rating);
                                        },
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("면적",
                                          style: TextStyle(fontSize: 20)),
                                      RatingBar.builder(
                                        initialRating: modify1.grade.area,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          review_area = rating;
                                          Provider.of<REVIEWProvider>(context,
                                                  listen: false)
                                              .set4(review_area);
                                          print(rating);
                                        },
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return Reviewmodify2(
                                              widget.location,
                                              widget.reviewid,
                                              review_area,
                                              review_lessor,
                                              review_noise,
                                              review_quality);
                                        }),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(50),
                                      backgroundColor: PRIMARY_COLOR,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text("다음 단계",
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),
                          )
                        ]),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return SnackBar(
                content: Text('error 에러!!'),
              );
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
