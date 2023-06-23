import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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