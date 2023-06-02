import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../common/default_layout.dart';
import 'admin_infoclass.dart';

class Adminlist extends StatefulWidget {
  const Adminlist({Key? key}) : super(key: key);

  @override
  State<Adminlist> createState() => _AdminlistState();
}

class _AdminlistState extends State<Adminlist> {
  Future<List<Admininfo>?> admininfofetchData() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/admin'));
      if (response.statusCode == 200) {
        final datadetail =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

        return datadetail.map((item) => Admininfo.fromJson(item)).toList();
      } else {
        print('An error occurred: e');
        throw Exception('An error occurred:');
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '거주지 인증요청',
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: FutureBuilder<List<Admininfo>?>(
            future: admininfofetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Admininfo admin = snapshot.data![index];

                            return ListTile(
                              onTap: () {},
                              title: Container(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 20, right: 20),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 233, 244, 247),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '거주지 인증요청',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text(
                                        '${DateFormat("yy/MM/dd HH:mm").format(admin.createdAt)}'),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return SnackBar(
                  content: Text('error 에러!!'),
                );
              }
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                        '거주지 인증요청이 없어요',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
