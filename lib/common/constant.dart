import 'package:flutter/material.dart';

const kLocalKey = {
  "url": "",
  "userInfo": "userInfo",
  "home": "home",
};
const kAdvanceConfig = {
  "DefaultLanguage": "en",
};

const List<String> usersType = [
  "editor",
 // "member",
  "manager",
  "approval"
];
const List<String> stages = [
  "draft",
  "for_manager",
  "w_manager",
  "for_approval",
  "approved",
  "reject"
];

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
