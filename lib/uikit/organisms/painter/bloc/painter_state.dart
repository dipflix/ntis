part of 'painter_cubit.dart';

@freezed
class PainterState with _$PainterState {
  const factory PainterState({
    required Color drawColor,
    required Color backgroundColor,
    required bool eraseMode,
    required double thickness,
  }) = _PainterState;
}
