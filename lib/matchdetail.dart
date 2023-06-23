import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Valorant_Match/dhn.dart';
import 'package:Valorant_Match/playerdetail.dart';

class matchdtl extends StatefulWidget {
  final int index;
  final List<String> titlerowData;
  final String gameName;
  final String tagLine;
  final Map<String, dynamic> jsonData;

  const matchdtl({
    Key? key,
    required this.index,
    required this.titlerowData,
    required this.gameName,
    required this.tagLine,
    required this.jsonData
  }) : super(key: key);

  @override
  State<matchdtl> createState() => _matchdtlState();
}

class _matchdtlState extends State<matchdtl> {
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
                  1: IntrinsicColumnWidth(),
                  2: FixedColumnWidth(100),
                  3: IntrinsicColumnWidth(),
                  4: IntrinsicColumnWidth(),
                  5: IntrinsicColumnWidth(),
                  6: IntrinsicColumnWidth(),
                  7: IntrinsicColumnWidth(),
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

  void matchdtdw() async {
    //抓取本場詳細資訊
    try {
        Map<String, dynamic> jsonData = widget.jsonData;
        var i = widget.index;

        List<List<String>> tableData = [
          ['特務', '隊伍', '名稱', '標籤', 'K', 'D', 'A', 'KD']
        ]; //特務,隊伍,名稱,標籤,K,D,A

        gamestarttime = jsonData['data'][i]['metadata']['game_start_patched'];

        if(jsonData['data'][i]['metadata']['mode'] == "Custom Game"){
          setState(() {
            if(mode[jsonData['data'][i]['metadata']['queue'].toLowerCase()] != null){
              titlequeue = mode[jsonData['data'][i]['metadata']['queue'].toLowerCase()].toString();
            }else{
              titlequeue = jsonData['data'][i]['metadata']['queue'];
            }
          });
        }

        for (var j = 0;
        j < jsonData['data'][i]['players']['all_players'].length;
        j++) {
          String? jmap = jsonData['data'][i]['metadata']['map'];
          String? jmode = jsonData['data'][i]['metadata']['mode'];
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

          if(map[jmap.toString().toLowerCase()] != null){
            jmap = map[jmap.toString().toLowerCase()];
          }

          if(mode[jmode.toString().toLowerCase()] != null){
            jmode = mode[jmode.toString().toLowerCase()];
          }

          if(jteam != 'Red' && jteam != 'Blue'){
            jteam = '';
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
                  int index = tableData.indexOf(rowData) - 1;
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => playerdt(gameNameedit: rowData[2],tagLineedit:rowData[3]),
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
                          builder: (context) => playerdt(gameNameedit: rowData[2],tagLineedit:rowData[3]),
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
                          builder: (context) => playerdt(gameNameedit: rowData[2],tagLineedit:rowData[3]),
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
                          builder: (context) => playerdt(gameNameedit: rowData[2],tagLineedit:rowData[3]),
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
      print('Error: $error');
    }
  }

  @override
  void initState() {
    matchdtdw();
  }
}
