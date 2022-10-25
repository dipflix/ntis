import 'package:flutter/material.dart';

enum GapType {
  horizontal,
  vertical,
}

class Gap {
  final GapType type;

  late final double? height;
  late final double? width;

  Gap({
    Key? key,
    required this.type,
    this.width,
    this.height,
  });

  static Gap horizontal = Gap(type: GapType.horizontal);
  static Gap vertical = Gap(type: GapType.vertical);

  SizedBox small() {
    if (type == GapType.horizontal) {
      return const SizedBox(height: 8);
    } else {
      return const SizedBox(width: 8);
    }
  }

  SizedBox regular() {
    if (type == GapType.horizontal) {
      return const SizedBox(height: 16);
    } else {
      return const SizedBox(width: 16);
    }
  }

  SizedBox medium() {
    if (type == GapType.horizontal) {
      return const SizedBox(height: 24);
    } else {
      return const SizedBox(width: 24);
    }
  }

  SizedBox large() {
    if (type == GapType.horizontal) {
      return const SizedBox(height: 32);
    } else {
      return const SizedBox(width: 32);
    }
  }

  SizedBox big() {
    if (type == GapType.horizontal) {
      return const SizedBox(height: 48);
    } else {
      return const SizedBox(width: 48);
    }
  }
}
