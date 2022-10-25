
double dot(List<double> a, List<double> b) {
  var result = 0.0;

  for (var index = 0; index < a.length; index++) {
    result += a[index] * b[index];
  }

  return result;
}

List<double> add(List<double> a, List<double> b) {
  final result = <double>[];

  for (var index = 0; index < a.length; index++) {
    result.add(a[index] + b[index]);
  }

  return result;
}

List<double> subtract(List<double> a, List<double> b) {
  final result = <double>[];


  for (var index = 0; index < a.length; index++) {
    result.add(a[index] - b[index]);
  }

  return result;
}

double abs(double x) => x < 0 ? -x : x;
