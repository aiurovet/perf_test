// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// A class to display of test and test lot results
///
class PerfTestOut {
  /// The formatter
  ///
  late final PerfTestFmt format;

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
    var fieldValueEx = fieldValue;
    var requiresQuotes = fieldValueEx.contains(format.quote);

    if (!requiresQuotes && format.fieldSeparator.isNotEmpty) {
      requiresQuotes = fieldValueEx.contains(format.fieldSeparator);
    }

    if (requiresQuotes) {
      fieldValueEx = format.quote +
          fieldValueEx.replaceAll(format.quote, format.quoteEscaped) +
          format.quote;
    }

    return fieldValueEx;
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

    var isPretty = format.isPretty;

    var maxWidth = (isPretty ? lot.maxNameWidth : 0);
    outName = _adjustQuotes(format.string(outName, maxWidth));

    maxWidth = (isPretty ? lot.maxValueWidth : 0);
    outValue = _adjustQuotes(format.string(outValue, maxWidth, true));

    maxWidth = (isPretty ? lot.maxRatioWidth : 0);
    outRatio = _adjustQuotes(format.string(outRatio, maxWidth, true));

    if (isPretty) {
      if ((index == 0) || (outRatio == lot.tests[0].outRatio)) {
        outRatio = ' ' * maxWidth;
      }
    }

    if (isPretty) {
      final sep = format.verBarChar;
      return '$sep $outName $sep $outRatio $sep $outValue $sep';
    }

    final sep = format.fieldSeparator;
    return outName + sep + outRatio + sep + outValue;
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
      size = (format.isPretty ? format.number(maxLaps) : maxLaps.toString());
    } else if (lot.maxSpan != null) {
      size = lot.maxSpan!.toString();
    }

    return name
        .replaceAll(PerfTestFmt.stubDate, date)
        .replaceAll(PerfTestFmt.stubSize, size)
        .replaceAll(PerfTestFmt.stubTime, time);
  }
}
