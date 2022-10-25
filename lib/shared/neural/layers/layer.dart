import 'dart:isolate';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:labs/shared/neural/neural.dart';

part 'layer.g.dart';

@JsonSerializable(
  createToJson: true,
)
class Layer {
  final ActivationAlgorithm activation;

  final List<Neuron> neurons = [];
  final int size;
  bool isInput = false;

  Layer({
    required this.size,
    required this.activation,
  }) {
    if (size < 1) {
      throw NeuronException('A layer must contain at least one neuron.');
    }
  }

  void initializeFromJsonNeurons(List<Map<String, dynamic>> data) {
    Map<String, dynamic> itemConstants = data.first..remove('neurons');
    var parentLayerSize = itemConstants['parentLayerSize'];
    var learningRate = itemConstants['learningRate'];
    List<Neuron> neurons = [];

    for (var i = 0; i < data.length; i++) {
      neurons.add(Neuron.fromJson(data[i]));
    }

    initialise(
      parentLayerSize: parentLayerSize,
      learningRate: learningRate,
      neurons: neurons,
    );
  }

  void initialise({
    required int parentLayerSize,
    required double learningRate,
    List<Neuron>? neurons,
  }) {
    isInput = parentLayerSize == 0;

    this.neurons.addAll(
          Iterable.generate(
            size,
            (index) => Neuron(
              activationAlgorithm: activation,
              parentLayerSize: parentLayerSize,
              learningRate: learningRate,
              weights: neurons != null ? neurons[index].weights : [],
            ),
          ),
        );
  }

  void accept(List<double> inputs) {
    if (isInput) {
      for (var index = 0; index < neurons.length; index++) {
        neurons[index].accept(input: inputs[index]);
      }
      return;
    }

    for (final neuron in neurons) {
      neuron.accept(inputs: inputs);
    }
  }

  Future<List<double>> propagate(List<double> weightMargins) async {
    final newWeightMargins = <List<double>>[];

    for (final neuron in neurons) {
      newWeightMargins.add(
        neuron.adjust(
          weightMargin: weightMargins.removeAt(0),
        ),
      );
    }

    return newWeightMargins.reduce(add);
  }

  List<double> get output =>
      List<double>.from(neurons.map<double>((neuron) => neuron.output));

  factory Layer.fromJson(Map<String, dynamic> json) => _$LayerFromJson(json);

  Map<String, dynamic> toJson() => {
        ..._$LayerToJson(this),
        'neurons': [...neurons.map((e) => e.toJson())]
      };

// String toJson() => json.encode({
//       ..._$LayerToJson(this),
//       'neurons': [...neurons.map((e) => e.toJson())],
//     });
}
