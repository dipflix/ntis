import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:labs/shared/neural/networks/network.dart';
import 'package:collection/collection.dart';

class NeuronWeightsInformation extends StatefulWidget {
  final Network network;

  const NeuronWeightsInformation({
    Key? key,
    required this.network,
  }) : super(key: key);

  @override
  State<NeuronWeightsInformation> createState() =>
      _NeuronWeightsInformationState();
}

class _NeuronWeightsInformationState extends State<NeuronWeightsInformation> {
  double size = 300;

  late final neuronsLen =
      widget.network.layers.last.neurons.first.weights.length.toDouble();
  late final layersLen = widget.network.layers.last.neurons.length.toDouble();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ScatterSpot> spots = [];

    for (var i = 0; i < widget.network.layers.last.neurons.length; i++) {
      var neuron = widget.network.layers.last.neurons[i];

      for (var j = 0; j < neuron.weights.length; j++) {
        var weight = neuron.weights[j];

        spots.add(
          ScatterSpot(
            (i * neuron.output).toDouble(),
            (weight).toDouble(),
            color: Color.fromRGBO(
              (i * neuron.output * 100).toInt(),
              (neuron.output).toInt(),
              (neuron.output).toInt(),
              100,
            ),
          ),
        );
      }
    }
    //
    // for (var l = 0; l < widget.network.layers.length; l++) {
    //   var layer = widget.network.layers[l];
    //
    //   for (var i = 0; i < layer.neurons.length; i++) {
    //     var neuron = widget.network.layers[l].neurons[i];
    //
    //
    //     // for (var j = 0; j < neuron.weights.length; j++) {
    //     //   var weight = neuron.weights[j];
    //     //
    //     //
    //     // }
    //   }
    // }

    return SizedBox.square(
      dimension: size * 2,
      child: ScatterChart(
        ScatterChartData(
          scatterSpots: spots,
          minX: 0,
          maxX: 10,
          minY: -10,
          maxY: 10,
          borderData: FlBorderData(
            show: true,
          ),
          gridData: FlGridData(
            show: true,
          ),
          titlesData: FlTitlesData(
            show: true,
          ),
          scatterTouchData: ScatterTouchData(
            enabled: true,
            touchTooltipData: ScatterTouchTooltipData(getTooltipItems: (spots) {
              return ScatterTooltipItem(spots.y.toInt().toString());
            }),
          ),
        ),
        swapAnimationDuration: const Duration(milliseconds: 600),
        swapAnimationCurve: Curves.fastOutSlowIn,
      ),
    );
  }
}
