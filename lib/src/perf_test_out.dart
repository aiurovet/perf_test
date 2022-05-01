// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// A class to display of test and test lot results
///
class PerfTestOut {
  /// The formatter
  ///
  late final PerfTestFormat format;

  /// The convenience lot object
  ///
  final PerfTestLot lot;

  /// The constructor
  ///
  PerfTestOut(this.lot) {
    format = lot.format;
  }

  /// The printing
  ///
  void exec() {
    final border = _getBorder();

    _execName(border);
    _execData(border);
  }

  /// Ensure every string is embraced in quotes if needed, all internal quotes are escaped,
  /// and the field separator appended if the string does not represent the last field
  ///
  String _adjustQuotes(String fieldValue) {
    final isRaw = format.dataStyle.isRaw;
    final hasQuote = isRaw && fieldValue.contains(format.quote);
    final hasSep = isRaw && fieldValue.contains(format.fieldSeparator);

    if (hasQuote || hasSep) {
      return format.quote +
          fieldValue.replaceAll(format.quote, format.quoteEscaped) +
          format.quote;
    }

    return fieldValue;
  }

  /// The printing of a part
  ///
  void _execName(String? border) {
    final name = _getName();

    if (name != null) {
      format.printer(name);
    }

    if (lot.tests.isNotEmpty && (border != null)) {
      format.printer(border);
    }
  }

  /// The printing of a single line of data
  ///
  void _execData(String? border) {
    final count = lot.tests.length;

    if (count <= 0) {
      return;
    }

    for (var i = 0; i < count; i++) {
      format.printer(_getData(i));
    }

    if (border != null) {
      format.printer(border);
    }
  }

  /// Initialize line border
  ///
  String? _getBorder() {
    if (format.fieldSeparator.isNotEmpty) {
      return null;
    }

    return format.cornerChar +
        format.horBarChar * (1 + lot.maxNameWidth + 1) +
        format.cornerChar +
        format.horBarChar * (1 + lot.maxRatioWidth + 1) +
        format.cornerChar +
        format.horBarChar * (1 + lot.maxValueWidth + 1) +
        format.cornerChar;
  }

  /// Initialize line data
  ///
  String _getData(int index) {
    final test = lot.tests[index];

    var outName = test.name;
    var outValue = test.outValue;
    var outRatio = test.outRatio;

    if (format.dataStyle.isRaw) {
      final sep = format.fieldSeparator;

      outName = _adjustQuotes(outName);
      outRatio = _adjustQuotes(outRatio);
      outValue = _adjustQuotes(outValue);

      return outName + sep + outRatio + sep + outValue;
    }

    if ((index == 0) || (outRatio == lot.tests[0].outRatio)) {
      outRatio = '';
    }

    outName = format.string(outName, lot.maxNameWidth);
    outValue = format.string(outValue, lot.maxValueWidth, true);
    outRatio = format.string(outRatio, lot.maxRatioWidth, true);

    final sep = format.verBarChar;

    return '$sep $outName $sep $outRatio $sep $outValue $sep';
  }

  /// Expand and return name
  ///
  String? _getName() {
    var name = lot.name;

    if (name.isEmpty) {
      return name;
    }

    final now = DateTime.now();
    final date = format.date(now);
    final time = format.time(now);
    var size = '';

    final maxLaps = lot.maxLaps;

    if (maxLaps != null) {
      size = format.number(maxLaps);
    } else if (lot.maxSpan != null) {
      size = format.duration(lot.maxSpan!);
    }

    return name
        .replaceAll(PerfTestFormat.stubDate, date)
        .replaceAll(PerfTestFormat.stubSize, size)
        .replaceAll(PerfTestFormat.stubTime, time);
  }
}
