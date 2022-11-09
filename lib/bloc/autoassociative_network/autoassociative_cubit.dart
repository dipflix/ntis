import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:labs/bloc/status.dart';
import 'package:rxdart/rxdart.dart';

import '../../shared/neural/neural.dart';

part 'autoassociative_state.dart';

part 'autoassociative_cubit.freezed.dart';

class AutoassociativeCubit extends Cubit<AutoassociativeState> {
  late Sequential network;
  final PublishSubject publishSubject;

  AutoassociativeCubit()
      : network = Sequential(learningRate: 0.01),
        publishSubject = PublishSubject(),
        super(const AutoassociativeState(status: BlocActionStatus.done)) {
    late List<List<double>> trainingData = [];

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
  }
}
