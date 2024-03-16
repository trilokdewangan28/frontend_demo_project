import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StaticMethod{
  //=============================================================SIGNUP CUSTOMER
  static Future<Map<String, dynamic>> userSignup(signupData, url) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(signupData), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while requesting for user signup',
        "error":e.toString()
      };
    }
  }

  static Future<Map<String, dynamic>> fetchProduct(url) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.get(url);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while requesting for user signup',
        "error":e.toString()
      };
    }
  }


  static Future<Map<String, dynamic>> loginUser(loginData,url) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(loginData), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while requesting for user signup',
        "error":e.toString()
      };
    }
  }


  static Future<Map<String,dynamic>> userProfileInitial(token,url) async {
    var response;
    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final res = await http.get(url, headers: requestHeaders);
      await Future.delayed(const Duration(milliseconds: 100));
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      //print('failed to complete user profile api');
      //print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while fetching user detail',
        "error":e.toString()
      };
    }
  }

  static void showDialogBar(String msg,  Color? textColor){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG, // Duration for which the toast should be visible
      gravity: ToastGravity.TOP, // Toast position
      backgroundColor: Colors.white, // Background color of the toast
      textColor: textColor, // Text color of the toast message
      fontSize: 16.0, // Font size of the toast message
    );
  }

}