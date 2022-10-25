part of 'neural_network_bloc.dart';

enum NeuralInitializingStatus { uninitialized, loadedFromFile }

enum NeuralNetworkStatus {
  initializing,
  trainingStart,
  trainingEnd,
  process,
  ready,
}

@freezed
class NeuralNetworkState with _$NeuralNetworkState {

  const factory NeuralNetworkState({
    required NeuralNetworkStatus status,
    Iterable<String>? outputs,
  }) = NeuralNetworState_Result;
}
