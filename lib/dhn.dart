// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

List<String> map_en_US = [];
List<String> map_zh_TW = [];

Map<String, String> map = {};

Map<String, String> mode = {
  "unrated": "一般模式",
  "competitive": "競技模式",
  "spike rush": "輻能搶攻戰",
  "deathmatch": "死鬥模式",
  "team deathmatch":"團隊死鬥",
  "escalation": "超激進戰",
  "replication": "複製亂戰",
  "snowballfight": "打雪仗",
  "swiftplay": "超速衝點",
  "custom game": "自訂模式",
};

Future<void> getmap() async{
  try {
    final response = await http.get(Uri.parse('https://valorant-api.com/v1/maps'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      for(var i = 0 ;i<jsonData['data'].length;i++){
        map_en_US.add(jsonData['data'][i]['displayName'].toLowerCase());
      }
    } else {
      toast('Request failed with status: ${response.statusCode}');
    }
  } catch (error) {
    toast('Error: $error');
  }

  try {
    final response = await http.get(Uri.parse('https://valorant-api.com/v1/maps?language=zh-TW'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      for(var i = 0 ;i<jsonData['data'].length;i++){
        map_zh_TW.add(jsonData['data'][i]['displayName']);
      }
    } else {
      toast('Request failed with status: ${response.statusCode}');
    }
  } catch (error) {
    toast('Error: $error');
  }

  try{
    for(var i = 0;i<map_en_US.length;i++){
      map[map_en_US[i]] = map_zh_TW[i];
    }
  }catch(error){
    toast(error);
  }
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