import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labs/bloc/bloc.dart';
import 'package:labs/uikit/uikit.dart';

class HomeScreen extends StatelessWidget {
  late InputMatrixBloc cubit;
  late NeuralNetworkBloc networkBloc;

  HomeScreen({Key? key}) : super(key: key) {
    cubit = InputMatrixBloc(5, 7);

    networkBloc = NeuralNetworkBlocImpl();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: cubit),
        BlocProvider.value(value: networkBloc),
      ],
      child: Scaffold(
        body: BlocListener<NeuralNetworkBloc, NeuralNetworkState>(
          listener: (context, state) {
            if (state.status == NeuralNetworkStatus.trainingStart) {
              showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  });
            } else if (state.status == NeuralNetworkStatus.trainingEnd) {
              Navigator.of(context).pop();
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDrawingMatrixCard(),
                      Gap.vertical.regular(),
                      // Text(
                      //     "Layers length: ${networkBloc.layers.length.toString()}",
                      //     style: textTheme.headlineSmall),
                      BlocBuilder<NeuralNetworkBloc, NeuralNetworkState>(
                        builder: (context, neuralState) {
                          return BlocBuilder<InputMatrixBloc, InputMatrixState>(
                            builder: (context, matrixState) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  generateNeuronsView(
                                      matrixState, neuralState.outputs),
                                  // NeuronWeightsInformation(
                                  //   network: networkBloc.network,
                                  // ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      Gap.vertical.regular(),
                      buildActionsCard(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget generateNeuronsView(InputMatrixState state, Iterable<String>? data) {
    if (data == null) {
      return const SizedBox.shrink();
    }

    List<Widget> items = [];

    for (int i = 0; i < state.files.length; i++) {
      var element = state.files.elementAt(i);
      final file = element.path.split('/')[1];
      final colorPerc = double.parse(data.elementAt(i));
      items.add(
        AnimatedContainer(
          width: 200,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(
              colorPerc > 1 ? 1 : colorPerc,
            ),
          ),
          duration: const Duration(milliseconds: 500),
          curve: Curves.linearToEaseOut,
          child: Center(
              child: Text(
            "$file  ${double.parse(data.elementAt(i)).toStringAsFixed(4)} ($i)",
            style: const TextStyle(fontSize: 14),
          )),
        ),
      );
    }

    return Column(
      children: [
        ...items,
      ],
    );
  }

  Card buildDrawingMatrixCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: MatrixInputsForm(
          width: 5,
          height: 9,
        ),
      ),
    );
  }

  Card buildActionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Gap.horizontal.regular(),
            ElevatedButton(
              onPressed: () async {
                networkBloc.add(const NeuralNetworkEvent.doTrain());
              },
              child: const Text('Start training'),
            ),
            Gap.horizontal.regular(),
            ElevatedButton(
              onPressed: () {
                networkBloc.add(
                  NeuralNetworkEvent.doDiscernWord(
                    cubit.state.matrix.toListDouble(),
                  ),
                );
              },
              child: const Text('Discern word'),
            ),
          ],
        ),
      ),
    );
  }
}
