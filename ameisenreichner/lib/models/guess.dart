class Guess {
  Guess({required this.device_id, required this.guess});

  final String device_id;
  final int guess;

  factory Guess.fromJson(Map<String, dynamic> json) => Guess(
        device_id: json["deviceId"],
        guess: json["guess"],
      );
}
