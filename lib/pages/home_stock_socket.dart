import 'package:flutter/material.dart';
import 'package:stock_ui/models/stock.dart';
import 'package:stock_ui/widgets/stock_list.dart';
import 'package:intl/intl.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:convert';

class HomeStockSocket extends StatefulWidget {
  HomeStockSocket({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeStockSocket> {
  StompClient stompClient;
  final socketUrl = 'http://localhost:8080/ws-message';

  String message = '';
  List<Stock> stockList;

  void onConnect(StompClient client, StompFrame frame) {
    client.subscribe(
        destination: '/topic/message',
        callback: (StompFrame frame) {
          if (frame.body != null) {
            Map<String, dynamic> obj = json.decode(frame.body);
            List<Stock> stocks = new List<Stock>();

            for (int i = 0; i < obj['stock'].length; i++) {
              Stock stock = new Stock(
                  company: obj['stock'][i]['name'],
                  symbol: obj['stock'][i]['symbol'],
                  price: obj['stock'][i]['price'],
                  chg: obj['stock'][i]['chg']);
              stocks.add(stock);
            }

            setState(() => stockList = stocks);
          }
        });

      client.send(destination: '/app/hello', body: "dimuthu");
  }

  @override
  void initState() {
    super.initState();

    if (stompClient == null) {
      stompClient = StompClient(
          config: StompConfig.SockJS(
        url: socketUrl,
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => print(error.toString()),
      ));

      stompClient.activate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Watch List",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      DateFormat('dd MMMM yyyy').format(DateTime.now()),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    DateFormat().add_jm().format(DateTime.now()),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        hintText: "Search",
                        prefix: Icon(Icons.search),
                        fillColor: Colors.grey[800],
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                            borderRadius:
                                BorderRadius.all(Radius.circular(16)))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height - 310,
                    child: StockList(
                      stocks: stockList,
                    )),
              )
            ],
          ),
        ),
      )
    ]));
  }

  @override
  void dispose() {
    if (stompClient != null) {
      stompClient.deactivate();
    }

    super.dispose();
  }
}
