class TrainIsolateModel {
  final List<List<double>> inputs;
  final List<List<double>> expected;
  final int iterations;

  TrainIsolateModel({
    required this.inputs,
    required this.expected,
    required this.iterations,
  });
}
