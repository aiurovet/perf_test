// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// A type for the printing routine
///
typedef PerfTestPrinter = void Function(String);

/// A class to display of test and test group results
///
class PerfTestGroupShow {
  /// The formatter
  ///
  late final PerfTestFormat format;

  /// The convenience group object
  ///
  late final PerfTestGroup group;

  /// The actual function to send to the output
  ///
  late final PerfTestPrinter printer;

  /// The convenience group result object
  ///
  final PerfTestGroupResult result;

  /// The convenience group result object
  ///
  late final PerfTestShow showLine;

  /// The constructor
  ///
  PerfTestGroupShow(this.result,
      {PerfTestPrinter? printer, PerfTestShow? showLine}) {
    this.printer = printer ?? print;
    this.showLine = showLine ?? PerfTestShow(this);
    format = result.format;
    group = result.group;
  }

  /// The printing
  ///
  void exec() {
    result.exec();

    final hasBorder = format.fieldSeparator.isEmpty;
    final testCount = group.tests.length;
    final resultCount = result.lapsResults.length;

    _execBorder(showLine,
        count: (testCount + resultCount), hasBorder: hasBorder);
    _execLines(showLine, count: testCount, hasBorder: hasBorder, isTest: true);
    _execLines(showLine,
        count: resultCount, hasBorder: hasBorder, isTest: false);
  }

  /// The printing of a part
  ///
  void _execBorder(PerfTestShow showLine, {int count = 0, hasBorder = false}) {
    if (hasBorder) {
      printer(result.getCaption());
    }

    if (hasBorder) {
      if (count > 0) {
        showLine.exec();
      }
    }
  }

  /// The printing of a part
  ///
  void _execLines(PerfTestShow showLine,
      {bool hasBorder = false, int count = 0, bool isTest = false}) {
    if (count <= 0) {
      return;
    }

    for (var i = 0; i < count; i++) {
      showLine.exec(index: i, isTest: isTest);
    }

    if (hasBorder) {
      showLine.exec();
    }
  }
}
