import 'dart:convert';

import 'package:labs/shared/file_manager/file_manager.dart';
import 'package:labs/shared/neural/activation.dart';
import 'package:sprint/sprint.dart';
import '../layers/layer.dart';

class Network {

  final Stopwatch stopwatch = Stopwatch();

  final Sprint log = Sprint('Network', quietMode: true);

  late List<Layer> layers = [];

  double learningRate;

  Network({required this.learningRate, List<Layer>? layers}) {
    if (layers != null) {
      addLayers(layers);
    }
  }

  List<double> process(List<double> inputs) {
    var output = inputs;

    for (final layer in layers) {
      layer.accept(output);
      output = layer.output;
    }

    return output;
  }

  void addLayer(Layer layer) {
    layer.initialise(
      parentLayerSize: layers.isEmpty ? 0 : layers.last.size,
      learningRate: learningRate,
    );

    layers.add(layer);

    log.info('Added layer of size ${layer.neurons.length}.');
  }

  void addLayers(List<Layer> layers) {
    for (final layer in layers) {
      addLayer(layer);
    }
  }

  void clear() {
    if (layers.isEmpty) {
      log.warning('Attempted to reset an already empty network.');
      return;
    }

    stopwatch.reset();
    layers.clear();

    log.success('Network reset successfully.');
  }

  Future<void> saveToJson() async {
    await FileManager.write(
      'network',
      'network.json',
      json.encode([
        ...layers.map(
          (e) => e.toJson(),
        ),
      ]),
    );
  }

  Future<void> initFromFile() async {
    final data = await FileManager.read('network/network.json');
    if (data != null) {
      List<dynamic> jsonData = json.decode(data);
      final layersJson = jsonData.map<Map<String, dynamic>>((e) => e);

      List<Layer> layers = List.generate(layersJson.length, (index) {
        var json = layersJson.elementAt(index);
        var size = json['size'] as int;
        var isInput = json['isInput'] as bool;
        var layer = Layer(size: size, activation: ActivationAlgorithm.sigmoid);

        List<Map<String, dynamic>> neurons = (json['neurons'] as List<dynamic>)
            .map<Map<String, dynamic>>((e) => e)
            .toList();

        layer.initializeFromJsonNeurons(neurons);

        print(layer.neurons[0].weights);

        return layer;
      });

      this.layers = layers;
      print(this.layers.first.neurons.length);
    }
  }
}
