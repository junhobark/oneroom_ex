import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:oneroom_ex/common/default_layout.dart';
import 'package:oneroom_ex/map/map_markers.dart';
import 'package:oneroom_ex/map/review1.dart';
import 'package:kpostal/kpostal.dart';
import 'package:like_button/like_button.dart';
import 'package:http/http.dart' as http;
import 'bottomsheet.dart';
import 'review_detail/review_class.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

const String kakaoMapKey = '06fa866ad2a59ae0dfba2b8c9d47a578';

class mapScreen extends StatefulWidget {
  mapScreen({required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;
  @override
  State<mapScreen> createState() => _mapScreenState();
}

class _mapScreenState extends State<mapScreen> {
  String jsonData = '';
  List<Mapmarkers> mapmarkers = [];
  List<Reviewdetail> reviews = [];

  Future<List<Mapmarkers>> markerfetchData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/map/test'));
    if (response.statusCode == 200) {
      print('응답했다1');
      print(utf8.decode(response.bodyBytes));
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      return data.map((item) => Mapmarkers.fromJson(item)).toList();
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<List<Reviewdetail>> reviewfetchData(location) async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8080/map/${location}/detail'));
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
  List<Marker> markers = [];
  var model = null;
  var selectedPlace = null;
  final TextEditingController _AddressController = TextEditingController();
  String roadaddress = '';
  String jibunaddress = '';
  String removeaddress = '';
  String kakaoLatitude = '';
  String kakaoLongitude = '';
  bool draggable = true;
  bool zoomable = true;

  @override
  void initState() {
    super.initState();
    markerfetchData().then((data) {
      setState(() {
        mapmarkers = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double latitude = widget.latitude;
    double longitude = widget.longitude;

    return DefaultLayout(
      child: Stack(
        children: [
          KakaoMap(
              onMapCreated: ((controller) async {
                mapController = controller;
                setState(() {
                  mapmarkers.map((data) {
                    markers.add(Marker(
                        markerId: data.id.toString(),
                        latLng: LatLng(data.posx, data.posy),
                        markerImageSrc:
                            'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png'));
                  }).toList();
                });
              }),
              markers: markers.toList(),
              currentLevel: 1,
              onMarkerTap: (markerId, latLng, zoomLevel) {
                map_showDialog(markerId);
              },
              center: LatLng(latitude, longitude)),
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
                    color: Theme.of(context).textTheme.bodyText1!.color,
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const ReviewScreen1();
                      }),
                    );
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
    var model = await Navigator.push(
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
              this.kakaoLatitude = result.kakaoLatitude.toString();
              this.kakaoLongitude = result.kakaoLongitude.toString();
              removeaddress = roadaddress.replaceFirst('경남 진주시 ', '');
            });
          },
        ),
      ),
    );
    if (model != null) {
      _AddressController.text = '${roadaddress}';
      selectedPlace = roadaddress;
      var lat = double.parse(kakaoLatitude);
      var lng = double.parse(kakaoLongitude);
      int cn = 0;
      if (selectedPlace != null) {
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
  }

  map_showDialog(
    String markerId,
  ) {
    if (markerId == 'markerId') {
      Future.delayed(Duration(milliseconds: 150), () {
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
                                    size: 20,
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
                                  bottom_sheet();
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
          print('${data.location}');
          var location = data.location;
          Future.delayed(Duration(milliseconds: 100), () {
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
                                        size: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '${NumberFormat("#.#").format(totalgrade() / 4)}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '(리뷰 ${totalcount()})',
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
                                    rating: totalgrade() / 4,
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
                                        bottom_sheetdata(location);
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
      grade = data.building.totalgrade;
    }
    return grade;
  }

  bottom_sheetdata(String location) {
    showModalBottomSheet(
      barrierColor: Colors.white.withOpacity(0.0),
      isScrollControlled: false,
      useRootNavigator: true,
      useSafeArea: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(color: Colors.grey, width: 1),
      ),
      context: context,
      builder: (BuildContext context) => MyBottomSheet(location),
    );
  }

  bottom_sheet() {
    showModalBottomSheet(
        barrierColor: Colors.white.withOpacity(0.0),
        isScrollControlled: false,
        useRootNavigator: true,
        useSafeArea: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: Colors.grey, width: 1),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
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
                          size: 20,
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
                Text("${jibunaddress}", style: TextStyle(fontSize: 12)),
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

  void removeMarker() {
    final markerId = 'markerId'; // 지우고자 하는 MarkerId
    setState(() {
      markers.removeWhere((marker) => marker.markerId == markerId);
    });
  }
}
