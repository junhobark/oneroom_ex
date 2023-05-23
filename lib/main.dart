import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:oneroom_ex/login/loginpage.dart';
import 'login/loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AuthRepository.initialize(appKey: '06fa866ad2a59ae0dfba2b8c9d47a578');
  runApp(_App());
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get.put(LocationController());
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Loading();
          }
          return const SampleScreen();
        },
      ),
    );
  }
}
