// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:coincap/models/app_config.dart';
import 'package:coincap/pages/home_page.dart';
import 'package:coincap/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfig();
  registerHTTPService();
  GetIt.instance.get<HTTPService>().get("/coins/bitcoin");
  runApp(const MyApp());
}

Future<void> loadConfig()async{
  String _configContent = await rootBundle.loadString("assets/config/main.json");
  Map _configData = jsonDecode(_configContent);
  GetIt.instance.registerSingleton<AppConfig>(
    AppConfig(COIN_API_BASE_URL: _configData["COIN_API_BASE_URL"])
  );

}

void registerHTTPService(){
  GetIt.instance.registerSingleton<HTTPService>(
    HTTPService()
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Coin Cap",
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          scaffoldBackgroundColor: Color.fromRGBO(88, 60, 197, 1)),
      home: MyHomePage(),
    );
  }
}
