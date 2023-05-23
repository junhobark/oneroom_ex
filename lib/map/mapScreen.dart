import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:oneroom_ex/common/default_layout.dart';
import 'package:oneroom_ex/map/review1.dart';
import 'package:kpostal/kpostal.dart';
import 'package:like_button/like_button.dart';

const String kakaoMapKey = '06fa866ad2a59ae0dfba2b8c9d47a578';

class mapScreen extends StatefulWidget {
  mapScreen({required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;
  @override
  State<mapScreen> createState() => _mapScreenState();
}

class _mapScreenState extends State<mapScreen> {
  late KakaoMapController mapController;
  Set<Marker> markers = {};
  late var model;
  var selectedPlace = null;
  final TextEditingController _AddressController = TextEditingController();
  String roadaddress = '';
  String jibunaddress = '';
  String removeaddress = '';
  String kakaoLatitude = '';
  String kakaoLongitude = '';
  bool draggable = true;
  bool zoomable = true;
  String mark_id = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double latitude = widget.latitude;
    double longitude = widget.longitude;

    return DefaultLayout(
      child: Stack(
        children: [
          KakaoMap(
              onMapCreated: ((KakaoMapController controller) async {
                mapController = controller;
              }),
              markers: markers.toList(),
              currentLevel: 1,
              onMarkerTap: (markerId, latLng, zoomLevel) {
                map_showDialog();
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
          // const MapBottomSheet()
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
      if (selectedPlace != null) {
        mapController.panTo(LatLng(lat, lng));

        markers.add(Marker(
          markerId: 'markerId',
          latLng: LatLng(lat, lng),
        ));
        map_showDialog();
      }
    }
  }

  map_showDialog() {
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
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          LikeButton(
                            size: 20,
                          ),
                        ],
                      ),
                      Text("${roadaddress}", style: TextStyle(fontSize: 12)),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${jibunaddress}",
                                style: TextStyle(fontSize: 12)),
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
                          ])
                    ]),
              ),
            ),
          )
        ]);
      },
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  LikeButton(
                    size: 20,
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text("${roadaddress}", style: TextStyle(fontSize: 12)),
              Text("${jibunaddress}", style: TextStyle(fontSize: 12)),
              SizedBox(height: 20),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              SizedBox(height: 10),
              Text("리뷰",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            ],
          ),
        );
      },
    );
  }

  void removeMarker() {
    final markerId = 'markerId'; // 지우고자 하는 MarkerId
    setState(() {
      markers.removeWhere((marker) => marker.markerId == markerId);
    });
  }
}
