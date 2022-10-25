import 'package:flutter/material.dart';

class MatrixItem extends StatefulWidget {
  final bool active;
  final void Function() onPressed;

  const MatrixItem({
    Key? key,
    required this.active,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<MatrixItem> createState() => _MatrixItemState();
}

class _MatrixItemState extends State<MatrixItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.active ? Colors.black : Colors.grey.shade200,
          border: Border.all(
            color: widget.active ? Colors.black : Colors.grey.shade400,
          )
          ,
        ),
        child: const SizedBox(
          width: 42,
          height: 42,
        ),
      ),
    );
  }
}
