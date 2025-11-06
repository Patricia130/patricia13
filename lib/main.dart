import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'core/pushnotification/push_notification.dart';
import '../../../app/app.dart';

Future<void> _testServerConnection() async {
  try {
    final response = await Dio().get('https://tochegandodelivery.site/api');
    if (response.statusCode == 200) {
      debugPrint('✅ Conexão com servidor ativa');
    } else {
      debugPrint('❌ Falha na conexão com o servidor: Status ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('❌ Falha na conexão com o servidor: $e');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferences.getInstance();
  await _testServerConnection();
  // Initialize notifications
  PushNotification pushNotification = PushNotification();
  await pushNotification.initMessaging();

  runApp(const MyApp());
}
