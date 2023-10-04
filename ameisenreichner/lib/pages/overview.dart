import 'dart:convert';

import 'package:ameisenreichner/constants/colors.dart';
import 'package:ameisenreichner/constants/values.dart';
import 'package:ameisenreichner/models/item.dart';
import 'package:ameisenreichner/pages/counter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Overview extends StatefulWidget {
  final int? itemId;
  const Overview({super.key, this.itemId});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  late Future<List<Item>> overviewItems;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    overviewItems = loadItemsFromJson();
    debugPrint("itemId: ${widget.itemId}");
    if (widget.itemId != null) {
      // Hier wird der Dialog geöffnet, wenn itemId nicht null ist.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openDialogForItemId(widget.itemId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appLightBrown,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Suche',
                labelStyle: GoogleFonts.inter(
                  textStyle: TextStyle(
                    color: AppColor.appBrown,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.appBrown, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.appBrown, width: 2.0),
                ),
              ),
              onChanged: searchItem,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Item>>(
              future: overviewItems,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: GestureDetector(
                          onTap: () {
                            _dialogBuilder(context, snapshot.data![index]);
                          },
                          child: Image.asset(
                            "${AppValues.assetString}collection_images/${snapshot.data![index].image}",
                            fit: BoxFit.cover,
                          ),
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
          ),
        ],
      ),
    );
  }

  Future<List<Item>> loadItemsFromJson() async {
    List<Item> items = [];
    String data = await DefaultAssetBundle.of(context)
        .loadString("${AppValues.assetString}collection.json");
    final jsonResult = jsonDecode(data);
    for (var item in jsonResult) {
      items.add(Item.fromJson(item));
    }
    return items;
  }

  Future<void> _openDialogForItemId(int itemId) async {
    // Lade das Item mit der itemId aus den Daten.
    List<Item> items = await overviewItems;
    Item? item;
    for (var i = 0; i < items.length; i++) {
      if (items[i].id == itemId.toString()) {
        item = items[i];
        break;
      }
    }

    // Öffne den Dialog für das gefundene Item.
    if (item != null) {
      _dialogBuilder(context, item);
    }
  }

  Future<void> _dialogBuilder(BuildContext context, Item item) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item.name),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "${AppValues.assetString}collection_images/${item.image}",
                  fit: BoxFit.cover,
                ),
                Text(
                  "Ein(e) ${item.name} wiegt im Durchschnitt ${item.weight}kg und braucht somit ${calcAnts(item.weight.toString())} Ameisen.",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: AppColor.appLightBrown,
        );
      },
    );
  }

  void searchItem(String query) async {
    if (query.isEmpty) {
      setState(() {
        overviewItems = loadItemsFromJson();
      });
      return;
    }
    final items = (await overviewItems).where((item) {
      final nameLower = item.name.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      overviewItems = Future.value(items);
    });
  }
}
