import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../constants/global_variables.dart';

class WebRepo {
  static sendNotification(
      String notificationToken, Map notification, Map data) async {
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverKey,
    };

    Map bodyMap = {
      'notification': notification,
      'data': data,
      'priority': 'high',
      'to': notificationToken
    };

    await http.post('https://fcm.googleapis.com/fcm/send',
        headers: headerMap, body: jsonEncode(bodyMap));
  }

  static Future<void> sendNotificationMsg(String uid, dynamic data) async {
    CollectionReference reference = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('messages');
    reference.doc().set(data);
  }
}
