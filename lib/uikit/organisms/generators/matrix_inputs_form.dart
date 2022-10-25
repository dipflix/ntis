import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labs/bloc/bloc.dart';
import 'package:labs/shared/file_manager/file_manager.dart';

import 'package:labs/uikit/uikit.dart';

class MatrixInputsForm extends StatelessWidget {
  final int width;
  final int height;

  const MatrixInputsForm({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<InputMatrixBloc, InputMatrixState>(
              builder: (context, state) {
                List<String> files =
                    state.files.map((e) => e.path.split('/')[1]).toList();

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: GridView.count(
                        crossAxisCount: 4,
                        children: [
                          ...List.generate(files.length, (index) {
                            final file = files.elementAt(index);

                            return InkWell(
                              onTap: () {
                                context.read<InputMatrixBloc>().add(
                                      InputMatrixEvent.onLoadFile(
                                        "${FileManager.wordsPath}/$file",
                                      ),
                                    );
                              },
                              child: Center(child: Text(file)),
                            );
                          }),
                        ],
                      ),
                    ),
                    Gap.vertical.regular(),
                    Column(
                      children: [
                        ...List.generate(
                          state.matrix.columns,
                          (y) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...generateRows(state, y, context),
                              ],
                            );
                          },
                        ),
                        Gap.horizontal.regular(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            clearButton(context),
                            Gap.vertical.large(),
                            saveButton(context),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton clearButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<InputMatrixBloc>().add(
              const InputMatrixEvent.onClear(),
            );
      },
      child: const Text("Clear"),
    );
  }

  ElevatedButton saveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (dialogContext) {
            TextEditingController fileNameField = TextEditingController();
            return AlertDialog(
              content: TextField(
                controller: fileNameField,
                decoration: const InputDecoration(
                  label: Text('File name'),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    context.read<InputMatrixBloc>().add(
                          InputMatrixEvent.onSaveToFile(
                            FileManager.wordsPath,
                            fileNameField.text,
                          ),
                        );
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
      child: const Text("Save to file"),
    );
  }

  List<Widget> generateRows(
      InputMatrixState state, int y, BuildContext context) {
    return List.generate(
      state.matrix.rows,
      (x) {
        return Padding(
          padding: const EdgeInsets.only(
            right: 8,
            bottom: 8,
          ),
          child: MatrixItem(
            active: state.matrix.itemAt(x + 1, y + 1) != 0,
            onPressed: () async {
              context.read<InputMatrixBloc>().add(
                    InputMatrixEvent.onChangeCellStatus(
                      x + 1,
                      y + 1,
                      onChange: (matrix) {
                        context.read<NeuralNetworkBloc>().add(
                              NeuralNetworkEvent.doDiscernWord(
                                matrix.toListDouble(),
                              ),
                            );
                      },
                    ),
                  );
            },
          ),
        );
      },
    );
  }
}
