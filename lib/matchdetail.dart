import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Valorant_Match/playerdetail.dart';

class matchdtl extends StatefulWidget {
  final String matchid;
  final List<String> titlerowData;
  final String gameName;
  final String tagLine;

  const matchdtl({
    Key? key,
    required this.matchid,
    required this.titlerowData,
    required this.gameName,
    required this.tagLine
  }) : super(key: key);

  @override
  State<matchdtl> createState() => _matchdtlState();
}

class _matchdtlState extends State<matchdtl> {
  List<TableRow> matchtableRows = [];
  List<TableRow> matchtitletableRows = [];

  String? gamestarttime = '';

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
          title: const Text("Match Detail"),
          backgroundColor: Colors.black,
        ),
        body: Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Text(
                widget.titlerowData[2],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.titlerowData[1],
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    widget.titlerowData[0],
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Table(
                columnWidths: const {
                  0: IntrinsicColumnWidth(), // 列寬度設定為自動調整
                  1: IntrinsicColumnWidth(), // 列寬度設定為自動調整
                  2: IntrinsicColumnWidth(), // 列寬度設定為自動調整
                },
                border: TableBorder.all(color: Colors.transparent),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: matchtitletableRows,
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
              Text(gamestarttime.toString()),
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

  void matchdtdw() async {
    //抓取本場詳細資訊
    try {
      final response = await http.get(Uri.parse('https://api.henrikdev.xyz/valorant/v2/match/${widget.matchid.toString()}'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        String myteam = '';

        List<List<String>> tableData = [
          ['特務', '隊伍', '名稱', '標籤', 'K', 'D', 'A', 'KD']
        ]; //特務,隊伍,名稱,標籤,K,D,A

        if(jsonData['data']['metadata']['mode'] == "Deathmatch"){
          tableData = [
            ['特務', '名稱', '標籤', 'K', 'D', 'A', 'KD']
          ]; //特務,名稱,標籤,K,D,A
        }

        gamestarttime = jsonData['data']['metadata']['game_start_patched'];

        for (var j = 0;
        j < jsonData['data']['players']['all_players'].length;
        j++) {
          String? jmap = jsonData['data']['metadata']['map'];
          String? jpuuid =
          jsonData['data']['players']['all_players'][j]['puuid'];
          String? jmode = jsonData['data']['metadata']['mode'];
          String? jagentimg = jsonData['data']['players']['all_players'][j]
          ['assets']['agent']['small'];
          String? jname = jsonData['data']['players']['all_players'][j]['name'];
          String? jtag = jsonData['data']['players']['all_players'][j]['tag'];
          String? jteam = jsonData['data']['players']['all_players'][j]['team'];

          int jk = jsonData['data']['players']['all_players'][j]['stats']
          ['kills'];
          int jd = jsonData['data']['players']['all_players'][j]['stats']
          ['deaths'];
          int ja = jsonData['data']['players']['all_players'][j]['stats']
          ['assists'];

          jmap = map[jmap.toString().toLowerCase()];
          jmode = mode[jmode.toString().toLowerCase()];

          if (jsonData['data']['metadata']['mode'] == "Deathmatch") {
            List<int> playerskills = [];

            for(int ts=0;ts < jsonData['data']['players']['all_players'].length;ts++){
              playerskills.add(jsonData['data']['players']['all_players'][ts]['stats']['kills']);
            }

            int? matchmaxkills = playerskills.reduce((value, element) => value > element ? value : element);
            String? myteamscore = '${matchmaxkills.toString()} : ${jk.toString()}';

            tableData.add([
              jagentimg.toString(),
              jname.toString(),
              jtag.toString(),
              jk.toString(),
              jd.toString(),
              ja.toString(),
              (jk/jd).toStringAsFixed(1)
            ]);
          } else {
            myteam =
            jsonData['data']['players']['all_players'][j]['team'];
            myteam = myteam.toLowerCase();
            String? myteamscore = '${jsonData['data']['teams'][myteam]['rounds_won']} : ${jsonData['data']['teams'][myteam]['rounds_lost']}';
            String? elsmodewinloss = '';

            if (jsonData['data']['teams'][myteam]['has_won'] == true) {
              elsmodewinloss = 'Win';
            }else{
              elsmodewinloss = 'Loss';
            }

            tableData.add([
              jagentimg.toString(),
              jteam.toString(),
              jname.toString(),
              jtag.toString(),
              jk.toString(),
              jd.toString(),
              ja.toString(),
              (jk/jd).toStringAsFixed(1)
            ]);
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

          if (!rowData.contains("Blue") && !rowData.contains("Red") && !rowData.contains(widget.gameName) && !rowData.contains(widget.tagLine)) {
            matchtableRows.add(
              TableRow(
                children: cells,
              ),
            );
          }else if(rowData.contains(widget.gameName) && rowData.contains(widget.tagLine)){
            matchtableRows.add(
              TableRow(
                  decoration: BoxDecoration(
                    color: Colors.amberAccent[700],
                  ),
                  children: cells
              ),
            );
          }else if (rowData.contains("Blue")) {
            matchtableRows.add(
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                ),
                children: cells
              ),
            );

          } else if (rowData.contains("Red")) {
            matchtableRows.add(
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.red[300],
                ),
                children: cells
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
    }
  }

  @override
  void initState() {
    matchdtdw();
  }
}
