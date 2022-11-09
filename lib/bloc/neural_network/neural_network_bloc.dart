import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:labs/shared/file_manager/file_manager.dart';
import 'package:labs/shared/neural/neural.dart';
import 'package:meta/meta.dart';

part 'neural_network_bloc.freezed.dart';

part 'neural_network_event.dart';

part 'neural_network_state.dart';

abstract class NeuralNetworkBloc
    extends Bloc<NeuralNetworkEvent, NeuralNetworkState> {
  NeuralNetworkBloc(super.initialState);

  Network get network;
}

class NeuralNetworkBlocImpl extends NeuralNetworkBloc {
  @override
  late Sequential network;

  var receivePort = ReceivePort();

  late List<List<double>> trainingData;

  NeuralNetworkBlocImpl()
      : network = Sequential(learningRate: 0.01),
        super(
          const NeuralNetworkState(
            status: NeuralNetworkStatus.initializing,
          ),
        ) {
    loadDataFromFile().then((value) => trainingData = value);
    network.initFromFile();

    receivePort.listen((message) {
      emit(state.copyWith(status: NeuralNetworkStatus.trainingEnd));
    });

    on<NeuralNetworkEvent_DoTrain>(_doTrain);
    on<NeuralNetworkEvent_DoDiscernWord>(_doDiscernWord);
  }

  Future<void> _doTrain(
    NeuralNetworkEvent_DoTrain event,
    Emitter<NeuralNetworkState> emit,
  ) async {
    emit(state.copyWith(status: NeuralNetworkStatus.trainingStart));

    await Future.delayed(const Duration(milliseconds: 500));
    List<List<double>> expected = generateExpected(trainingData.length);

    network = Sequential(learningRate: 0.01, layers: [
      Layer(
        size: trainingData.first.length,
        activation: ActivationAlgorithm.sigmoid,
      ),
      Layer(
        size: trainingData.length,
        activation: ActivationAlgorithm.sigmoid,
      ),
      Layer(
        size: trainingData.length,
        activation: ActivationAlgorithm.sigmoid,
      ),
    ]);

    await network.train(
        inputs: trainingData,
        expected: expected,
        iterations: 500,
        receivePort: receivePort);

    //  await network.saveToJson();
  }

  List<List<double>> generateExpected(int length) {
    List<List<double>> result = [];

    for (int i = 0; i < length; i++) {
      List<double> temp = [];
      for (int j = 0; j < length; j++) {
        temp.add(0.001);
      }
      temp[i] = 1;
      result.add(temp);
    }

    return result;
  }

  Future<List<List<double>>> loadDataFromFile() async {
    var files = await FileManager.ls();

    List<List<double>> inputs = [];

    for (int i = 0; i < files.length; i++) {
      var element = files[i];
      final matrixString = await FileManager.read(element.path);
      final List<dynamic> listParsed = jsonDecode(matrixString ?? '[]');

      List<double> listData = [];

      for (int j = 0; j < listParsed.length; j++) {
        listData.addAll(List<double>.from(listParsed[j]));
      }
      inputs.add(listData);
    }
    return inputs;
  }

  Future<void> _doDiscernWord(
    NeuralNetworkEvent_DoDiscernWord event,
    Emitter<NeuralNetworkState> emit,
  ) async {
    emit(
      NeuralNetworkState(
        status: NeuralNetworkStatus.ready,
        outputs: network.process(event.value).map(
              (e) => e.toString(),
            ),
      ),
    );
  }
}
