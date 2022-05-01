// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'dart:math';

import 'package:perf_test/perf_test.dart';

/// A class to group multiple tests and calculate mutual rates
///
class PerfTestLot {
  /// Output format
  ///
  late final PerfTestFmt format;

  /// Flag indicating that the stopwatch is started and
  /// stopped by the user rather than by this class object
  ///
  final bool isMyStopwatch;

  /// Flag indicating that no output is expected
  ///
  final bool isQuiet;

  /// Flag indicating that the output value is laps rather span
  ///
  bool isOutLaps = false;

  /// The length of test as a number of repeats
  ///
  int? maxLaps;

  /// The maximum test name width
  ///
  var maxNameWidth = 0;

  /// The maximum ratio display width
  ///
  var maxRatioWidth = 0;

  /// The length of test as duration
  ///
  Duration? maxSpan;

  /// Maximum value display width (laps or span)
  ///
  var maxValueWidth = 0;

  /// The name of the lot
  ///
  final String name;

  /// The actual user-defined procedure to display the result
  ///
  late final PerfTestOut out;

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
      PerfTestOut? out,
      PerfTestFmt? format,
      this.isMyStopwatch = false,
      this.isQuiet = false}) {
    this.format = format ?? PerfTestFmt();
    this.out = out ?? PerfTestOut(this);
    this.stopwatch = stopwatch ?? Stopwatch();
  }

  /// The PerfTestOne adder
  ///
  void add(PerfTestOne test) => tests.add(test.initLot(this));

  /// and calculate maximum widths for all columns
  ///
  void createRatios() {
    final testCount = tests.length;
    final isPretty = format.style.isPretty;

    // Collect all single test ratios and calculate max widths
    //
    final test1 = tests[0];
    maxNameWidth = 0;

    for (var i = 0, width = 0; i < testCount; i++) {
      final test2 = tests[i];

      test2.setRatio(test1);

      if (isPretty) {
        width = test2.name.length;
        maxNameWidth = (maxNameWidth >= width ? maxNameWidth : width);

        width = test2.outValue.length;
        maxValueWidth = (maxValueWidth >= width ? maxValueWidth : width);

        width = test2.outRatio.length;
        maxRatioWidth = (maxRatioWidth >= width ? maxRatioWidth : width);
      }
    }
  }

  /// The runner
  ///
  void exec({int? maxLaps, Duration? maxSpan}) {
    this.maxLaps = maxLaps;
    this.maxSpan = maxSpan;

    isOutLaps = (maxLaps == null);

    for (var i = 0, n = tests.length; i < n; i++) {
      tests[i].exec(maxLaps: maxLaps, maxSpan: maxSpan);
    }

    createRatios();

    if (!isQuiet) {
      out.exec();
    }
  }
}
