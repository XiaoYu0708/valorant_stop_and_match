import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

String gameName = ""; //PlayerName
String tagLine = ""; //PlayerTag

String apikey = 'RGAPI-2cf9ca1a-96b5-45a8-8b28-8ee44a7f81a5'; //Dev ApiKey
String puuid = ''; //player puuid

Map<String, String> map = {
  "bind": "劫境之地",
  "haven": "遺落境地",
  "split": "雙塔迷城",
  "ascent": "義境空島",
  "icebox": "極地寒港",
  "breeze": "熱帶樂園",
  "fracture": "天漠之峽",
  "pearl": "深海遺珠",
  "lotus": "蓮華古城",
};

Map<String, String> mode = {
  "unrated": "一般模式",
  "competitive": "競技模式",
  "spike rush": "輻能搶攻戰",
  "deathmatch": "死鬥模式",
  "escalation": "超激進戰",
  "replication": "複製亂戰",
  "snowballfight": "打雪仗",
  "swiftplay": "超速衝點",
  "custom game": "自訂模式",
};

class _MyAppState extends State<MyApp> {
  TextEditingController gameNameedit = TextEditingController();
  TextEditingController tagLineedit = TextEditingController();
  bool isButtonDisabled = false;

  var play_im_data = '請先輸入玩家資訊';
  var jsonData;

  String? puuid = '';
  String city = '';
  String response = '';
  String playersmallCardImageUrl =
      'https://media.valorant-api.com/playercards/9fb348bc-41a0-91ad-8a3e-818035c4e561/displayicon.png';
  String playerrankImageUrl =
      'https://media.valorant-api.com/competitivetiers/564d8e28-c226-3180-6285-e48a390db8b1/0/smallicon.png';

