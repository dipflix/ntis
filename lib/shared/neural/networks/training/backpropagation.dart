import 'dart:isolate';

import 'package:labs/shared/neural/neural.dart';

mixin Backpropagation on Network {
  Future<void> propagateBackwards(List<double> input, List<double> expected) async {
    final observed = process(input);

    var errors = subtract(expected, observed);

    for (var index = layers.length - 1; index > 0; index--) {
      errors = await layers[index].propagate(errors);
    }
  }

  Future<void> train({
    required List<List<double>> inputs,
    required List<List<double>> expected,
    required int iterations,
    required ReceivePort receivePort,
  }) async {

    await Isolate.spawn((message) async {
      if (inputs.isEmpty || expected.isEmpty) {
        throw NeuronException(
            'Both inputs and expected results must not be empty.');
      }

      if (inputs.length != expected.length) {
        throw NeuronException(
            'Inputs and expected result lists must be of the same length.');
      }

      if (iterations < 1) {
        throw NeuronException(
            'You cannot train a network without granting it at least one iteration.');
      }

      for (var iteration = 0; iteration < iterations; iteration++) {
        for (var index = 0; index < inputs.length; index++) {
         await propagateBackwards(inputs[index], expected[index]);
        }
      }

      message.send(Object());
      Isolate.exit(message);
    }, receivePort.sendPort);
  }
}
