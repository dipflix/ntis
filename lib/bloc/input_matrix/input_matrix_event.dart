part of 'input_matrix_bloc.dart';

@freezed
class InputMatrixEvent with _$InputMatrixEvent {
  const factory InputMatrixEvent.onChangeCellStatus(
    int x,
    int y, {
    Function(Matrix data)? onChange,
  }) = InputMatrixEvent_OnChangeCellStatus;

  const factory InputMatrixEvent.onClear() = InputMatrixEvent_OnClear;

  const factory InputMatrixEvent.onSubmit() = InputMatrixEvent_OnSubmit;

  const factory InputMatrixEvent.onSaveToFile(String dirName, String fileName) =
      InputMatrixEvent_OnSaveToFile;

  const factory InputMatrixEvent.onLoadFile(String fileName) =
      InputMatrixEvent_OnLoadFile;
}
