import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:Valorant_Match/dhn.dart';
import 'package:Valorant_Match/main.dart';
import 'package:Valorant_Match/playerdetail.dart';

class Matchdtl extends StatefulWidget {
  final int index;
  final List<String> titlerowData;
  final String gameName;
  final String tagLine;
  final Map<String, dynamic> jsonData;

  const Matchdtl({
    Key? key,
    required this.index,
    required this.titlerowData,
    required this.gameName,
    required this.tagLine,
    required this.jsonData,
  }) : super(key: key);

  @override
  State<Matchdtl> createState() => _MatchdtlState();
}

class _MatchdtlState extends State<Matchdtl> {
  List<TableRow> matchtableRows = [];

  String? gamestarttime = '';
  String? titlequeue = '';

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
                    titlequeue.toString(),
                    textAlign: TextAlign.center,
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
                  0: IntrinsicColumnWidth(),
                  1: FixedColumnWidth(0),
                  2: FixedColumnWidth(100),
                  3: FixedColumnWidth(0),
                  4: IntrinsicColumnWidth(),
                  5: IntrinsicColumnWidth(),
                  6: IntrinsicColumnWidth(),
                  7: IntrinsicColumnWidth(),
                  8: IntrinsicColumnWidth(),
                },
                border: TableBorder.all(color: Colors.transparent),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: matchtableRows,
              ),
              Text(gamestarttime.toString()),
              const Text("\n\n\n\n"),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyApp(),
              ),
            );
          },
          backgroundColor: const Color.fromRGBO(120, 190, 230, 0.3),
          child: const Icon(//回首頁按鈕
            Icons.home,
            color: Color.fromRGBO(255, 255, 255, 0.3),
          ),
        ),
      ),
    );
  }

  void matchdtdw() async {
    //抓取本場詳細資訊
    try {
        Map<String, dynamic> jsonData = widget.jsonData;
        var i = widget.index;

        List<List<String>> tableData = [
          ['特務', '隊伍', '名稱', '標籤','平均戰力指數', 'K', 'D', 'A', 'KD']
        ]; //特務,隊伍,名稱,標籤,平均戰力指數,K,D,A,KD

        gamestarttime = jsonData['data'][i]['metadata']['game_start_patched'];

        try{//對自訂模式進行而外讀取遊戲模式
          if(jsonData['data'][i]['metadata']['mode'] == "Custom Game"){
            setState(() {
              if(mode[jsonData['data'][i]['metadata']['queue'].toLowerCase()] != null){
                titlequeue = mode[jsonData['data'][i]['metadata']['queue'].toLowerCase()].toString();
              }else{
                titlequeue = jsonData['data'][i]['metadata']['queue'];
              }
            });
          }
        }catch(e){
          toast("自訂模式處理錯誤");
        }

        try{//對玩家進行排序(根據score)
          List<dynamic> allPlayers = jsonData['data'][i]['players']['all_players'];

          allPlayers.sort((a, b) => b['stats']['score'].compareTo(a['stats']['score']));

          jsonData['data'][i]['players']['all_players'] = allPlayers;
        }catch(e){
          toast("排序錯誤");
        }

        for (var j = 0;
        j < jsonData['data'][i]['players']['all_players'].length;
        j++) {
          String? jagentimg = jsonData['data'][i]['players']['all_players'][j]
          ['assets']['agent']['small'];
          int jk = jsonData['data'][i]['players']['all_players'][j]['stats']
          ['kills'];
          int jd = jsonData['data'][i]['players']['all_players'][j]['stats']
          ['deaths'];
          int ja = jsonData['data'][i]['players']['all_players'][j]['stats']
          ['assists'];

          String? jname = jsonData['data'][i]['players']['all_players'][j]['name'];
          String? jtag = jsonData['data'][i]['players']['all_players'][j]['tag'];
          String? jteam = jsonData['data'][i]['players']['all_players'][j]['team'];
          String? jpuuid = jsonData['data'][i]['players']['all_players'][j]['puuid'];

          int jscore = jsonData['data'][i]['players']['all_players'][j]['stats']['score'];
          int rounds = jsonData['data'][i]['metadata']['rounds_played'];

          if(jteam != 'Red' && jteam != 'Blue'){
            jteam = '';
          }

          String kd = '0';

          if(jd <= 0){
            kd = jk.toString();
          }else{
            kd = (jk/jd).toStringAsFixed(1);
          }

          tableData.add([
            jagentimg.toString(),
            jteam.toString(),
            jname.toString(),
            jtag.toString(),
            (jscore~/rounds).toString(),
            jk.toString(),
            jd.toString(),
            ja.toString(),
            kd.toString()
          ]);
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
                    child: Text(
                      cellData,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );

            }
          }

          if(tableData.indexOf(rowData) == 0){
            matchtableRows.add(
              TableRow(
                children: cells,
              ),
            );
          }else if(rowData.contains(widget.gameName.toString()) && rowData.contains(widget.tagLine.toString())){
            matchtableRows.add(
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.amberAccent[700],
                ),
                children: cells.map((Widget cell) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Playerdt(gameNameedit: rowData[2],tagLineedit:rowData[3]),
                        ),
                      );
                    },
                    child: cell,
                  );
                }).toList(),
              ),
            );
          }else if (rowData.contains("Blue")) {
            matchtableRows.add(
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                ),
                children: cells.map((Widget cell) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Playerdt(gameNameedit: rowData[2],tagLineedit:rowData[3]),
                        ),
                      );
                    },
                    child: cell,
                  );
                }).toList(),
              ),
            );

          } else if (rowData.contains("Red")) {
            matchtableRows.add(
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.red[300],
                ),
                children: cells.map((Widget cell) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Playerdt(gameNameedit: rowData[2],tagLineedit:rowData[3]),
                        ),
                      );
                    },
                    child: cell,
                  );
                }).toList(),
              ),
            );
          }else if(tableData.indexOf(rowData) != 0){
            matchtableRows.add(
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                ),
                children: cells.map((Widget cell) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Playerdt(gameNameedit: rowData[2],tagLineedit:rowData[3]),
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

        setState(() {

        });
    } catch (error) {
      toast('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    matchdtdw();
  }
}
