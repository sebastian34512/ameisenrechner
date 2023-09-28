class Item {
  Item(
      {required this.id,
      required this.name,
      required this.weight,
      required this.image});

  final String id;
  final String name;
  final double weight;
  final String image;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["object"],
        weight: json["weight"],
        image: json["image"],
      );
}
