import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kpostal/kpostal.dart';
import 'package:oneroom_ex/map/review2.dart';
import 'package:oneroom_ex/map/review_detail/review1_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'mapScreen.dart';

class ReviewScreen1 extends StatefulWidget {
  const ReviewScreen1({Key? key}) : super(key: key);

  @override
  State<ReviewScreen1> createState() => _ReviewScreen1State();
}

class _ReviewScreen1State extends State<ReviewScreen1> {
  final InputController = TextEditingController();
  var model = null;
  String roadaddress = '';
  double kakaoLatitude = 0;
  double kakaoLongitude = 0;
  double review_lessor = 0;
  double review_quality = 0;
  double review_area = 0;
  double review_noise = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          '리뷰 작성(1/2)',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Provider.of<REVIEWProvider>(context, listen: false).setall(
                review_noise = 0,
                review_area = 0,
                review_lessor = 0,
                review_quality = 0);
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
              padding: EdgeInsets.all(30),
              child: Column(children: [
                Row(children: [
                  Text("주소",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                ]),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 270,
                        height: 60,
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: '주소를 입력해주세요',
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0)),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0)),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0)),
                            ),
                          ),
                          controller: InputController,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.search),
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          _addressAPI();
                        },
                      )
                    ],
                  ),
                  height: 100,
                ),
                SizedBox(
                  height: 10,
                ),
              ])),
          Divider(
            thickness: 5,
          ),
          Container(
            padding: EdgeInsets.all(30),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Row(children: [
                Text(
                  "※만족도를 평가해주세요!",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ]),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("임대인 소통", style: TextStyle(fontSize: 20)),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      review_lessor = rating;
                      Provider.of<REVIEWProvider>(context, listen: false)
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("소음", style: TextStyle(fontSize: 20)),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      review_noise = rating;
                      Provider.of<REVIEWProvider>(context, listen: false)
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("시설", style: TextStyle(fontSize: 20)),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      review_quality = rating;
                      Provider.of<REVIEWProvider>(context, listen: false)
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("면적", style: TextStyle(fontSize: 20)),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      review_area = rating;
                      Provider.of<REVIEWProvider>(context, listen: false)
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
                onPressed: roadaddress == '' ||
                        (Provider.of<REVIEWProvider>(context).review_area) ==
                            0 ||
                        (Provider.of<REVIEWProvider>(context).review_lessor) ==
                            0 ||
                        (Provider.of<REVIEWProvider>(context).review_noise) ==
                            0 ||
                        (Provider.of<REVIEWProvider>(context).review_quality) ==
                            0
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return ReviewScreen2(
                                roadaddress,
                                kakaoLongitude,
                                kakaoLatitude,
                                review_area,
                                review_lessor,
                                review_noise,
                                review_quality);
                          }),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text("다음 단계", style: TextStyle(fontSize: 16)),
              ),
            ]),
          )
        ]),
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
              this.kakaoLatitude = result.kakaoLatitude!;
              this.kakaoLongitude = result.kakaoLongitude!;
            });
          },
        ),
      ),
    );
    if (model != null) {
      InputController.text = '${roadaddress}';
    }
  }
}
