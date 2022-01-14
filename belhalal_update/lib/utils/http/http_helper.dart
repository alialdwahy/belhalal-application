import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:belhalal_update/utils/storage/storage_helper.dart';
import 'package:belhalal_update/utils/storage/storage_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class HttpHelper {
  static Dio? _client;

  static Future<Dio> _getInstance(
      {bool? isAuth, bool? withCookie, bool? withToken}) async {
    if (_client == null) _client = Dio();

    if (!isAuth!) {
      // _client.options.headers['content-Type'] = 'application/x-www-form-urlencoded';
      _client!.options.headers = {
        // "Content-Type": "application/x-www-form-urlencoded",
        "Content-Type": "application/json",
        // "Accept": "application/json",
      };

      // _client!.options.contentType = ContentType("application", "json");
      return _client!;
    }
    print("is auth api .......");
    final storageToken = await StorageHelper.get(StorageKeys.token);

    log(storageToken!);
 
    var headers = {
      // "Content-Type": "application/form-data",
      'Authorization': 'Bearer $storageToken'
    };
    if (withToken == true) headers = {...headers, 'Bearer': '$storageToken'};
//       headers = {
//        'Content-Type': 'application/json',
//        'Authorization': 'Bearer $storageToken'
//      };
    _client!.options.headers = headers;

    log(headers.toString());

    _client!.options.connectTimeout = 5000000; //5s
    // _client.options.receiveTimeout = 3000;

    return _client!;
  }

  static Future<Response> httpRequest(
    String newUrl, {
    bool isAuth = false,
    bool withToken = true,
    String methodType = "get",
    dynamic bodyData,
  }) async {
    final String url = "";
    print(url);
    final instance = await _getInstance(isAuth: isAuth, withToken: withToken);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('Connected');
      } else {
        print('Not Connected');
        //  CustomToast().showToastError('لا يوجد اتصال بالانترنت');
      }

      switch (methodType) {
        case "put":
          return instance.put(url, data: FormData.fromMap(bodyData));
        case "post":
          print("in post method ...${instance.options.headers.values}");
          return instance.post(url, data: jsonEncode(bodyData));
      }
      print("in get method ...${instance.options.headers.values}");
      print("in get method ......");
      
      return instance.get(url,queryParameters: bodyData);
    } on SocketException catch (e) {
      //   CustomToast().showToastError('لا يوجد اتصال بالانترنت');
     Fluttertoast.showToast(
        msg: "No internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.blue,
    );
      log('Network Exception: ${e.toString()}');
      log('-------------------');
    }
    return instance.get(url);
  }
  // static Future<Response> get(String url, {bool withToken}) async {
  //   final instance = await _getInstance(withToken: withToken);
  //   return instance.get(url);
  // }
  //
  // static Future<Response> post(String url,
  //     {dynamic body, bool withToken, bool withCookie}) async {
  //   final instance = await _getInstance(withCookie: true, withToken: true);
  //   return instance.post(url, data: body);
  // }
  //
  // static Future<Response> put(String url,
  //     {dynamic body, bool withToken}) async {
  //   final instance = await _getInstance(withToken: withToken);
  //   return instance.put(url, data: body);
  // }
  //
  // static Future<Response> delete(String url,
  //     {dynamic body, bool withToken}) async {
  //   final instance = await _getInstance(withToken: withToken);
  //   return instance.delete(url);
  // }
}
