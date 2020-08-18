import 'package:flutter/material.dart';

class Resize {
  static ResizeData of(BuildContext context) {
    final query = MediaQuery.of(context);
    final size = query.orientation == Orientation.landscape
        ? query.size.width
        : query.size.height;

    final isTablet = size > 640;

    return ResizeData(
        textSize1: isTablet ? 24 : 16,
        textSize2: isTablet ? 32 : 24,
        textBigSize1: isTablet ? 72 : 48,
        textBigSize2: isTablet ? 96 : 72,
        buttonSize1: isTablet ? 80 : 60,
        buttonSize2: isTablet ? 120 : 80,
        padding1: isTablet ? 8 : 4,
        padding2: isTablet ? 16 : 8);
  }
}

class ResizeData {
  final double textBigSize2;
  final double textBigSize1;
  final double textSize2;
  final double textSize1;
  final double buttonSize1;
  final double buttonSize2;
  final double padding1;
  final double padding2;

  ResizeData(
      {this.textSize1,
      this.textSize2,
      this.textBigSize1,
      this.textBigSize2,
      this.buttonSize1,
      this.buttonSize2,
      this.padding1,
      this.padding2});
}
