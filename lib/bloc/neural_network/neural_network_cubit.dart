// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
//
// import 'package:bloc/bloc.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:labs/shared/file_manager/file_manager.dart';
// import 'package:labs/shared/neural/neural.dart';
//
// import 'neural_network_bloc.dart';
//
// part 'neural_network_state.dart';
//
// part 'neural_network_cubit.freezed.dart';
//
// Future<Dataset> loadDataset() async {
//   Dataset dataset = Dataset();
//
//   var files = await FileManager.ls();
//
//   List<List<double>> inputs = [];
//   List<List<double>> outputs = [];
//
//   for (int i = 0; i < files.length; i++) {
//     var element = files[i];
//     final matrixString = await FileManager.read(element.path);
//     final List<dynamic> listParsed = jsonDecode(matrixString ?? '[]');
//
//     List<double> listData = [];
//
//     for (int j = 0; j < listParsed.length; j++) {
//       listData.addAll(List<double>.from(listParsed[j]));
//     }
//     dataset.pairs.add(Pair(listData, i.toDouble()));
//   }
//
//   return dataset;
// }
//
// abstract class NeuralNetworkCubit extends Cubit<NeuralNetworkState> {
//   NeuralNetworkCubit(super.initialState);
//
//   List<Layer> get layers;
//
//   Future<void> train();
//
//   Future<void> discernWord(List<double> value);
// }
//
// class NeuralNetworkCubitImpl extends NeuralNetworkCubit {
//   final int size;
//
//   @override
//   List<Layer> layers = [];
//
//   NeuralNetworkCubitImpl(this.size)
//       : super(const NeuralNetworkState.unknown()) {
//     layers = List.filled(size, Layer.empty());
//   }
//
//   @override
//
//
//   Future<void> _forward(List<double> inputs) async {
//     layers[0] = Layer(inputs);
//
//     // Forward propagation
//     for (int i = 1; i < layers.length; i++) {
//       // Starts from 1st hidden layer
//       for (int j = 0; j < layers[i].neurons.length; j++) {
//         double sum = 0;
//
//         for (int k = 0; k < layers[i - 1].neurons.length; k++) {
//           sum +=
//               layers[i - 1].neurons[k].value * layers[i].neurons[j].weights[k];
//         }
//         layers[i].neurons[j].value = NeuralUtils.sigmoid(sum);
//       }
//     }
//   }
//
//   Future<void> _backward(double learningRate, Pair datas) async {
//     int numberLayers = layers.length;
//     int outputLayerIndex = numberLayers - 1;
//
//     // Обновление выходных слоев
//
//     for (int i = 0; i < layers[outputLayerIndex].neurons.length; i++) {
//       // Проходымось по кожному выходуъ
//
//       double output = layers[outputLayerIndex].neurons[i].value;
//       double target = datas.outputData;
//       double derivative = output - target;
//       double delta = derivative * (output * (1 - output));
//
//       layers[outputLayerIndex].neurons[i].gradient = delta;
//
//       for (int j = 0;
//           j < layers[outputLayerIndex].neurons[i].weights.length;
//           j++) {
//         // и по каждому их весу
//         double previousOutput = layers[outputLayerIndex - 1].neurons[j].value;
//         double error = delta * previousOutput;
//
//         layers[outputLayerIndex].neurons[i].weightsOld[j] =
//             layers[outputLayerIndex].neurons[i].weights[j] -
//                 learningRate * error;
//       }
//     }
//
//     // Update all the subsequent hidden layers
//     for (int i = outputLayerIndex - 1; i > 0; i--) {
//       // Backward
//       for (int j = 0; j < layers[i].neurons.length; j++) {
//         // For all neurons in that layers
//         double output = layers[i].neurons[j].value;
//
//         double gradientSum = _sumGradient(j, i + 1);
//         double delta = (gradientSum) * (output * (1 - output));
//         layers[i].neurons[j].gradient = delta;
//
//         for (int k = 0; k < layers[i].neurons[j].weights.length; k++) {
//           // And for all their weights
//
//           double previousOutput = layers[i - 1].neurons[k].value;
//           double error = delta * previousOutput;
//           layers[i].neurons[j].weightsOld[k] =
//               layers[i].neurons[j].weights[k] - learningRate * error;
//         }
//       }
//     }
//
//     // Update all the weights
//     for (int i = 0; i < layers.length; i++) {
//       for (int j = 0; j < layers[i].neurons.length; j++) {
//         layers[i].neurons[j].updateWeights();
//       }
//     }
//   }
//
// // This function sums up all the gradient connecting a given neuron in a given layer
//
//
// // This function is used to train
//   Future<void> _train(Dataset dt, int iteration, double learningRate) async {
//     for (int i = 0; i < iteration; i++) {
//       for (int j = 0; j < dt.length; j++) {
//         await _forward(dt.pairs[j].inputData);
//         await _backward(learningRate, dt.pairs[j]);
//       }
//     }
//   }
//
//   @override
//   Future<void> discernWord(List<double> value) async {
//     emit(const NeuralNetworkState.calculate());
//     await _forward(value);
//
//     for (var e in layers[2].neurons) {}
//     emit(
//       NeuralNetworkState.ready(
//         outputNeurons: layers.last.neurons,
//       ),
//     );
//   }
// }
