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

String gameName = ""; //PlayerName
String tagLine = "";  //PlayerTag

String apikey = 'RGAPI-2cf9ca1a-96b5-45a8-8b28-8ee44a7f81a5'; //Dev ApiKey
String puuid = '';  //player puuid

class _MyAppState extends State<MyApp> {
  TextEditingController gameNameedit = TextEditingController();
  TextEditingController tagLineedit = TextEditingController();
  var data = '';
  dynamic jsonData;
    String response = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Valorant Address"),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child:Container(
            margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children:[
                            TextField(
                              controller: gameNameedit,
                              decoration: const InputDecoration(hintText: "請輸入玩家名稱"),
                            ),
                            TextField(
                              controller: tagLineedit,
                              decoration: const InputDecoration(hintText: "請輸入玩家標籤",),
                            ),
                            ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            onPressed: () {
                              getpuuid();
                            },
                            child: const Text("取得玩家資訊"),
                          ),
                          ]
                        ),
                      ),
                      Text(data),
                    ],
                  ),
          ),
        ),
      )
    );
  }

  void getpuuid() async {
    try {
      setState(() {
        data = "";
      });

      if(gameNameedit.text == "" || tagLineedit.text == ""){
        return;
      }

      gameName = gameNameedit.text;
      tagLine = tagLineedit.text;

      final response = await http.get(Uri.parse('https://asia.api.riotgames.com/riot/account/v1/accounts/by-riot-id/${gameName}/${tagLine}?api_key=${apikey}'));
      if (response.statusCode == 200) {
        jsonData = jsonDecode(response.body); // 更新 jsonData

        setState(() {
          puuid = jsonData['puuid'];
          data = 'puuid:\n${puuid.toString()}\n\ngameName:\n${gameName.toString()}\n\ntagLine:\n${tagLine.toString()}';
          print('${jsonData['puuid']}\n${jsonData['gameName']}\n${jsonData['tagLine']}');
        });
      } else {
        setState(() {
          data = "錯誤!找不到該玩家";
        });
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void post() async {
    try {
      final url = Uri.parse('');
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
            data = newData.toString();
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
