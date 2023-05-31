import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:oneroom_ex/login/loginpage.dart';
import 'login/loading.dart';
import 'login/uid_provider.dart';
import 'login/users.dart';
import 'map/review_detail/review1_provider.dart';
import 'map/review_detail/review2_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AuthRepository.initialize(appKey: '06fa866ad2a59ae0dfba2b8c9d47a578');

  runApp(//<- runApp에 추가하여 MaterialApp 전체에 적용되게 수정한다.
      MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (_) =>
            UIDProvider(location: '', nickname: '', uid: '', valid: '')),
    ChangeNotifierProvider(
        create: (_) => REVIEWProvider(
            review_area: 0,
            review_lessor: 0,
            review_noise: 0,
            review_quality: 0)),
    ChangeNotifierProvider(
        create: (_) => REVIEW2Provider(
              advantage: '',
              weakness: '',
              etc: '',
            ))
  ], child: _App()));
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _uid = '';
    void userfetchData(uid) async {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8080/user/${uid}'));
      if (response.statusCode == 200) {
        print('응답했다3');
        print(utf8.decode(response.bodyBytes));
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print(Users.fromJson(data));
        var _data = Users.fromJson(data);
        Provider.of<UIDProvider>(context, listen: false)
            .setdbToken(_data.nickName, _data.location, _data.valid);
      } else {
        print('Error: ${response.statusCode}');
        throw Exception('Error: ${response.statusCode}');
      }
    }

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User? user = FirebaseAuth.instance.currentUser;
            _uid = user!.uid;
            Provider.of<UIDProvider>(context, listen: false)
                .setAccessToken(_uid);
            Future.delayed(Duration(seconds: 3), () {
              userfetchData(_uid);
            });
            return Loading();
          }

          return const SampleScreen();
        },
      ),
    );
  }
}
