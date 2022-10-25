//
//
// abstract class InputMatrixCubit extends Cubit<InputMatrixState> {
//   InputMatrixCubit(super.initialState);
//
//   void changeCellActive(int x, int y);
// }
//
// class InputMatrixCubitImpl extends InputMatrixCubit {
//   InputMatrixCubitImpl()
//       : super(
//           const InputMatrixState(matrix: []),
//         );
//
//   void generate(int width, int height) {
//     final generatedMatrix = [
//       ...List.filled(
//         width * height,
//         false,
//       ),
//     ];
//
//     emit(
//       InputMatrixState(
//         matrix: generatedMatrix,
//       ),
//     );
//   }
//
//   @override
//   void changeCellActive(int x, int y) {
//     var newMatrix = [...state.matrix];
//     newMatrix.insert(x * y, !newMatrix[x * y]);
//
//     emit(InputMatrixState(matrix: newMatrix));
//   }
// }
