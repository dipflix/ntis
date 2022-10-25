import 'package:labs/shared/neural/neural.dart';

class LSTM extends Layer {
  late final ActivationFunction recurrenceActivation;
  double longTermMemory = 1;

  double shortTermMemory = 1;

  LSTM({
    required super.size,
    required super.activation,
    required ActivationAlgorithm recurrenceActivation,
  }) : recurrenceActivation = resolveActivationAlgorithm(recurrenceActivation);

  @override
  List<double> get output {
    final output = <double>[];

    for (final neuron in neurons) {
      final neuronOutput = neuron.output;
      final hiddenActivationComponent = neuron.activation(() => neuronOutput);
      final hiddenRecurrentComponent = recurrenceActivation(() => neuronOutput);

      longTermMemory = hiddenActivationComponent * longTermMemory;

      longTermMemory = (hiddenActivationComponent * hiddenRecurrentComponent) +
          longTermMemory;

      final stateRecurrentComponent =
          recurrenceActivation(() => longTermMemory);
      shortTermMemory = hiddenActivationComponent * stateRecurrentComponent;
      output.add(shortTermMemory);
    }

    return output;
  }
}
