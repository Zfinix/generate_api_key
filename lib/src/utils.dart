part of 'generate_api_key.dart';

/// Checks for a natural number.
///
/// `value` The value to check.
/// returns Whether the value is a natural number or not.
bool _isNaturalNum(int value) {
  if (value >= 0.0) {
    return value == value && value != double.infinity;
  } else {
    return false;
  }
}

/// This generates a random number between `min` (inclusive) and `max`
int generateNatural({required int min, required int max}) {
  if (min > max) {
    throw ArgumentError('min should not be greater than max.');
  }
  if (min < 0) {
    throw ArgumentError('min should not be negative.');
  }

  final rng = Random();
  // Add 1 to the range because Random.nextInt's upper bound is exclusive
  return min + rng.nextInt(max - min + 1);
}

/// This generates a random string of a specified length from a given set of
/// characters.
String generateRandomString({
  required int length,
  required String pool,
}) {
  final characters = pool;
  final rng = Random();

  return List.generate(
    length,
    (_) => characters[rng.nextInt(characters.length)],
  ).join();
}

///
Uint8List generateRandomBytes(int length) {
  final rng = Random();
  return Uint8List.fromList(List.generate(length, (_) => rng.nextInt(256)));
}

Uint8List _uuidToBuffer(String uuid) {
  final hexString = uuid.replaceAll('-', '');
  final bytes = <int>[];
  for (var i = 0; i < hexString.length; i += 2) {
    bytes.add(int.parse(hexString.substring(i, i + 2), radix: 16));
  }
  return Uint8List.fromList(bytes);
}

extension _HexString on Uint8List {
  String toHexString() {
    return map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }
}

extension _StringSliceExtension on String {
  /// Returns a new substring containing all characters between [start]
  /// (inclusive) and [end] (inclusive).
  /// If [end] is omitted, it is being set to `lastIndex`.
  ///
  ///  ```dart
  /// print('awesomeString'.slice(0,6)); // awesome
  /// print('awesomeString'.slice(7)); // String
  /// ```
  String slice(int start, [int end = -1]) {
    final start0 = start < 0 ? start + length : start;
    final end0 = end < 0 ? end + length : end;

    RangeError.checkValidRange(start0, end0, length);

    return substring(start0, end0 + 1);
  }
}
