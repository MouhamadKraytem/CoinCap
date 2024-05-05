// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_constructors, unused_element, unnecessary_brace_in_string_interps, sort_child_properties_last, unnecessary_string_interpolations, prefer_final_fields

import 'dart:convert';

import 'package:coincap/pages/details_page.dart';
import 'package:coincap/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double? _deviceHeight, _deviceWidth;
  HTTPService? _http;
  List<String> _coins = ["bitcoin", "ethereum", "tether", "cardano", "ripple"];
  String _selectedCoin = "bitcoin";
  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      //appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [_selectedCoinDropDown(_coins), _dataWidget()],
          ),
        ),
      ),
    );
  }

  Widget _selectedCoinDropDown(List<String> _coins) {
    List<DropdownMenuItem<String>> _items = _coins
        .map((e) => DropdownMenuItem(
              child: Text(
                e,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              value: e,
            ))
        .toList();
    return DropdownButton(
      value: _selectedCoin,
      underline: Container(),
      items: _items,
      onChanged: (dynamic newValue) {
        setState(() {
          _selectedCoin = newValue;
        });
      },
      dropdownColor: Color.fromRGBO(83, 88, 206, 1),
      iconSize: 40,
      icon: Center(
          child: Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      )),
    );
  }

  Widget _dataWidget() {
    return FutureBuilder(
      future: _http!.get("/coins/$_selectedCoin"),
      builder: (BuildContext _context, AsyncSnapshot _snapShot) {
        if (_snapShot.hasData) {
          Map _data = jsonDecode(_snapShot.data.toString());
          num _usdPrice = _data["market_data"]["current_price"]["usd"];
          num _change24h = _data["market_data"]["price_change_percentage_24h"];
          String _imgUrl = _data["image"]["large"];
          String _descr = _data["description"]["en"];
          Map _exchangeRates = _data["market_data"]["current_price"];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _currentPriceWidget(_usdPrice),
              GestureDetector(
                child: _coinImage(_imgUrl),
                onDoubleTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext _context) {
                    return DetailsPage(rates:_exchangeRates);
                  }));
                },
              ),
              _percentageChangeWidget(_change24h),
              _descriptionCardWidget(_descr)
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget _currentPriceWidget(num _rate) {
    return Text(
      "${_rate.toStringAsFixed(2)} USD",
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
    );
  }

  Widget _percentageChangeWidget(num _change) {
    return Text(
      "${_change} %",
      style: TextStyle(
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
    );
  }

  Widget _coinImage(String _imgURL) {
    return Container(
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      padding: EdgeInsets.symmetric(
          vertical: _deviceHeight! * 0.2, horizontal: _deviceWidth! * 0.2),
      decoration: BoxDecoration(
          image:
              DecorationImage( image: NetworkImage(_imgURL))),
    );
  }

  Widget _descriptionCardWidget(String _description) {
    return Container(
      height: _deviceHeight! * 0.45,
      width: _deviceWidth! * 0.9,
      margin: EdgeInsets.symmetric(
          vertical: _deviceHeight! * 0.02, horizontal: _deviceWidth! * 0.02),
      padding: EdgeInsets.symmetric(
          vertical: _deviceHeight! * 0.01, horizontal: _deviceWidth! * 0.01),
      color: Color.fromRGBO(83, 88, 206, 0.5),
      child: Text(
        "$_description",
        style: TextStyle(color: Colors.white, overflow: TextOverflow.fade),
      ),
    );
  }
}
