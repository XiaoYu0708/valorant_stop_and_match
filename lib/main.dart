import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    home: MyApp()
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> data = [];
  dynamic jsonData;

  String shard = 'ap';
  String puuid = '7603c738-ef8b-4f98-9138-654f484bc539';

  String response = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Page1 Header"),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child:Container(
            margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Center(
                        child: Text(data.toString()),
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          onPressed: () {
                            get();
                          },
                          child: const Text("Button"),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      )
    );
  }

  Future<void> get() async {
    try {
      final response = await http.get(Uri.parse('https://ap.api.riotgames.com/val/content/v1/contents?locale=zh-TW&api_key=RGAPI-2cf9ca1a-96b5-45a8-8b28-8ee44a7f81a5'));
      if (response.statusCode == 200) {
        jsonData = jsonDecode(response.body); // 更新 jsonData

        final List<dynamic> dataList = jsonData['data'];

        List<String> newData = [];
        for (var item in dataList) {
          newData.add(item['displayName']+"\n");
        }

        setState(() {
          data = newData;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> post() async {
    try {
      final url = Uri.parse('https://ap.api.riotgames.com/val/content/v1/contents?locale=zh-TW&api_key=RGAPI-2cf9ca1a-96b5-45a8-8b28-8ee44a7f81a5');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer riot_auth_token',
        'X-Riot-Entitlements-JWT': 'riot_entitlement_token'
      };
      final body = {
        'DisplayName': '',
        'Subject': 'PLAYER_ID_SHOULD_BE_HERE',
        'GameName': '',
        'TagLine': ''
      };

      final response = await http.post(
          url, headers: headers, body: body);

      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.body);

          final List<dynamic> dataList = jsonData['data'];

          List<String> newData = [];
          for (var item in dataList) {
            newData.add(item['displayName']+"\n");
          }

          setState(() {
            data = newData;
          });
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
