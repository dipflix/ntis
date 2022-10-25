import 'dart:math';

/// Converts seconds to an estimated time of arrival (ETA) string.
String secondsToETA(int seconds) {
  var eta = '';

  var secondsSink = seconds;
  final hours = seconds ~/ (60 * 60);
  secondsSink -= hours * (60 * 60);
  final minutes = seconds ~/ 60;
  secondsSink -= minutes * 60;

  if (hours < 10) {
    eta += '0';
  }
  eta += '$hours:';

  if (minutes < 10) {
    eta += '0';
  }
  eta += '$minutes:';

  if (secondsSink < 10) {
    eta += '0';
  }

  return eta += '$secondsSink';
}

int randomNumber(int min, int max) {
  return min + Random().nextInt(max - min);
}
