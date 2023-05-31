import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title; //외부에서 입력받기 위함
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.title, //외부에서 입력받기 위함
    this.bottomNavigationBar,
    this.appBar,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  //앱바
  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 1, //튀어나오는 효과
        title: Text(
          title!,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        foregroundColor: Colors.black, //앱바 위젯들의 색깔
      );
    }
  }
}
