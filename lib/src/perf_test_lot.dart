// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// A class to group multiple tests and calculate mutual rates
///
class PerfTestLot {
  /// The output format
  ///
  late final PerfTestFmt format;

  /// A flag indicating that the stopwatch is started and
  /// stopped by the user rather than by this class object
  ///
  final bool isMyStopwatch;

  /// A flag indicating that no output is expected
  ///
  final bool isQuiet;

  /// A flag indicating that no output is expected
  ///
  PerfTestMode mode;

  /// The maximum data display width (laps or span)
  ///
  var maxDataWidth = 0;

  /// The maximum test name width
  ///
  var maxNameWidth = 0;

  /// The maximum ratio display width
  ///
  var maxRatioWidth = 0;

  /// The name of the lot
  ///
  final String name;

  /// The actual user-defined procedure to display the result
  ///
  late final PerfTestOut out;

  /// The list of all possible ratios
  ///
  final ratios = <PerfTestRatio>[];

  /// The lot-wide stopwatch used to measure performance
  ///
  late final Stopwatch? stopwatch;

  /// The actual number of the test iterations upon execution completion
  ///
  final tests = <PerfTestOne>[];

  /// The constructor
  ///
  PerfTestLot(this.name,
      {Stopwatch? stopwatch,
      PerfTestPrinter? printer,
      PerfTestOut? out,
      PerfTestFmt? format,
      this.isMyStopwatch = false,
      this.isQuiet = false,
      this.mode = PerfTestMode.byLaps}) {
    this.format = format ?? PerfTestFmt();
    this.out = out ?? PerfTestOut(this, printer: printer);
    this.stopwatch = stopwatch ?? Stopwatch();
  }

  /// The PerfTestOne adder
  ///
  void add(PerfTestOne test) =>
    tests.add(test.initLot(this));

  /// and calculate maximum widths for all columns
  ///
  void createRatios({int? laps, Duration? span}) {
    final testCount = tests.length;
    final isPretty = format.fieldSeparator.isEmpty;
    
    // Collect all single test ratios and calculate max widths
    //
    final test1 = tests[0];
    maxNameWidth = 0;

    for (var i = 0, width = 0; i < testCount; i++) {
      final test2 = tests[i];

      var ratio = PerfTestRatio(test1, test2, mode: mode, format: format);
      ratios.add(ratio);

      if (isPretty) {
        width = test2.name.length;
        maxNameWidth = (maxNameWidth >= width ? maxNameWidth : width);

        width = test2.outValue.length;
        maxDataWidth = (maxDataWidth >= width ? maxDataWidth : width);

        width = ratio.outRatio.length;
        maxRatioWidth = (maxRatioWidth >= width ? maxRatioWidth : width);
      }
    }
  }

  /// The runner
  ///
  void exec({int? laps, Duration? span}) {
    for (var i = 0, n = tests.length; i < n; i++) {
      tests[i].exec(laps: laps, span: span);
    }

    createRatios(laps: laps, span: span);

    if (!isQuiet) {
      out.exec();
    }
  }

  /// Get the default title string
  ///
  String getCaption() {
    final now = DateTime.now();
    return '$name - ${format.date(now)} - ${format.time(now)}';
  }
}
