import 'dart:isolate';
import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:labs/shared/neural/neural.dart';

part 'neuron.g.dart';

@JsonSerializable(
  createToJson: true,
)
class Neuron {
  final ActivationAlgorithm activationAlgorithm;
  final int parentLayerSize;

  @JsonKey(ignore: true)
  late final ActivationFunction activation;

  @JsonKey(ignore: true)
  late final ActivationFunction activationPrime;

  final double learningRate;

  List<double> weights = [];

  List<double> inputs = [];

  bool isInput = false;

  Neuron({
    required this.activationAlgorithm,
    required this.parentLayerSize,
    required this.learningRate,
    List<double> weights = const [],
  }) {
    activation = resolveActivationAlgorithm(activationAlgorithm);
    activationPrime = resolveActivationDerivative(activationAlgorithm);

    if (parentLayerSize == 0) {
      isInput = true;
      this.weights.add(1);
      return;
    }

    if (weights.isEmpty) {
      final limit = 1 / sqrt(parentLayerSize);

      this.weights.addAll(
            generateListWithRandomDoubles(
              size: parentLayerSize,
              from: -limit,
              to: limit,
            ),
          );
      return;
    }

    if (weights.length != parentLayerSize) {
      throw NeuronException(
        'The number of weights supplied to this neuron does not match the '
        'number of connections to neurons in the parent layer.',
      );
    }

    // ignore: prefer_initializing_formals
    this.weights = weights;
    return;
  }

  void setWeights(List<double> newWeights) {
    if (newWeights.length != weights.length) {
      throw NeuronException(
          "A new weight length is don`t equal to original weights length");
    }

    weights = newWeights;
  }

  void accept({List<double>? inputs, double? input}) {
    if (inputs == null && input == null) {
      throw NeuronException('Nulled');
    }

    if (!isInput && inputs != null) {
      this.inputs = inputs;
      return;
    }

    if (this.inputs.isNotEmpty) {
      this.inputs.first = input!;
    } else {
      this.inputs.add(input!);
    }
  }

  List<double> adjust({required double weightMargin}) {
    final adjustedWeights = <double>[];
    for (var index = 0; index < weights.length; index++) {
      adjustedWeights.add(weightMargin * weights[index]);
      weights[index] -= learningRate *
          -weightMargin *
          activationPrime(() => dot(inputs, weights)) *
          inputs[index];
    }

    return adjustedWeights;
  }

  double get output =>
      weights.isEmpty ? inputs.first : activation(() => dot(inputs, weights));

  factory Neuron.fromJson(Map<String, dynamic> json) => _$NeuronFromJson(json);

  updateFromJson(Map<String, dynamic> json) => _$NeuronFromJson(json);

  Map<String, dynamic> toJson() => _$NeuronToJson(this);
}