  List<TableRow> matchtableRows = [];

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
          child: ListView(
            children: [
              TextField(
                controller: gameNameedit,
                decoration: const InputDecoration(hintText: "請輸入玩家名稱"),
              ),
              TextField(
                controller: tagLineedit,
                decoration: const InputDecoration(hintText: "請輸入玩家標籤(不須輸入#)"),
              ),
              const Text(""),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900],
                  ),
                  onPressed: isButtonDisabled
                      ? null
                      : () {
                          buttonclick_getplayer_im();
                        },
                  child: const Text("取得玩家資訊"),
                ),
              ),
              const SizedBox(height: 20), // 添加垂直间距
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10.0),
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
                  Image.network(
                    playerrankImageUrl,
                    width: 90.0,
                    height: 90.0,
                  ),
                ],
              ),
              Table(
                columnWidths: const {
                  0: IntrinsicColumnWidth(), // 列寬度設定為自動調整
                  1: IntrinsicColumnWidth(), // 列寬度設定為自動調整
                  2: IntrinsicColumnWidth(), // 列寬度設定為自動調整
                  3: IntrinsicColumnWidth(), // 列寬度設定為自動調整
                  4: IntrinsicColumnWidth(), // 列寬度設定為自動調整
                  5: IntrinsicColumnWidth(), // 列寬度設定為自動調整
                  6: IntrinsicColumnWidth(), // 列寬度設定為自動調整
                  7: IntrinsicColumnWidth(), // 列寬度設定為自動調整
                },
                border: TableBorder.all(color: Colors.transparent),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: matchtableRows,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toast(msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void getplayer_match_history() async {
    //抓取玩家歷史戰績
    try {
      final response = await http.get(Uri.parse(
          'https://api.henrikdev.xyz/valorant/v3/by-puuid/matches/${city.toString()}/${puuid.toString()}?size=10'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        String myteam = '';

        List<List<String>> tableData = [
          ['特務', '地圖', '模式', 'K', 'D', 'A', 'KD', '勝敗']
        ]; //特務,地圖,模式,K,D,A,KD,勝敗

        for (var i = 0; i < jsonData['data'].length; i++) {
          for (var j = 0;
              j < jsonData['data'][i]['players']['all_players'].length;
              j++) {
            String? jmap = jsonData['data'][i]['metadata']['map'];
            String? jpuuid =
                jsonData['data'][i]['players']['all_players'][j]['puuid'];
            String? jmode = jsonData['data'][i]['metadata']['mode'];
            String? jagentimg = jsonData['data'][i]['players']['all_players'][j]
                ['assets']['agent']['small'];
            int jk = jsonData['data'][i]['players']['all_players'][j]['stats']
                ['kills'];
            int jd = jsonData['data'][i]['players']['all_players'][j]['stats']
                ['deaths'];
            int ja = jsonData['data'][i]['players']['all_players'][j]['stats']
                ['assists'];

            jmap = map[jmap.toString().toLowerCase()];
            jmode = mode[jmode.toString().toLowerCase()];

            String? jkda = '';

            if (jd == 0) {
              jkda = ((jk.toInt()).toStringAsFixed(1));
            } else {
              jkda = ((jk / jd).toStringAsFixed(1));
            }

            if (puuid.toString() == jpuuid.toString()) {
              if (jsonData['data'][i]['metadata']['mode'] == "Deathmatch") {
                tableData.add([
                  jagentimg.toString(),
                  jmap.toString(),
                  jmode.toString(),
                  jk.toString(),
                  jd.toString(),
                  ja.toString(),
                  jkda.toString(),
                  ''
                ]);
              } else {
                myteam =
                    jsonData['data'][i]['players']['all_players'][j]['team'];
                myteam = myteam.toLowerCase();
                if (jsonData['data'][i]['teams'][myteam]['has_won'] == true) {
                  tableData.add([
                    jagentimg.toString(),
                    jmap.toString(),
                    jmode.toString(),
                    jk.toString(),
                    jd.toString(),
                    ja.toString(),
                    jkda.toString(),
                    'Win'
                  ]);
                } else {
                  tableData.add([
                    jagentimg.toString(),
                    jmap.toString(),
                    jmode.toString(),
                    jk.toString(),
                    jd.toString(),
                    ja.toString(),
                    jkda.toString(),
                    'Loss'
                  ]);
                }
              }
            }
          }
        }

        for (var rowData in tableData) {
          List<Widget> cells = [];
          for (var cellData in rowData) {
            if (cellData.startsWith('http')) {
              cells.add(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Image.network(
                      cellData,
                      width: 30.0,
                      height: 30.0,
                    ),
                  ),
                ),
              );
            } else {
              cells.add(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(cellData),
                  ),
                ),
              );
            }
          }

          if (!rowData.contains("Win") && !rowData.contains("Loss")) {
            matchtableRows.add(
              TableRow(
                children: cells,
              ),
            );
          } else if (rowData.contains("Win")) {
            matchtableRows.add(
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.green[300],
                ),
                children: cells,
              ),
            );
          } else if (rowData.contains("Loss")) {
            matchtableRows.add(
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.red[300],
                ),
                children: cells,
              ),
            );
          }
        }
        toast("資料更新完成");
        setState(() {});
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      toast("抓取玩家歷史戰績錯誤");
    } finally {
      setState(() {
        isButtonDisabled = false;
      });
    }
  }

  Future<String> getplayer_mmr() async {
    //抓取玩家牌位
    try {
      final response = await http.get(Uri.parse(
          'https://api.henrikdev.xyz/valorant/v1/mmr/${city.toString()}/${gameName.toString()}/${tagLine.toString()}'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        String? currenttierpatched = jsonData['data']['currenttierpatched'];
        String? smallCardImageUrl = jsonData['data']['images']?['small'];
        int? rankingInTier = jsonData['data']['ranking_in_tier'];

        playerrankImageUrl = smallCardImageUrl.toString();

        rankingInTier ??= 0;

        return '牌位：${currenttierpatched.toString()}\n競技分數：${rankingInTier.toString()}';
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
        isButtonDisabled = true;
        playersmallCardImageUrl =
            'https://media.valorant-api.com/playercards/9fb348bc-41a0-91ad-8a3e-818035c4e561/displayicon.png';
        playerrankImageUrl =
            'https://media.valorant-api.com/competitivetiers/564d8e28-c226-3180-6285-e48a390db8b1/0/smallicon.png';
        play_im_data = "請先輸入玩家資訊";
        matchtableRows.clear();
      });

      if (gameNameedit.text == "" || tagLineedit.text == "") {
        toast("請先輸入玩家資訊");
        setState(() {
          isButtonDisabled = false;
        });
        return;
      }

      toast("資料驗證中");

      gameName = gameNameedit.text;
      tagLine = tagLineedit.text;

      final response = await http.get(Uri.parse(
          'https://api.henrikdev.xyz/valorant/v1/account/${gameName.toString()}/${tagLine.toString()}?force=true'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        puuid = jsonData['data']['puuid'];
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

        play_im_data =
            '伺服器：${region.toString()}\n帳號名稱：${name.toString()}\n標籤：#${tag.toString()}\n等級：${accountLevel.toString()}\n${mmr.toString()}';
        playersmallCardImageUrl = smallCardImageUrl.toString();

        toast("驗證成功");
      } else {
        toast("錯誤!找不到該玩家");
        print('Request failed with status: ${response.statusCode}');
        setState(() {
          isButtonDisabled = false;
        });
      }
    } catch (error) {
      toast("抓取玩家資料錯誤");
      print('Error: $error');
      setState(() {
        isButtonDisabled = false;
      });
    }
  }
}
