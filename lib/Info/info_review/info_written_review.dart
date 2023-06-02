import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:oneroom_ex/Info/info_review/reviewinfo_class.dart';
import 'package:provider/provider.dart';
import '../../common/colors.dart';
import '../../common/default_layout.dart';
import '../../login/uid_provider.dart';
import '_bodyclass.dart';
import '_gradeclass.dart';

class WrittenReviewScreen extends StatefulWidget {
  const WrittenReviewScreen({Key? key}) : super(key: key);

  @override
  State<WrittenReviewScreen> createState() => _WrittenReviewScreenState();
}

void myreviewDeleteRequest(String location, String uid) async {
  try {
    Dio dio = new Dio();
    // dio.httpClientAdapter = DefaultHttpClientAdapter();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (client) {
    //   print('onHttpClientCreate entered...'); // this code is never reached
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;
    //   client.findProxy = (uri) {
    //     return "PROXY 192.168.0.7:8080";
    //   };
    //   return client;
    // };
    // dio.options.connectTimeout = Duration(milliseconds: 3000);
    // dio.options.receiveTimeout = Duration(milliseconds: 3000);
    var response =
        await dio.delete('https://10.0.2.2:8080/${location}/${uid}}/delete');

    if (response.statusCode == 200) {
      // POST 요청이 성공한 경우
      print('POST 요청 성공!delete');
      print('POST 요청 상태 코드: ${response.statusCode}');
      // POST 요청이 실패한 경우
    } else {
      // POST 요청이 실패한 경우
      print('POST 요청 실패. 상태 코드: ${response.statusCode}');
    }
  } catch (e) {
    // 네트워크 오류 등 예외 처리
    print('POST 요청 오류: $e');
  }
}

class _WrittenReviewScreenState extends State<WrittenReviewScreen> {
  Future<List<Reviewinfo>?> reviewinfofetchData() async {
    try {
      String uid = Provider.of<UIDProvider>(context, listen: false).uid;
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8080/user/${uid}}/review'));
      if (response.statusCode == 200) {
        print('응답했다2');
        final datadetail =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

        return datadetail.map((item) => Reviewinfo.fromJson(item)).toList();
      } else {
        print('An error occurred: e');
        throw Exception('An error occurred:');
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '내가 쓴 리뷰',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<Reviewinfo>?>(
            future: reviewinfofetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Reviewinfo reviews = snapshot.data![index];
                        BBody body = reviews.body;
                        GGrade grade = reviews.grade;
                        return ListTile(
                          title: Container(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${reviews.location.replaceFirst('경남 진주시 ', '')}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  "${reviews.location}",
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
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
                                      "익명",
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        '수정',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ),
                                          side: BorderSide(
                                            width: 1,
                                            color: PRIMARY_COLOR,
                                          ),
                                          backgroundColor: PRIMARY_COLOR,
                                          foregroundColor: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        myreviewDeleteRequest(
                                            reviews.location,
                                            Provider.of<UIDProvider>(context,
                                                    listen: false)
                                                .uid);
                                      },
                                      child: Text(
                                        '삭제',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ),
                                          side: BorderSide(
                                            width: 1,
                                            color: PRIMARY_COLOR,
                                          ),
                                          backgroundColor: PRIMARY_COLOR,
                                          foregroundColor: Colors.white),
                                    ),
                                  ],
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
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                        '내가 쓴 리뷰가 없어요',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
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
