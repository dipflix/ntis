

import 'training/backpropagation.dart';
import 'network.dart';


class Sequential extends Network with Backpropagation {

  Sequential({
    required super.learningRate,
    super.layers,
  });
}
