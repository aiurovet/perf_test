// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// Group multiple tests and run everything, then output
///
class PerfTestLot {
  /// Output format
  ///
  late final PerfTestFormat format;

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

  /// Longevity of each test as a number of repeats (rather than [maxSpan])
  ///
  int? maxLaps;

  /// Maximum test name width (calculated)
  ///
  var maxNameWidth = 0;

  /// Maximum ratio display width (calculated)
  ///
  var maxRatioWidth = 0;

  /// Longevity of each test as duration (rather than [maxLaps])
  ///
  Duration? maxSpan;

  /// Maximum value display width (laps or span, calculated)
  ///
  var maxValueWidth = 0;

  /// Name of the lot (calculated)
  ///
  final String name;

  /// Output engine
  ///
  late final PerfTestOut out;

  /// Stopwatch used to measure performance in every test (internal or passed by you)
  ///
  late final Stopwatch? stopwatch;

  /// List of all singular tests
  ///
  final tests = <PerfTestOne>[];

  /// The constructor
  ///
  PerfTestLot(this.name,
      {Stopwatch? stopwatch,
      PerfTestOut? out,
      PerfTestFormat? format,
      this.isMyStopwatch = false,
      this.isQuiet = false}) {
    this.format = format ?? PerfTestFormat();
    this.out = out ?? PerfTestOut(this);
    this.stopwatch = stopwatch ?? Stopwatch();
  }

  /// Accumulator
  ///
  void add(PerfTestOne test) => tests.add(test.initLot(this));

  /// Calculate ratios as well as maximum widths for all columns if needed
  ///
  void createRatios() {
    final testCount = tests.length;
    final isRaw = format.isRaw;

    // Collect all single test ratios and calculate max widths
    //
    final test1 = tests[0];
    maxNameWidth = 0;

    for (var i = 0, width = 0; i < testCount; i++) {
      final test2 = tests[i];

      test2.setRatio(test1);

      if (!isRaw) {
        width = test2.name.length;
        maxNameWidth = (maxNameWidth >= width ? maxNameWidth : width);

        width = test2.outValue.length;
        maxValueWidth = (maxValueWidth >= width ? maxValueWidth : width);

        width = test2.outRatio.length;
        maxRatioWidth = (maxRatioWidth >= width ? maxRatioWidth : width);
      }
    }
  }

  /// Execute all tests and output results
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
