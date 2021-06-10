import 'package:flutter/material.dart';
import 'package:stock_ui/models/stock.dart';

class StockList extends StatelessWidget {
  final List<Stock> stocks;

  StockList({this.stocks});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return Divider(color: Colors.grey[400]);
      },
      itemCount: stocks != null ? stocks.length : 0,
      itemBuilder: (context, index) {
        final stock = stocks[index];
        bool isChgNegative = true;

        if (double.parse(stock.chg) > 0) {
          isChgNegative = false;
        }

        return ListTile(
          contentPadding: EdgeInsets.all(10),
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${stock.symbol}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500)),
                Text("${stock.company}",
                    style: TextStyle(color: Colors.white, fontSize: 20))
              ]),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                "\$${stock.price}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
              Container(
                alignment: Alignment.center,
                width: 75,
                height: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: isChgNegative ? Colors.red : Colors.green),
                child: Text(
                  "${stock.chg}%",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
