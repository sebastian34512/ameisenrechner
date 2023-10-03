import 'dart:convert';

class ChallengeItem {
  ChallengeItem(
      {required this.date,
      required this.object,
      required this.weight,
      required this.image});

  final String date;
  final String object;
  final double weight;
  final String image;

  factory ChallengeItem.fromJson(Map<String, dynamic> json) => ChallengeItem(
        date: json["date"],
        object: json["object"],
        weight: json["weight"],
        image: json["image"],
      );
}

List<ChallengeItem> loadChallengesFromJson(String jsonString) {
  final List<dynamic> jsonData = json.decode(jsonString);
  final List<ChallengeItem> challenges = [];

  for (final item in jsonData) {
    final challenge = ChallengeItem.fromJson(item);
    challenges.add(challenge);
  }

  return challenges;
}

ChallengeItem? getCurrentChallenge(List<ChallengeItem> challenges) {
  final today = DateTime.now().toLocal();
  final todayDate =
      today.toIso8601String().substring(0, 10); // Heutiges Datum im ISO-Format

  for (final challenge in challenges) {
    if (challenge.date == todayDate) {
      return challenge;
    }
  }

  return null; // Keine Challenge für heute gefunden
}
