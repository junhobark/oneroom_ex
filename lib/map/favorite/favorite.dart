import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:oneroom_ex/map/favorite/favoriteclass.dart';
import 'package:provider/provider.dart';
import '../../../../login/uid_provider.dart';
import 'package:http_parser/http_parser.dart';

import '../../common/root_tab.dart';

class favoriteScreen extends StatefulWidget {
  const favoriteScreen({Key? key}) : super(key: key);

  @override
  State<favoriteScreen> createState() => favoriteScreenState();
}

class favoriteScreenState extends State<favoriteScreen> {
  bool isLiked = true;
  int sorted = 0;
  Future<String?> favoritePostRequest(
      String uid, String location, double lat, double lng) async {
    final dio = Dio();

    Map<String, dynamic> favoriteDto = {
      'location': location,
      'memberId': uid,
      'posx': lat,
      'posy': lng
    };
    print(location);
    print(uid);
    String jsonString = jsonEncode(favoriteDto);

    FormData formData = FormData.fromMap({
      'favoriteDto': MultipartFile.fromString(
        jsonString,
        contentType: MediaType('application', 'json'),
      )
    });

    Response response = await dio.post(
      'http://10.0.2.2:8080/map/favorite',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
    if (response.statusCode == 200) {
      print('요청성공!,');
      String result = '성공';
      return result;
    } else {
      print('${response.statusCode}');
      return null;
    }
  }

  Future<String> favoriteDeleteRequest(String uid, String location) async {
    final dio = Dio();

    Map<String, dynamic> favoriteDto = {
      'location': location,
      'memberId': uid,
    };
    print(location);
    print(uid);
    String jsonString = jsonEncode(favoriteDto);

    FormData formData = FormData.fromMap({
      'favoriteDto': MultipartFile.fromString(
        jsonString,
        contentType: MediaType('application', 'json'),
      )
    });

    Response response = await dio.delete(
      'http://10.0.2.2:8080/map/favorite',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
    if (response.statusCode == 200) {
      print('요청성공!,');
      String result = '성공';
      return result;
    } else {
      print('${response.statusCode}');
      String result = '';
      return result;
    }
  }

  Future<List<Favorite>?> favoritefetchData() async {
    try {
      String uid = Provider.of<UIDProvider>(context, listen: false).uid;
      print(uid);
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8080/user/${uid}/favorite'));
      if (response.statusCode == 200) {
        print('응답했다!');
        final datadetail =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        print(datadetail.map((item) => Favorite.fromJson(item)).toList());
        return datadetail.map((item) => Favorite.fromJson(item)).toList();
      } else {
        print('An error occurred: e');
        throw Exception('An error occurred:');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1, //튀어나오는 효과
        title: Text(
          '관심건물',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        foregroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),
            tooltip: '정렬하기',
            onPressed: () {
    setState(() {
    if (sorted == 0) {
    sorted = 1;
    } else {
    sorted = 0;
    }
    });

            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<Favorite>?>(
              future: favoritefetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty)  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              '등록된 관심 건물이 없어요 😥',
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),);else{
                  return Flex(
                    direction: Axis.vertical,
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Favorite favorite;
                              if(sorted==0){
                              favorite = snapshot.data![index];}
                              else {
                                List<Favorite> sortedList = [...snapshot.data!];
                              sortedList.sort((b, a) => a.totalGrade.compareTo(b.totalGrade));
                              favorite = sortedList[index];
                              }
                              return ListTile(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RootTab(
                                          latitude: favorite.posx,
                                          longitude: favorite.posy,
                                          location: favorite.location),
                                    ),
                                  );
                                },
                                title: Container(
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 15, right: 15),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "${favorite.location.replaceFirst('경남 진주시 ', '')}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            children: [
                                              LikeButton(
                                                isLiked: isLiked,
                                                likeBuilder: (bool isLiked) {
                                                  return Icon(
                                                    Icons.favorite,
                                                    color: isLiked
                                                        ? Colors.red
                                                        : Colors.grey,
                                                    size: 20,
                                                  );
                                                },
                                                onTap: (isLiked) =>
                                                    onLikeButtonTapped(
                                                        isLiked,
                                                        favorite.location,
                                                        favorite.posx,
                                                        favorite.posy),
                                              ),
                                              SizedBox(width: 20),
                                              Text(
                                                favorite.totalGrade == 0
                                                    ? '0.0'
                                                    : '${NumberFormat(".#").format((favorite.totalGrade / 4))}',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '(리뷰 ${favorite.reviewCount.toInt()})',
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("${favorite.location}",
                                              style: TextStyle(fontSize: 12)),
                                          RatingBarIndicator(
                                            rating: favorite.totalGrade / 4,
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 17.0,
                                            direction: Axis.horizontal,
                                          ),
                                        ],
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(""),
                                          ]),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  );}
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
                          '등록된 관심 건물이 없어요 😥',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Future<bool> onLikeButtonTapped(
      bool isLiked, String location, double lat, double lng) async {
    if (isLiked) {
      // 좋아요 취소를 위해 DELETE 요청 보내기
      favoriteDeleteRequest(
          Provider.of<UIDProvider>(context, listen: false).uid, location);
    } else {
      // 좋아요 추가를 위해 POST 요청 보내기
      favoritePostRequest(Provider.of<UIDProvider>(context, listen: false).uid,
          location, lat, lng);
    }

    // isLiked 값 반전시키기
    isLiked = !isLiked;

    return isLiked;
  }
}
