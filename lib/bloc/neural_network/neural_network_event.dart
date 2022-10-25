part of 'neural_network_bloc.dart';

@freezed
class NeuralNetworkEvent with _$NeuralNetworkEvent {
  const factory NeuralNetworkEvent.doTrain() = NeuralNetworkEvent_DoTrain;
  const factory NeuralNetworkEvent.doDiscernWord(List<double> value) = NeuralNetworkEvent_DoDiscernWord;
}
