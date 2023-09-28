import 'dart:convert';

import 'package:ameisenreichner/models/item.dart';
import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  late Future<List<Item>> overviewItems;

  @override
  void initState() {
    super.initState();
    overviewItems = loadItemsFromJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      body: FutureBuilder<List<Item>>(
        future: overviewItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Image.asset(
                    snapshot.data![index].image,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<List<Item>> loadItemsFromJson() async {
    List<Item> items = [];
    String data =
        await DefaultAssetBundle.of(context).loadString("collection.json");
    final jsonResult = jsonDecode(data);
    for (var item in jsonResult) {
      items.add(Item.fromJson(item));
    }
    return items;
  }
}
