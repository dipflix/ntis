import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:extended_math/extended_math.dart';
import 'package:labs/shared/file_manager/file_manager.dart';

part 'input_matrix_event.dart';

part 'input_matrix_state.dart';

part 'input_matrix_bloc.freezed.dart';

class InputMatrixBloc extends Bloc<InputMatrixEvent, InputMatrixState> {
  final int _width;
  final int _height;

  InputMatrixBloc(
    this._width,
    this._height,
  ) : super(
          InputMatrixState(
            matrix: Matrix.generate(_width, _height),
            files: [],
          ),
        ) {
    on<InputMatrixEvent_OnChangeCellStatus>(_onChangeCellStatus);
    on<InputMatrixEvent_OnClear>(_onClear);
    on<InputMatrixEvent_OnSubmit>(_onSubmit);
    on<InputMatrixEvent_OnSaveToFile>(_onSaveTofile);
    on<InputMatrixEvent_OnLoadFile>(_onLoadFile);

    Future.microtask(() async {
      emit(
        state.copyWith(
          files: await FileManager.ls(),
        ),
      );
    });
  }

  void _onChangeCellStatus(
    InputMatrixEvent_OnChangeCellStatus event,
    Emitter<InputMatrixState> emit,
  ) {
    var newMatrix = Matrix(
      [
        ...state.matrix.data.map(
          (e) => [...e],
        ),
      ],
    );

    newMatrix.setItem(
      event.x,
      event.y,
      newMatrix.itemAt(event.x, event.y) == 0 ? 1 : 0,
    );

    emit(state.copyWith(matrix: newMatrix));
    event.onChange?.call(state.matrix);
  }

  void _onClear(
    InputMatrixEvent_OnClear event,
    Emitter<InputMatrixState> emit,
  ) {
    emit(
      state.copyWith(
        matrix: Matrix.generate(_width, _height),
      ),
    );
  }

  void _onSubmit(
    InputMatrixEvent_OnSubmit event,
    Emitter<InputMatrixState> emit,
  ) {}

  Future<void> _onSaveTofile(
    InputMatrixEvent_OnSaveToFile event,
    Emitter<InputMatrixState> emit,
  ) async {
    await FileManager.write(
      event.dirName,
      event.fileName,
      [
        ...state.matrix.data.map((e) => e),
      ].toString(),
    );

    emit(
      state.copyWith(
        files: await FileManager.ls(),
      ),
    );
  }

  Future<void> _onLoadFile(
    InputMatrixEvent_OnLoadFile event,
    Emitter<InputMatrixState> emit,
  ) async {
    final matrixString = await FileManager.read(event.fileName);
    final List<dynamic> listData = jsonDecode(matrixString ?? '[]');

    emit(
      state.copyWith(
        matrix: Matrix(
          listData.map((e) => List<double>.from(e)).toList(),
        ),
      ),
    );
  }
}

extension MatrixExtensions on Matrix {
  List<double> toListDouble() {
    List<double> result = [];

    for (var element in data) {
      for (var element in element) {
        result.add(element);
      }
    }

    return result;
  }
}
