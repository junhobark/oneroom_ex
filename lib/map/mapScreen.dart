import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:oneroom_ex/common/default_layout.dart';
import 'package:oneroom_ex/map/like_provider.dart';
import 'package:oneroom_ex/map/map_markers.dart';
import 'package:oneroom_ex/map/review1.dart';
import 'package:kpostal/kpostal.dart';
import 'package:like_button/like_button.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../login/uid_provider.dart';
import 'favorite/favoriteclass.dart';
import 'locationProvider.dart';
import 'map_bottomsheet.dart';
import 'review_detail/review_class.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http_parser/http_parser.dart';

const String kakaoMapKey = '06fa866ad2a59ae0dfba2b8c9d47a578';

class mapScreen extends StatefulWidget {
  mapScreen(
      {required this.latitude,
      required this.longitude,
      required this.location});

  final double latitude;
  final double longitude;
  final String location;

  @override
  State<mapScreen> createState() => _mapScreenState();
}

class _mapScreenState extends State<mapScreen>
    with SingleTickerProviderStateMixin {
  String jsonData = '';
  List<Mapmarkers> mapmarkers = [];
  List<Reviewdetail> reviews = [];
  List<Favorite> favorite = [];

  Future<List<Mapmarkers>> sendGetmarkerFormData(lat, lng) async {
    var url = 'http://10.0.2.2:8080/map/building';

    final queryParameters = {
      'lat': lat.toString(),
      'lon': lng.toString(),
      'memberId': '${Provider.of<UIDProvider>(context, listen: false).uid}',
    };
    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    // GET 요청 보내기
    final response = await http.get(uri);

    // 응답 처리
    if (response.statusCode == 200) {
      print('요청성공!!!!!!!,${lat},${lng}');
      // 응답을 JSON으로 파싱하여 데이터 처리
      final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));

      return jsonData.map((data) => Mapmarkers.fromJson(data)).toList();
    } else {
      // 요청이 실패한 경우 예외 처리
      throw Exception('Failed to load building list');
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

  Future<String?> favoriteDeleteRequest(String uid, String location) async {
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
      return null;
    }
  }

  Future<List<Favorite>?> favoritefetchData() async {
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
      return null;
    }
  }

  Future<List<Reviewdetail>> reviewfetchData(location) async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8080/map/${location}/review'));
    if (response.statusCode == 200) {
      print('응답했다2');
      final datadetail =
          jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      return datadetail.map((item) => Reviewdetail.fromJson(item)).toList();
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  late KakaoMapController mapController;
  int currentLevel = 0;
  List<Marker> markers = [];
  var model = null;
  var selectedPlace = null;
  final TextEditingController _AddressController = TextEditingController();
  String roadaddress = '';
  String jibunaddress = '';
  String removeaddress = '';
  double kakaoLatitude = 0;
  double kakaoLongitude = 0;
  bool draggable = true;
  bool zoomable = true;
  late double _latitude;
  late double _longitude;
  late String _location;

  @override
  void initState() {
    super.initState();
    favoritefetchData().then((data) {
      setState(() {
        favorite = data!;
      });
    });
    _location = widget.location;
    _latitude = widget.latitude;
    _longitude = widget.longitude;

    if(35>_latitude|| _latitude>35.5 || 128>_longitude|| _longitude>128.9){
      _latitude =35.156678;
      _longitude =128.104985;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Stack(
        children: [
          KakaoMap(
              onMapCreated: ((controller) async {
                setState(() async{
                  mapController = controller;
                  await sendGetmarkerFormData(widget.latitude,widget.longitude).then((data) {
                    setState(() {
                      mapmarkers = data;
                    });
                  });
                  mapmarkers.map((data) async {
                    markers.add(Marker(
                        markerId: data.id.toString(),
                        latLng: LatLng(data.posx, data.posy),
                        markerImageSrc:
                        'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png'));
                  }).toList();
                  int en = 0;
                  print("관심건물 위치:${_location}");
                  if (_location != "") {
                    for (var data in mapmarkers) {
                      if (_location == data.location) {
                        favoritefetchData().then((data) {
                          setState(() {
                            favorite = data!;
                          });
                        });
                        islike(_location);
                        Future.delayed(Duration(milliseconds: 250), () {
                          map_showDialog(data.id.toString());
                        });
                        en = 1;
                      }
                    }
                    if (en == 0) {
                      markers.add(Marker(
                        markerId: 'maId',
                        latLng: LatLng(_latitude, _longitude),
                      ));

                      favoritefetchData().then((data) {
                        setState(() {
                          favorite = data!;
                        });
                        islike(_location);
                        Future.delayed(Duration(milliseconds: 250), () {
                          map_showDialog('maId');
                        });
                      });
                    }
                  }
                  currentLevel = await mapController.getLevel();
                });
              }),
              onDragChangeCallback: ((latLng, zoomLevel, dragType) async {
                switch (dragType) {
                  case DragType.end:
                    final latLng = await mapController.getCenter();
                    sendGetmarkerFormData(latLng.latitude, latLng.longitude);
                    setState(() {
                      markers.clear();
                      mapmarkers.map((data) async {
                        markers.add(Marker(
                            markerId: data.id.toString(),
                            latLng: LatLng(data.posx, data.posy),
                            markerImageSrc:
                                'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png'));
                      }).toList();
                    });
                    break;
                  default:
                    break;
                }
              }),
              markers: markers.toList(),
              currentLevel: 1,
              onMarkerTap: (markerId, latLng, zoomLevel) {
               if(currentLevel>1)
                 currentLevel = 1;
               mapController.setLevel(currentLevel);
               mapController.panTo(latLng);
                sendGetmarkerFormData(latLng.latitude, latLng.longitude).then((data) {
                  setState(() {
                    mapmarkers = data;
                  });
                });
                map_showDialog(markerId);
              },
              center: LatLng(_latitude, _longitude)),
          Positioned(
            top: 100,
            left: 10,
            right: 65,
            child: GestureDetector(
              onTap: () {
                selectedPlace = null;
                removeMarker();
                HapticFeedback.mediumImpact();
                _addressAPI();
              },
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 3.0,
                        spreadRadius: 0.0,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: TextField(
                    style: const TextStyle(fontSize: 16),
                    maxLines: null,
                    controller: _AddressController,
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: '주소를 검색하세요',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  )),
                  Icon(
                    Icons.search,
                    size: 23,
                  ),
                ]),
              ),
            ),
          ),
          Positioned(
              top: 100,
              left: 350,
              right: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 3.0,
                      spreadRadius: 0.0,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                width: 50,
                height: 50,
                child: IconButton(
                  onPressed:
    Provider.of<UIDProvider>(context, listen: false).location ==null?
    ()  {showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Text(
                '거주지 인증을 먼저 완료해주세요!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              actions: [
                Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end,
                    children: [
                      Container(
                          child: TextButton(
                              child: Text(
                                '확인',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight:
                                        FontWeight
                                            .w700,
                                    color: Colors
                                        .black),
                              ),
                              onPressed: () {
                                Navigator.pop(
                                    context);
                              }))
                    ])
              ]);
        });  }: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const ReviewScreen1();
                      }),
                    ).then((value) {
                      if (Provider.of<LocationProvider>(context, listen: false)
                              .cnt ==
                          1) {
                        setState(() {
                          sendGetmarkerFormData(
                                  Provider.of<LocationProvider>(context,
                                          listen: false)
                                      .lat,
                                  Provider.of<LocationProvider>(context,
                                          listen: false)
                                      .lng)
                              .then((data) {
                            setState(() {
                              mapmarkers = data;
                            });
                          });
                          if(currentLevel>1)
                            currentLevel = 1;
                          mapController.setLevel(currentLevel);
                          if(  Provider.of<LocationProvider>(context,
                              listen: false)
                              .lat != 0)
                        {  mapController.panTo(LatLng(
                              Provider.of<LocationProvider>(context,
                                      listen: false)
                                  .lat,
                              Provider.of<LocationProvider>(context,
                                      listen: false)
                                  .lng));

                          for (var data in mapmarkers) {
                            if (data.location ==
                                Provider.of<LocationProvider>(context,
                                        listen: false)
                                    .loca) {
                              map_showDialog(data.id.toString());
                              break;
                            }
                            break;
                          }}
                          ;
                        });
                        Provider.of<LocationProvider>(context, listen: false)
                            .setlocation(0, 0, '', 1);
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.rate_review,
                    size: 30,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  _addressAPI() async {
    model = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KpostalView(
          useLocalServer: false,
          localPort: 8080,
          kakaoKey: kakaoMapKey,
          callback: (Kpostal result) {
            setState(() {
              this.roadaddress = result.roadAddress;
              this.jibunaddress = result.jibunAddress;
              this.kakaoLatitude = result.kakaoLatitude!;
              this.kakaoLongitude = result.kakaoLongitude!;
              removeaddress = roadaddress.replaceFirst('경남 진주시 ', '');
            });
          },
        ),
      ),
    );
    if (model != null) {
      _AddressController.text = '${roadaddress}';
      selectedPlace = roadaddress;
      var lat = kakaoLatitude;
      var lng = kakaoLongitude;
      int cn = 0;
      if (selectedPlace != null) {
        sendGetmarkerFormData(lat, lng).then((data) {
          setState(() {
            mapmarkers = data;
          });
        });
        if(currentLevel>1)
          currentLevel = 1;
        mapController.setLevel(currentLevel);
        mapController.panTo(LatLng(lat, lng));
        for (var data in mapmarkers) {
          if (data.location == roadaddress) {
            map_showDialog(data.id.toString());
            cn = 1;
            break;
          }
        }
        if (cn == 0) {
          markers.add(Marker(
            markerId: 'markerId',
            latLng: LatLng(lat, lng),
          ));
          map_showDialog('markerId');
        }
      }
    }
    favoritefetchData().then((data) {
      setState(() {
        favorite = data!;
      });
    });
    islike(roadaddress);
  }

  map_showDialog(
    String markerId,
  ) {
    favoritefetchData().then((data) {
      setState(() {
        favorite = data!;
      });
    });
    islike(roadaddress);
    if (markerId == 'markerId') {
      Future.delayed(Duration(milliseconds: 250), () {
        showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.white.withOpacity(0.0),
          builder: (BuildContext context) {
            return Stack(children: [
              Positioned(
                top: MediaQuery.of(context).size.height - 250,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  content: SizedOverflowBox(
                    size: const Size(280, 70),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${removeaddress}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  LikeButton(
                                    isLiked: Provider.of<LikeProvider>(context,
                                                    listen: false)
                                                .isLiked ==
                                            true
                                        ? true
                                        : false,
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        Icons.favorite,
                                        color:
                                            isLiked ? Colors.red : Colors.grey,
                                        size: 20,
                                      );
                                    },
                                    onTap: (isLiked) => onLikeButtonTapped(
                                        Provider.of<LikeProvider>(context,
                                                listen: false)
                                            .isLiked,
                                        roadaddress,
                                        kakaoLatitude,
                                        kakaoLongitude),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '0.0',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '(리뷰 0)',
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${roadaddress}",
                                  style: TextStyle(fontSize: 12)),
                              RatingBarIndicator(
                                rating: 0,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 12.0,
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(""),
                              GestureDetector(
                                onTap: () {
                                  bottom_sheet('markerId');
                                },
                                child: Row(children: [
                                  Text("리뷰보기", style: TextStyle(fontSize: 10)),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 10,
                                  )
                                ]),
                              )
                            ],
                          )
                        ]),
                  ),
                ),
              )
            ]);
          },
        );
      });
    } else if (markerId == 'maId') {
      favoritefetchData().then((data) {
        setState(() {
          favorite = data!;
        });
      });
      islike(_location);
      Future.delayed(Duration(milliseconds: 250), () {
        showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.white.withOpacity(0.0),
          builder: (BuildContext context) {
            return Stack(children: [
              Positioned(
                top: MediaQuery.of(context).size.height - 250,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  content: SizedOverflowBox(
                    size: const Size(280, 70),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${_location.replaceFirst('경남 진주시 ', '')}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  LikeButton(
                                    isLiked: Provider.of<LikeProvider>(context,
                                                    listen: false)
                                                .isLiked ==
                                            true
                                        ? true
                                        : false,
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        Icons.favorite,
                                        color:
                                            isLiked ? Colors.red : Colors.grey,
                                        size: 20,
                                      );
                                    },
                                    onTap: (isLiked) => onLikeButtonTapped(
                                        Provider.of<LikeProvider>(context,
                                                listen: false)
                                            .isLiked,
                                        roadaddress,
                                        kakaoLatitude,
                                        kakaoLongitude),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '0.0',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '(리뷰 0)',
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${_location}",
                                  style: TextStyle(fontSize: 12)),
                              RatingBarIndicator(
                                rating: 0,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 12.0,
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(""),
                              GestureDetector(
                                onTap: () {
                                  bottom_sheet('maId');
                                },
                                child: Row(children: [
                                  Text("리뷰보기", style: TextStyle(fontSize: 10)),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 10,
                                  )
                                ]),
                              )
                            ],
                          )
                        ]),
                  ),
                ),
              )
            ]);
          },
        );
      });
    } else {
      for (var data in mapmarkers) {
        if (data.id.toString() == markerId) {
          reviewfetchData(data.location).then((data) {
            setState(() {
              reviews = data;
            });
          });
          favoritefetchData().then((data) {
            setState(() {
              favorite = data!;
            });
          });
          islike(data.location);
          var location = data.location;
          Future.delayed(Duration(milliseconds: 250), (){
            showDialog(
              context: context,
              barrierDismissible: true,
              barrierColor: Colors.white.withOpacity(0.0),
              builder: (BuildContext context) {
                return Stack(children: [
                  Positioned(
                    top: MediaQuery.of(context).size.height - 250,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      content: SizedOverflowBox(
                        size: const Size(280, 70),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "${data.location.replaceFirst('경남 진주시 ', '')}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Row(
                                    children: [
                                      LikeButton(
                                        isLiked: Provider.of<LikeProvider>(
                                                        context,
                                                        listen: false)
                                                    .isLiked ==
                                                true
                                            ? true
                                            : false,
                                        likeBuilder: (bool isLiked) {
                                          return Icon(
                                            Icons.favorite,
                                            color: isLiked
                                                ? Colors.red
                                                : Colors.grey,
                                            size: 20,
                                          );
                                        },
                                        onTap: (isLiked) => onLikeButtonTapped(
                                            Provider.of<LikeProvider>(context,
                                                    listen: false)
                                                .isLiked,
                                            data.location,
                                            data.posx,
                                            data.posy),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '${NumberFormat("#.#").format(data.totalgrade/4)}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '(리뷰 ${data.reviewCount})',
                                        style: TextStyle(fontSize: 10),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${data.location}",
                                      style: TextStyle(fontSize: 12)),
                                  RatingBarIndicator(
                                    rating: data.totalgrade / (4 *data.reviewCount),
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 12.0,
                                    direction: Axis.horizontal,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "",
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        bottom_sheetdata(
                                            location, data.posx, data.posy);
                                      },
                                      child: Row(children: [
                                        Text("리뷰보기",
                                            style: TextStyle(fontSize: 10)),
                                        Icon(
                                          Icons.chevron_right,
                                          size: 10,
                                        )
                                      ]),
                                    )
                                  ])
                            ]),
                      ),
                    ),
                  )
                ]);
              },
            );
          });
        }
      }
    }
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
    Provider.of<LikeProvider>(context, listen: false).toggleLike();
    return isLiked;
  }

  bottom_sheetdata(String location, double lat, double lng) {
    showModalBottomSheet(
      barrierColor: Colors.white.withOpacity(0.0),
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.grey, width: 1),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75, // 원하는 높이로 조절합니다.
          child: MyBottomSheet(location, lat, lng),
        );
      },
    );
  }

  bottom_sheet(String markerid) {
    if (markerid == 'maId') {
      showModalBottomSheet(
          barrierColor: Colors.white.withOpacity(0.0),
          isScrollControlled: true,
          useRootNavigator: true,
          useSafeArea: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.grey, width: 1),
          ),
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${_location.replaceFirst('경남 진주시 ', '')}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          LikeButton(
                            isLiked: Provider.of<LikeProvider>(context,
                                            listen: false)
                                        .isLiked ==
                                    true
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
                                Provider.of<LikeProvider>(context,
                                        listen: false)
                                    .isLiked,
                                roadaddress,
                                kakaoLatitude,
                                kakaoLongitude),
                          ),
                          SizedBox(width: 20),
                          Text(
                            '0.0',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '(리뷰 0)',
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
                      Text("${_location}", style: TextStyle(fontSize: 12)),
                      RatingBarIndicator(
                        rating: 0,
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
                    thickness: 1,
                  ),
                  SizedBox(height: 10),
                  Text("리뷰",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Center(
                      child: Container(
                    padding: EdgeInsets.only(top: 110),
                    child: Text(
                      '리뷰가 없어요 😥',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )),
                ],
              ),
            );
          });
    } else {
      showModalBottomSheet(
          barrierColor: Colors.white.withOpacity(0.0),
          isScrollControlled: true,
          useRootNavigator: true,
          useSafeArea: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.grey, width: 1),
          ),
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${removeaddress}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          LikeButton(
                            isLiked: Provider.of<LikeProvider>(context,
                                            listen: false)
                                        .isLiked ==
                                    true
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
                                Provider.of<LikeProvider>(context,
                                        listen: false)
                                    .isLiked,
                                roadaddress,
                                kakaoLatitude,
                                kakaoLongitude),
                          ),
                          SizedBox(width: 20),
                          Text(
                            '0.0',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '(리뷰 0)',
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
                      Text("${roadaddress}", style: TextStyle(fontSize: 12)),
                      RatingBarIndicator(
                        rating: 0,
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
                    thickness: 1,
                  ),
                  SizedBox(height: 10),
                  Text("리뷰",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Center(
                      child: Container(
                    padding: EdgeInsets.only(top: 110),
                    child: Text(
                      '리뷰가 없어요 😥',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )),
                ],
              ),
            );
          });
    }
  }

  void removeMarker() {
    final markerId = 'markerId'; // 지우고자 하는 MarkerId
    setState(() {
      markers.removeWhere((marker) => marker.markerId == markerId);
    });
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
