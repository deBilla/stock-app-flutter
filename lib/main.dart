import 'package:flutter/material.dart';
import 'package:stock_ui/pages/home_page.dart';
import 'package:stock_ui/pages/home_stock_socket.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeStockSocket(title: 'title'),
    );
  }
}
