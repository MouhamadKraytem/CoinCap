// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map rates;
  const DetailsPage({required this.rates, super.key});

  @override
  Widget build(BuildContext context) {
    List _currencies = rates.keys.toList();
    List _exchangeRates = rates.values.toList();
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.deepPurpleAccent,),
        body: SafeArea(
      child: ListView.builder(
        itemCount: _exchangeRates.length,
        itemBuilder: (_context, _index) {
          return ListTile(
            title: Text(
              "${_currencies[_index].toString().toUpperCase()}",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              "${_exchangeRates[_index]}",
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    ));
  }
}
