// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print

import 'package:dio/dio.dart';
import '../models/app_config.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();

  AppConfig ? _appConfig;
  String ?_baseUrl;

  HTTPService(){
    _appConfig = GetIt.instance.get<AppConfig>();
    _baseUrl = _appConfig!.COIN_API_BASE_URL;
  }

  Future <Response?>get(String _path) async {
    try {
      String _url = "$_baseUrl$_path";
      
      //print(_url);
      Response? _response = await dio.get(_url);
      //print(_response);
      return _response;
    } catch (e) {
      print("Unable To perform the get request \n");
      print(e);
    }
    return null;
  }
}