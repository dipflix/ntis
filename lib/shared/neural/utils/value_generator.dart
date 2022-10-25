import 'dart:math';

final Random _random = Random.secure();

double nextDouble({double from = 0, double to = 0}) =>
    _random.nextDouble() * (to - from) + from;

Iterable<double> doubleIterableSync({double from = 0, double to = 0}) sync* {
  while (true) {
    yield nextDouble(from: from, to: to);
  }
}

List<double> generateListWithRandomDoubles({
  required int size,
  double from = 0,
  double to = 0,
}) =>
    doubleIterableSync(from: from, to: to).take(size).toList();
