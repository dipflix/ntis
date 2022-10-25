part of 'input_matrix_bloc.dart';

@freezed
class InputMatrixState with _$InputMatrixState {
  const factory InputMatrixState({
    required Iterable<FileSystemEntity> files,
    required Matrix matrix,
  }) = _InputMatrixState;
}
