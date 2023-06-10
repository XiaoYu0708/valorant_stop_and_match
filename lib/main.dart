import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

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
  var play_im_data = '請先輸入玩家資訊';
  var jsonData;

  String city = '';
  String response = '';
  String playersmallCardImageUrl = 'https://media.valorant-api.com/playercards/9fb348bc-41a0-91ad-8a3e-818035c4e561/displayicon.png';
  String playerrankImageUrl = 'https://media.valorant-api.com/competitivetiers/564d8e28-c226-3180-6285-e48a390db8b1/0/smallicon.png';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        // Define the default font family.
        fontFamily: 'Georgia',
        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Valorant Address"),
          backgroundColor: Colors.black,
        ),
        body: Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: gameNameedit,
                decoration: const InputDecoration(hintText: "請輸入玩家名稱"),
              ),
              TextField(
                controller: tagLineedit,
                decoration: const InputDecoration(hintText: "請輸入玩家標籤(不須輸入#)"),
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900],
                  ),
                  onPressed: () {
                    buttonclick_getplayer_im();
                  },
                  child: const Text("取得玩家資訊"),
                ),
              ),
              SizedBox(height: 20), // 添加垂直间距
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: Image.network(
                      playersmallCardImageUrl,
                      width: 90.0,
                      height: 90.0,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      play_im_data,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    child: Image.network(
                      playerrankImageUrl,
                      width: 90.0,
                      height: 90.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toast(msg){
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void getplayer_match_history() async {  //抓取玩家歷史戰績
    try {
      final response = await http.get(Uri.parse('https://api.henrikdev.xyz/valorant/v3/matches/${city.toString()}/${gameName.toString()}/${tagLine.toString()}'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        for(var i=0;i<5;i++){
          String myteam = '';
          if(jsonData['data'][i]['metadata']['mode']!='Deathmatch'){
            for(var j=0;j<10;j++){
              String jname = jsonData['data'][i]['players']['all_players'][j]['name'];
              String jtag = jsonData['data'][i]['players']['all_players'][j]['tag'];

              if( jname.toString() == gameName && jtag.toString() == tagLine){
                myteam = jsonData['data'][i]['players']['all_players'][j]['team'];
              }
            }

            Map<String, dynamic> teams = await jsonData['data'][i]['teams'];
            print(teams[myteam]);

            if (teams[myteam] != null) {
              print(teams[myteam]['has_won']);
            } else {
              print('No team found');
            }
          }else{
            print('Deathmatch');
          }
        }

        setState(() {

        });
        toast("資料更新完成");
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<String> getplayer_mmr() async {  //抓取玩家牌位
    try {
      final response = await http.get(Uri.parse('https://api.henrikdev.xyz/valorant/v1/mmr/${city.toString()}/${gameName.toString()}/${tagLine.toString()}'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        String? currenttierpatched = jsonData['data']['currenttierpatched'];
        String? smallCardImageUrl = jsonData['data']['images']?['small'];
        int? ranking_in_tier = jsonData['data']['ranking_in_tier'];

        setState(() {
          play_im_data = '${play_im_data.toString()}\n牌位：${currenttierpatched.toString()}\n競技分數：${ranking_in_tier.toString()}';
          playerrankImageUrl = smallCardImageUrl.toString();
        });

        return '牌位：${currenttierpatched.toString()}\n競技分數：${ranking_in_tier.toString()}';

      } else {
        print('Request failed with status: ${response.statusCode}');
        return "Request failed with status: ${response.statusCode}";
      }
    } catch (error) {
      print('Error: $error');
      return "Error: $error";
    }
  }

  void buttonclick_getplayer_im() async {
    try {
      setState(() {
        playersmallCardImageUrl = 'https://media.valorant-api.com/playercards/9fb348bc-41a0-91ad-8a3e-818035c4e561/displayicon.png';
        playerrankImageUrl = 'https://media.valorant-api.com/competitivetiers/564d8e28-c226-3180-6285-e48a390db8b1/0/smallicon.png';
        play_im_data = "請先輸入玩家資訊";
      });

      if(gameNameedit.text == "" || tagLineedit.text == ""){
        toast("請先輸入玩家資訊");
        return;
      }

      toast("資料驗證中");

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

        city = region.toString();

        String mmr = await getplayer_mmr();

        getplayer_match_history();

        setState(() {
          play_im_data = '伺服器：${region.toString()}\n帳號名稱：${name.toString()}\n標籤：#${tag.toString()}\n等級：${accountLevel.toString()}\n${mmr.toString()}';
          playersmallCardImageUrl = smallCardImageUrl.toString();
        });

        toast("驗證成功");
      } else {
          toast("錯誤!找不到該玩家");
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }


}
