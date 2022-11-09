/// Provides a widget and an associated controller for simple painting using touch.
library painter;

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labs/uikit/organisms/organisms.dart';
import 'package:labs/uikit/organisms/painter/bloc/painter_cubit.dart';

import 'bloc/painter_history.dart';

class Painter extends StatefulWidget {
  final void Function() onSave;

  const Painter({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  @override
  State<Painter> createState() => _PainterState();
}

class _PainterState extends State<Painter> {
  late final PainterCubit painterCubit;

  @override
  void initState() {
    painterCubit = PainterCubit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: painterCubit,
      child: BlocBuilder<PainterCubit, PainterState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox.square(
                dimension: 256 * 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade900,
                    ),
                  ),
                  child: GestureDetector(
                    onPanStart: (DragStartDetails details) =>
                        painterCubit.onPanStart(details, context),
                    onPanUpdate: (DragUpdateDetails details) =>
                        painterCubit.onPanUpdate(details, context),
                    onPanEnd: (DragEndDetails details) =>
                        painterCubit.onPanEnd(details),
                    child: CustomPaint(
                      willChange: true,
                      size: const Size.square(24),
                      painter: ListenablePainter(
                        painterCubit.pathHistory,
                        repaint: painterCubit.notifier,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: painterCubit.undo,
                    child: const Text('Undo'),
                  ),
                  TextButton(
                    onPressed: painterCubit.clear,
                    child: const Text('clear'),
                  ),
                  SizedBox(
                    width: 256,
                    child: Slider(
                      min: 1,
                      max: 25,
                      value: state.thickness,
                      onChanged: (value) {
                        painterCubit.thickness = value;
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class ListenablePainter extends CustomPainter {
  final PathHistory _path;

  ListenablePainter(this._path, {Listenable? repaint})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _path.draw(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _PainterPainter extends CustomPainter {
  final PathHistory _path;

  _PainterPainter(this._path, {Listenable? repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _path.draw(canvas, size);
  }

  @override
  bool shouldRepaint(_PainterPainter oldDelegate) {
    return true;
  }
}

//
// /// A very simple widget that supports drawing using touch.
// class PainterOld extends StatefulWidget {
//   final PainterController painterController;
//
//   /// Creates an instance of this widget that operates on top of the supplied [PainterController].
//   PainterOld(this.painterController)
//       : super(key: ValueKey<PainterController>(painterController));
//
//   @override
//   _PainterOldState createState() => _PainterOldState();
// }
//
// class _PainterOldState extends State<PainterOld> {
//   bool _finished = false;
//
//   @override
//   void initState() {
//     super.initState();
//     widget.painterController._widgetFinish = _finish;
//   }
//
//   Size _finish() {
//     setState(() {
//       _finished = true;
//     });
//     return context.size ?? const Size(0, 0);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Widget child = CustomPaint(
//       willChange: true,
//       painter: _PainterPainter(widget.painterController._pathHistory,
//           repaint: widget.painterController),
//     );
//     child = ClipRect(child: child);
//     if (!_finished) {
//       child = GestureDetector(
//         onPanStart: _onPanStart,
//         onPanUpdate: _onPanUpdate,
//         onPanEnd: _onPanEnd,
//         child: child,
//       );
//     }
//     return SizedBox(
//       width: double.infinity,
//       height: double.infinity,
//       child: child,
//     );
//   }
//
//   void _onPanStart(DragStartDetails start) {
//     Offset pos = (context.findRenderObject() as RenderBox)
//         .globalToLocal(start.globalPosition);
//     widget.painterController._pathHistory.add(pos);
//     widget.painterController._notifyListeners();
//   }
//
//   void _onPanUpdate(DragUpdateDetails update) {
//     Offset pos = (context.findRenderObject() as RenderBox)
//         .globalToLocal(update.globalPosition);
//     widget.painterController._pathHistory.updateCurrent(pos);
//     widget.painterController._notifyListeners();
//   }
//
//   void _onPanEnd(DragEndDetails end) {
//     widget.painterController._pathHistory.endCurrent();
//     widget.painterController._notifyListeners();
//   }
// }

//
// /// Used with a [PainterOld] widget to control drawing.
// class PainterController extends ChangeNotifier {
//   Color _drawColor = const Color.fromARGB(255, 0, 0, 0);
//   Color _backgroundColor = const Color.fromARGB(255, 255, 255, 255);
//   bool _eraseMode = false;
//
//   double _thickness = 1.0;
//   PictureDetails? _cached;
//   final PathHistory _pathHistory;
//   ValueGetter<Size>? _widgetFinish;
//
//   /// Creates a new instance for the use in a [PainterOld] widget.
//   PainterController() : _pathHistory = PathHistory();
//
//   /// Returns true if nothing has been drawn yet.
//   bool get isEmpty => _pathHistory.isEmpty;
//
//   /// Returns true if the the [PainterController] is currently in erase mode,
//   /// false otherwise.
//   bool get eraseMode => _eraseMode;
//
//   /// If set to true, erase mode is enabled, until this is called again with
//   /// false to disable erase mode.
//   set eraseMode(bool enabled) {
//     _eraseMode = enabled;
//     _updatePaint();
//   }
//
//   /// Retrieves the current draw color.
//   Color get drawColor => _drawColor;
//
//   /// Sets the draw color.
//   set drawColor(Color color) {
//     _drawColor = color;
//     _updatePaint();
//   }
//
//   /// Retrieves the current background color.
//   Color get backgroundColor => _backgroundColor;
//
//   /// Updates the background color.
//   set backgroundColor(Color color) {
//     _backgroundColor = color;
//     _updatePaint();
//   }
//
//   /// Returns the current thickness that is used for drawing.
//   double get thickness => _thickness;
//
//   /// Sets the draw thickness..
//   set thickness(double t) {
//     _thickness = t;
//     _updatePaint();
//   }
//
//   void _updatePaint() {
//     Paint paint = Paint();
//     if (_eraseMode) {
//       paint.blendMode = BlendMode.clear;
//       paint.color = const Color.fromARGB(0, 255, 0, 0);
//     } else {
//       paint.color = drawColor;
//       paint.blendMode = BlendMode.srcOver;
//     }
//     paint.style = PaintingStyle.stroke;
//     paint.strokeWidth = thickness;
//     _pathHistory.currentPaint = paint;
//     _pathHistory.setBackgroundColor(backgroundColor);
//     notifyListeners();
//   }
//
//   /// Undoes the last drawing action (but not a background color change).
//   /// If the picture is already finished, this is a no-op and does nothing.
//   void undo() {
//     if (!isFinished()) {
//       _pathHistory.undo();
//       notifyListeners();
//     }
//   }
//
//   void _notifyListeners() {
//     notifyListeners();
//   }
//
//   /// Deletes all drawing actions, but does not affect the background.
//   /// If the picture is already finished, this is a no-op and does nothing.
//   void clear() {
//     if (!isFinished()) {
//       _pathHistory.clear();
//       notifyListeners();
//     }
//   }
//
//   /// Finishes drawing and returns the rendered [PictureDetails] of the drawing.
//   /// The drawing is cached and on subsequent calls to this method, the cached
//   /// drawing is returned.
//   ///
//   /// This might throw a [StateError] if this PainterController is not attached
//   /// to a widget, or the associated widget's [Size.isEmpty].
//   PictureDetails finish() {
//     if (!isFinished()) {
//       if (_widgetFinish != null) {
//         _cached = _render(_widgetFinish!());
//       } else {
//         throw StateError(
//             'Called finish on a PainterController that was not connected to a widget yet!');
//       }
//     }
//     return _cached!;
//   }
//
//   PictureDetails _render(Size size) {
//     if (size.isEmpty) {
//       throw StateError('Tried to render a picture with an invalid size!');
//     } else {
//       PictureRecorder recorder = PictureRecorder();
//
//       Canvas canvas = Canvas(recorder);
//
//       _pathHistory.draw(canvas, size);
//       return PictureDetails(
//           recorder.endRecording(), size.width.floor(), size.height.floor());
//     }
//   }
//
//   /// Returns true if this drawing is finished.
//   ///
//   /// Trying to modify a finished drawing is a no-op.
//   bool isFinished() {
//     return _cached != null;
//   }
// }
