import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Valorant_Match/playerdetail.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController gameNameedit = TextEditingController();
  TextEditingController tagLineedit = TextEditingController();

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
          title: const Text("Valorant Address"),
          backgroundColor: Colors.black,
        ),
        body: Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.all(10),
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
                  onPressed: () {
                    if (gameNameedit.text.toString() == "" || tagLineedit.text.toString() == "") {
                      toast("請先輸入玩家資訊");
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => playerdt(gameNameedit: gameNameedit.text.toString(),tagLineedit:tagLineedit.text.toString()),
                      ),
                    );
                  },
                  child: const Text("取得玩家資訊"),
                ),
              ),
              const SizedBox(height: 20), // 添加垂直间距
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
}
