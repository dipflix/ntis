import 'dart:math';

import 'utils/mathematical_operations.dart';

typedef ActivationFunction = double Function(double Function());

typedef ActivationFunctionSignature = double Function(double);

const algorithms = <ActivationAlgorithm, List<ActivationFunctionSignature>>{
  ActivationAlgorithm.sigmoid: [sigmoid, sigmoidPrime],
  ActivationAlgorithm.relu: [relu, reluPrime],
  ActivationAlgorithm.lrelu: [lrelu, lreluPrime],
  ActivationAlgorithm.elu: [elu, eluPrime],
  ActivationAlgorithm.selu: [selu, seluPrime],
  ActivationAlgorithm.tanh: [tanh, tanhPrime],
  ActivationAlgorithm.softplus: [softplus, softplusPrime],
  ActivationAlgorithm.softsign: [softsign, softsignPrime],
  ActivationAlgorithm.swish: [swish, swishPrime],
  ActivationAlgorithm.gaussian: [gaussian, gaussianPrime],
};

ActivationFunction resolveActivationAlgorithm(
  ActivationAlgorithm activationAlgorithm,
) =>
    (weightedSum) => algorithms[activationAlgorithm]!.first(weightedSum());

ActivationFunction resolveActivationDerivative(
  ActivationAlgorithm activationAlgorithm,
) =>
    (weightedSum) => algorithms[activationAlgorithm]!.last(weightedSum());

double sigmoid(double x) => 1 / (1 + exp(-x));

double relu(double x) => max(0, x);

double lrelu(double x) => max(0.01 * x, x);

double elu(double x, [double hyperparameter = 1]) =>
    x >= 0 ? x : hyperparameter * (exp(x) - 1);

double selu(double x) => 1.0507 * (x < 0 ? 1.67326 * (exp(x) - 1) : x);

double tanh(double x) => (exp(x) - exp(-x)) / (exp(x) + exp(-x));

double softplus(double x) => log(exp(x) + 1);

double softsign(double x) => x / (1 + abs(x));

double swish(double x) => x * sigmoid(x);

double gaussian(double x) => exp(-pow(x, 2));

double sigmoidPrime(double x) => sigmoid(x) * (1 - sigmoid(x));

double reluPrime(double x) => x < 0 ? 0 : 1;

double lreluPrime(double x) => x < 0 ? 0.01 : 1;

double eluPrime(double x, [double hyperparameter = 1]) =>
    x > 0 ? 1 : elu(x, hyperparameter) + hyperparameter;

double seluPrime(double x) => 1.0507 * (x < 0 ? 1.67326 * exp(x) : 1);

double tanhPrime(double x) => 1.0 - pow(tanh(x), 2);

double softplusPrime(double x) => sigmoid(x);

double softsignPrime(double x) => 1 / pow(1 + abs(x), 2);

double swishPrime(double x) => swish(x) + sigmoid(x) * (1 - swish(x));

double gaussianPrime(double x) => -2 * x * gaussian(x);

enum ActivationAlgorithm {
  /// Sigmoid
  sigmoid,

  /// Rectified Linear Unit
  relu,

  /// Leaky Rectified Linear Unit
  lrelu,

  /// Exponential Linear Unit
  elu,

  /// Scaled Exponential Linear Unit
  selu,

  /// Hyperbolic tangent
  tanh,

  /// Softplus
  softplus,

  /// Softsign
  softsign,

  /// Swish
  swish,

  /// Gaussian
  gaussian,
}
