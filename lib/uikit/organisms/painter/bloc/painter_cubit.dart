import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'painter_history.dart';

part 'painter_state.dart';

part 'painter_cubit.freezed.dart';

class PainterCubit extends Cubit<PainterState> {
  final ChangeNotifier notifier;
  final PathHistory pathHistory;

  PainterCubit()
      : notifier = ChangeNotifier(),
        pathHistory = PathHistory(),
        super(
          const PainterState(
            drawColor: Colors.black,
            backgroundColor: Colors.white,
            eraseMode: false,
            thickness: 1.0,
          ),
        ) {
    _updatePaint();
  }

  void onPanStart(DragStartDetails start, BuildContext context) {
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(start.globalPosition);

    pathHistory.add(pos);
    _updatePaint();
  }

  void onPanUpdate(DragUpdateDetails update, BuildContext context) {
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(update.globalPosition);

    pathHistory.updateCurrent(pos);
    _updatePaint();
  }

  void onPanEnd(DragEndDetails end) {
    pathHistory.endCurrent();
    _updatePaint();
  }

  set eraseMode(bool value) {
    emit(state.copyWith(eraseMode: value));
    _updatePaint();
  }

  set drawColor(Color value) {
    emit(state.copyWith(drawColor: value));
    _updatePaint();
  }

  set backgroundColor(Color value) {
    emit(state.copyWith(backgroundColor: value));
    _updatePaint();
  }

  set thickness(double value) {
    emit(state.copyWith(thickness: value));
    _updatePaint();
  }

  void undo() {
    pathHistory.undo();
    notifier.notifyListeners();
  }

  void clear() {
    pathHistory.clear();
    notifier.notifyListeners();
  }

  void _updatePaint() {
    Paint paint = Paint();

    if (state.eraseMode) {
      paint.blendMode = BlendMode.clear;
      paint.color = const Color.fromARGB(0, 255, 0, 0);
    } else {
      paint.color = state.drawColor;
      paint.blendMode = BlendMode.srcOver;
    }
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = state.thickness;
    paint.strokeJoin = StrokeJoin.round;

    pathHistory.currentPaint = paint;
    pathHistory.setBackgroundColor(state.backgroundColor);

    notifier.notifyListeners();
  }
}
