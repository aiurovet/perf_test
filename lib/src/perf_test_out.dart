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

  /// The actual function to send to the output
  ///
  late final PerfTestPrinter printer;

  /// The constructor
  ///
  PerfTestOut(this.lot, {PerfTestPrinter? printer}) {
    format = lot.format;
    this.printer = printer ?? print;
  }

  /// The printing
  ///
  void exec() {
    final border = _getBorder();
    final testCount = lot.tests.length;
    final resultCount = lot.ratios.length;
    final totalCount = (testCount + resultCount);

    _execCaption(border: border, count: totalCount);
    _execLines(border: border, count: testCount);
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
  void _execCaption({String? border, int count = 0}) {
    if (border == null) {
      return;
    }

    final caption = lot.getCaption();

    if (caption.isNotEmpty) {
      printer(caption);
    }

    if (count > 0) {
      printer(border);
    }
  }

  /// The printing of a single line of data
  ///
  void _execLines({String? border, int count = 0}) {
    if (count <= 0) {
      return;
    }

    for (var i = 0; i < count; i++) {
      printer(_getData(i));
    }

    if (border != null) {
      printer(border);
    }
  }

  /// Initialize line border
  ///
  String? _getBorder() {
    if (format.fieldSeparator.isNotEmpty) {
      return null;
    }

    return
      format.cornerChar +
      format.borderChar * (1 + lot.maxNameWidth + 1) +
      format.cornerChar +
      format.borderChar * (1 + lot.maxRatioWidth + 1) +
      format.cornerChar +
      format.borderChar * (1 + lot.maxDataWidth + 1) +
      format.cornerChar;
  }

  /// Initialize line data
  ///
  String _getData(int index) {
    var outName = '';
    var outData = '';
    var outRatio = '';

    if (index >= 0) {
      final test = lot.tests[index];
      outName = test.name;
      outData = test.outValue;
      outRatio = lot.ratios[index].outRatio;
    }

    var sep = format.fieldSeparator;
    var hasSep = sep.isNotEmpty;

    var maxWidth = (hasSep ? 0 : lot.maxNameWidth);
    outName = _adjustQuotes(format.string(outName, maxWidth));

    maxWidth = (hasSep ? 0 : lot.maxDataWidth);
    outData = _adjustQuotes(format.string(outData, maxWidth, true));

    maxWidth = (hasSep ? 0 : lot.maxRatioWidth);
    outRatio = _adjustQuotes(format.string(outRatio, maxWidth, true));

    if (hasSep) {
      return outName + sep + outRatio + sep + outData;
    }

    sep = format.barChar;

    return '$sep $outName $sep $outRatio $sep $outData $sep';
  }
}
