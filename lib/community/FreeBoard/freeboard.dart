import 'package:flutter/material.dart';
import 'package:oneroom_ex/community/FreeBoard/board_list.dart';
import 'package:oneroom_ex/community/FreeBoard/board_write.dart';
import 'package:oneroom_ex/community/FreeBoard/popular_board.dart';
import '../communityScreen_Search.dart';

class FreeBoardScreen extends StatelessWidget {
  const FreeBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          '자유게시판',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => CommunitySearchScreen(),
                ),
              );
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => BoardWrite(),
                ),
              );
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PopularBoard(
                popularContentTitle: '인기글 제목', popularContent: '인기글 내용'),
            Expanded(
              child: ListView.builder(
                  //itemCount - 보여줄 개수
                  //미리 그리지 않고 스크롤 내리면 보여줌 = 메모리 유리
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return BoardList(
                      contentTitle: '자유글 제목',
                      content: '자유글 내용',
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
