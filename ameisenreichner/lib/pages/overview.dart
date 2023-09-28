import 'dart:convert';

import 'package:ameisenreichner/constants/colors.dart';
import 'package:ameisenreichner/models/item.dart';
import 'package:ameisenreichner/utils.dart';
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
      backgroundColor: AppColor.appLightBrown,
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
                    path("collection_images/${snapshot.data![index].image}"),
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
    String data = await DefaultAssetBundle.of(context)
        .loadString(path("assets/collection.json"));
    final jsonResult = jsonDecode(data);
    for (var item in jsonResult) {
      debugPrint(item.toString());
      items.add(Item.fromJson(item));
    }
    return items;
  }
}
