import 'dart:math';

String getRandomCarPlate() {
  final random = Random();
  String plate = _prefixes[random.nextInt(_prefixes.length)];
  if (plate != "Putrajaya") {
    plate += _generateRandomString(random, 2);
  }
  final nextInt = random.nextInt(9999).toString();
  plate += "${" " * (5 - nextInt.length)}$nextInt";
  return plate;
}

Duration randomTime(int minTimeInSeconds, int maxTimeInSeconds) {
  final random = Random();
  return Duration(
      seconds: minTimeInSeconds +
          random.nextInt(maxTimeInSeconds - minTimeInSeconds));
}

const List<String> _prefixes = [
  "A",
  "B",
  "C",
  "D",
  "F",
  "J",
  "K",
  "M",
  "N",
  "P",
  "R",
  "T",
  "V",
  "W",
  "Putrajaya",
  "S",
  "Q"
];
String _generateRandomString(Random random, int length) {
  final codeUnits = List.generate(length, (index) => random.nextInt(26) + 65);
  return String.fromCharCodes(codeUnits);
}
