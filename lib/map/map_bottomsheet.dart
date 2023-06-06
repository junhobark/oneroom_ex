import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:oneroom_ex/map/review_detail/review_class.dart';
import 'package:oneroom_ex/map/sortedProvider.dart';
import 'package:provider/provider.dart';
import '../login/uid_provider.dart';
import 'favorite/favoriteclass.dart';
import 'like_provider.dart';
import 'review_detail/bodyclass.dart';
import 'review_detail/gradeclass.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class MyBottomSheet extends StatefulWidget {
  final String location;
  final double lat;
  final double lng;

  MyBottomSheet(this.location, this.lat, this.lng);

  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet>
    with WidgetsBindingObserver {
  List<Reviewdetail> reviews = [];
  List<Favorite> favorite = [];
  bool isLiked = false;

  Future<List<Favorite>> favoritefetchData() async {
    String uid = Provider.of<UIDProvider>(context, listen: false).uid;
    print(uid);
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8080/user/${uid}/favorite'));
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
  }

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

  Future<List<Reviewdetail>> reviewfetchData() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8080/map/${widget.location}/review'));
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
    favoritefetchData().then((data) {
      setState(() {
        favorite = data;
      });
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 앱이 다시 활성화될 때 실행될 코드
      setState(() {
        // 상태 변경
      });
    }
  }

  void someFunction() {
    // 함수 실행 후 setState를 실행하려면
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        favoritefetchData().then((data) {
          setState(() {
            favorite = data;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    islike(widget.location);
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
                      isLiked:
                          Provider.of<LikeProvider>(context).isLiked == true
                              ? true
                              : false,
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          Icons.favorite,
                          color: isLiked ? Colors.red : Colors.grey,
                          size: 20,
                        );
                      },
                      onTap: (isLiked) => onLikeButtonTapped(
                          Provider.of<LikeProvider>(context, listen: false)
                              .isLiked,
                          widget.location,
                          widget.lat,
                          widget.lng)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("리뷰",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Row(children:[
                if(Provider.of<SortedProvider>(context,listen:false).sorted == 0)
                Text("최신순",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                if(Provider.of<SortedProvider>(context,listen:false).sorted == 1)
                  Text("평점순↑",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                if(Provider.of<SortedProvider>(context,listen:false).sorted == 2)
                Text("평점순↓",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.sort),
                tooltip: '정렬하기',
                onPressed: () {
                  setState(() {
                    if (Provider.of<SortedProvider>(context,listen:false).sorted == 0) {
                      Provider.of<SortedProvider>(context,listen:false).sort1();
                    } else if(Provider.of<SortedProvider>(context,listen:false).sorted == 1){
                      Provider.of<SortedProvider>(context,listen:false).sort2();
                    }else{
                      Provider.of<SortedProvider>(context,listen:false).sort0();
                    }
                  });
                },
              )])
            ],
          ),
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
                        Reviewdetail reviews;
                        if(Provider.of<SortedProvider>(context,listen:false).sorted == 0){
                          reviews = snapshot.data![index];}
                        else if(Provider.of<SortedProvider>(context,listen:false).sorted == 1){
                          List<Reviewdetail> sortedList = [...snapshot.data!];
                          sortedList.sort((b, a) => (a.grade.lessor+a.grade.area+a.grade.noise+a.grade.quality).compareTo((b.grade.lessor+b.grade.area+b.grade.noise+b.grade.quality)));
                          reviews = sortedList[index];
                        }else{
                          List<Reviewdetail> sortedList = [...snapshot.data!];
                          sortedList.sort((a, b) => (a.grade.lessor+a.grade.area+a.grade.noise+a.grade.quality).compareTo((b.grade.lessor+b.grade.area+b.grade.noise+b.grade.quality)));
                          reviews = sortedList[index];
                        }
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
                                          padding: EdgeInsets.all(1),
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

    setState(() {
      favoritefetchData().then((data) {
        setState(() {
          favorite = data;
        });
      });
    });

    // isLiked 값 반전시키기
    isLiked = !isLiked;
    Provider.of<LikeProvider>(context, listen: false).toggleLike();
    return isLiked;
  }

  bool islike(String location) {
    Provider.of<LikeProvider>(context, listen: false).Likefalse();
    for (var data in favorite) {
      if (data.location == location) {
        Provider.of<LikeProvider>(context, listen: false).Liketrue();
        break;
      }
    }
    return Provider.of<LikeProvider>(context, listen: false).isLiked;
  }
}
