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
  var data = '請先輸入玩家資訊';
  var jsonData;

  String City = '';
  String response = '';
  String playersmallCardImageUrl = 'https://media.valorant-api.com/playercards/9fb348bc-41a0-91ad-8a3e-818035c4e561/displayicon.png';

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
            alignment: Alignment.centerLeft,
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
                              decoration: const InputDecoration(hintText: "請輸入玩家標籤(不須輸入#)",),
                            ),
                            ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            onPressed: () {
                              buttonclick_getplayer_im();
                            },
                            child: const Text("取得玩家資訊"),
                          ),
                          ]
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10.0),
                            child: Image.network(
                              playersmallCardImageUrl,
                              width: 90.0,
                              height: 90.0,
                            ),
                          ),
                          Text(
                            data,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      )
    );
  }

  void buttonclick_getplayer_im() async {
    try {
      setState(() {
        playersmallCardImageUrl = 'https://media.valorant-api.com/playercards/9fb348bc-41a0-91ad-8a3e-818035c4e561/displayicon.png';
        data = "請先輸入玩家資訊";
      });

      if(gameNameedit.text == "" || tagLineedit.text == ""){
        return;
      }

      gameName = gameNameedit.text;
      tagLine = tagLineedit.text;

      final response = await http.get(Uri.parse('https://api.henrikdev.xyz/valorant/v1/account/${gameName.toString()}/${tagLine.toString()}?force=true'));


      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        String? puuid = jsonData['data']['puuid'];
        String? region = jsonData['data']['region'];
        int? accountLevel = jsonData['data']['account_level'];
        String? name = jsonData['data']['name'];
        String? tag = jsonData['data']['tag'];
        String? smallCardImageUrl = jsonData['data']['card']?['small'];
        String? largeCardImageUrl = jsonData['data']['card']?['large'];
        String? wideCardImageUrl = jsonData['data']['card']?['wide'];
        String? cardId = jsonData['data']['card']?['id'];
        String? lastUpdate = jsonData['last_update'];
        int? lastUpdateRaw = jsonData['last_update_raw'];

        setState(() {
          City = region.toString();
          playersmallCardImageUrl = smallCardImageUrl.toString();
          data = '帳號名稱：${name.toString()}\n標籤：#${tag.toString()}\n等級：${accountLevel.toString()}';
          print(data);
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


}
