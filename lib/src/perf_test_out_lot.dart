// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// A class to display of test and test lot results
///
class PerfTestOutLot {
  /// The formatter
  ///
  late final PerfTestFmt format;

  /// The convenience lot object
  ///
  late final PerfTestLot lot;

  /// The current child object
  ///
  late final PerfTestOutOne outOne;

  /// The actual function to send to the output
  ///
  late final PerfTestPrinter printer;

  /// The convenience lot result object
  ///
  final PerfTestLotResult result;

  /// The constructor
  ///
  PerfTestOutLot(this.result,
      {PerfTestPrinter? printer, PerfTestOutOne? outOne}) {
    this.printer = printer ?? print;
    this.outOne = outOne ?? PerfTestOutOne(this);
    format = result.format;
    lot = result.lot;
  }

  /// The printing
  ///
  void exec() {
    result.exec();

    final hasBorder = format.fieldSeparator.isEmpty;
    final testCount = lot.tests.length;
    final resultCount = result.lapsRatios.length;

    _execBorder(outOne, count: (testCount + resultCount), hasBorder: hasBorder);
    _execLines(outOne, count: testCount, hasBorder: hasBorder, isTest: true);
    _execLines(outOne, count: resultCount, hasBorder: hasBorder, isTest: false);
  }

  /// The printing of a part
  ///
  void _execBorder(PerfTestOutOne outOne, {int count = 0, hasBorder = false}) {
    if (hasBorder) {
      printer(result.getCaption());
    }

    if (hasBorder) {
      if (count > 0) {
        outOne.exec();
      }
    }
  }

  /// The printing of a part
  ///
  void _execLines(PerfTestOutOne outOne,
      {bool hasBorder = false, int count = 0, bool isTest = false}) {
    if (count <= 0) {
      return;
    }

    for (var i = 0; i < count; i++) {
      outOne.exec(index: i, isTest: isTest);
    }

    if (hasBorder) {
      outOne.exec();
    }
  }
}
