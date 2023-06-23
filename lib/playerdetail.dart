import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'matchdetail.dart';
import 'package:Valorant_Match/dhn.dart';

class playerdt extends StatefulWidget {
  final String gameNameedit;
  final String tagLineedit;

  const playerdt({
    Key? key,
    required this.gameNameedit,
    required this.tagLineedit,
  }) : super(key: key);

  @override
  State<playerdt> createState() => _playerdtState();
}

String gameName = ""; //PlayerName
String tagLine = ""; //PlayerTag

String puuid = ''; //player puuid

class _playerdtState extends State<playerdt> {
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
          title: const Text("Player Detail"),
          backgroundColor: Colors.black,
        ),
        body: Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.all(10),
          child: ListView(
            children: [
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
          ['特務', '地圖', '模式', '比數', 'K', 'D', 'A', '勝敗']
        ]; //特務,地圖,模式,比數,K,D,A,勝敗

        List<String> matchsid = [];

        for (var i = 0; i < jsonData['data'].length; i++) {
          matchsid.add(jsonData['data'][i]['metadata']['matchid']);
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

            if(map[jmap.toString().toLowerCase()]!=null){
              jmap = map[jmap.toString().toLowerCase()];
            }

            if(mode[jmode.toString().toLowerCase()]!=null){
              jmode = mode[jmode.toString().toLowerCase()];
            }



            if (puuid.toString() == jpuuid.toString()) {
              if (jsonData['data'][i]['metadata']['mode'] == "Deathmatch") {
                List<int> playerskills = [];

                for(int ts=0;ts < jsonData['data'][i]['players']['all_players'].length;ts++){
                  playerskills.add(jsonData['data'][i]['players']['all_players'][ts]['stats']['kills']);
                }

                int? matchmaxkills = playerskills.reduce((value, element) => value > element ? value : element);
                String? myteamscore = '${matchmaxkills.toString()} : ${jk.toString()}';

                tableData.add([
                  jagentimg.toString(),
                  jmap.toString(),
                  jmode.toString(),
                  myteamscore.toString(),
                  jk.toString(),
                  jd.toString(),
                  ja.toString(),
                  '',
                ]);
              } else {
                myteam =
                jsonData['data'][i]['players']['all_players'][j]['team'];
                myteam = myteam.toLowerCase();
                String? myteamscore = '${jsonData['data'][i]['teams'][myteam]['rounds_won']} : ${jsonData['data'][i]['teams'][myteam]['rounds_lost']}';
                String? elsmodewinloss = '';

                if (jsonData['data'][i]['teams'][myteam]['has_won'] == true) {
                  elsmodewinloss = 'Win';
                }else{
                  elsmodewinloss = 'Loss';
                }

                tableData.add([
                  jagentimg.toString(),
                  jmap.toString(),
                  jmode.toString(),
                  myteamscore.toString(),
                  jk.toString(),
                  jd.toString(),
                  ja.toString(),
                  elsmodewinloss.toString(),
                ]);
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

          if (!rowData.contains("Win") && !rowData.contains("Loss") && !rowData.contains("死鬥模式")) {
            matchtableRows.add(
              TableRow(
                children: cells,
              ),
            );
          }else if(rowData.contains("死鬥模式")){
            matchtableRows.add(
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.green[200],
                ),
                children: cells.map((Widget cell) {
                  int index = tableData.indexOf(rowData) - 1;
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => matchdtl(matchid: matchsid[index],titlerowData:[rowData[1],rowData[2],rowData[3]],gameName:gameName,tagLine:tagLine),
                          ),
                        );
                      },
                      child: cell,
                  );
                }).toList(),
              ),
            );

          }else if (rowData.contains("Win")) {
            matchtableRows.add(
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.green[300],
                ),
                children: cells.map((Widget cell) {
                  int index = tableData.indexOf(rowData) - 1;
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => matchdtl(matchid: matchsid[index],titlerowData:[rowData[1],rowData[2],rowData[3]],gameName:gameName,tagLine:tagLine),
                        ),
                      );
                    },
                    child: cell,
                  );
                }).toList(),
              ),
            );

          } else if (rowData.contains("Loss")) {
            matchtableRows.add(
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.red[300],
                ),
                children: cells.map((Widget cell) {
                  int index = tableData.indexOf(rowData) - 1;
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => matchdtl(matchid: matchsid[index],titlerowData:[rowData[1],rowData[2],rowData[3]],gameName:gameName,tagLine:tagLine),
                        ),
                      );
                    },
                    child: cell,
                  );
                }).toList(),
              ),
            );
          }
        }
        toast("資料更新完成");
        setState(() {

        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      toast("抓取玩家歷史戰績錯誤");
    } finally {
      setState(() {
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

  void pagefirstrun() async {
    try {
      setState(() {
        playersmallCardImageUrl =
        'https://media.valorant-api.com/playercards/9fb348bc-41a0-91ad-8a3e-818035c4e561/displayicon.png';
        playerrankImageUrl =
        'https://media.valorant-api.com/competitivetiers/564d8e28-c226-3180-6285-e48a390db8b1/0/smallicon.png';
        play_im_data = "請先輸入玩家資訊";
        matchtableRows.clear();
      });

      gameName = widget.gameNameedit.toString();
      tagLine = widget.tagLineedit.toString();

      toast("資料驗證中");

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

        setState(() {
          play_im_data =
          '伺服器：${region.toString()}\n帳號名稱：${name.toString()}\n標籤：#${tag.toString()}\n等級：${accountLevel.toString()}\n${mmr.toString()}';
          playersmallCardImageUrl = smallCardImageUrl.toString();
        });
        toast("驗證成功");
      } else {
        toast("錯誤!找不到該玩家");
        print('Request failed with status: ${response.statusCode}');
        setState(() {
        });
      }
    } catch (error) {
      toast("抓取玩家資料錯誤");
      print('Error: $error');
      setState(() {
      });
    }
  }
  void initState() {
    super.initState();
    // 在这里执行您的函数
    pagefirstrun();
  }
}

