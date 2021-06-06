import 'package:flutter/material.dart';
import 'package:stock_ui/models/stock.dart';
import 'package:stock_ui/widgets/stock_list.dart';
import 'package:stock_ui/http_service.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  final HttpService httpService = HttpService();

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
                child: FutureBuilder(
                  future: httpService.getStocks(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Stock>> snapshot) {
                    if (snapshot.hasData) {
                      List<Stock> stocks = snapshot.data;
                      return SizedBox(
                          height: MediaQuery.of(context).size.height - 310,
                          child: StockList(
                            stocks: stocks,
                          ));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
            ],
          ),
        ),
      )
    ]));
  }
}
