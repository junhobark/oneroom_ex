import 'package:flutter/material.dart';
import 'package:oneroom_ex/map/review2.dart';

import '../common/default_layout.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewScreen1 extends StatelessWidget {
  const ReviewScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '리뷰 작성(1/2)',
      child: SafeArea(
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
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), //모서리를 둥글게
                      border: Border.all(color: Colors.black, width: 2)),
                  height: 120,
                ),
                SizedBox(
                  height: 20,
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
                      return const ReviewScreen2();
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
}
