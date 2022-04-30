// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// A class to group multiple tests and calculate mutual rates
///
class PerfTestLot {
  /// A flag indicating that the stopwatch is started and
  /// stopped by the user rather than by this class object
  ///
  final bool isMyStopwatch;

  /// A flag indicating that no output is expected
  ///
  final bool isQuiet;

  /// The name of the lot
  ///
  final String name;

  /// The reference to the result object
  ///
  late final PerfTestLotResult result;

  /// The actual user-defined procedure to display the result
  ///
  late final PerfTestOutLot outLot;

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
      PerfTestLotResult? result,
      PerfTestOutLot? outLot,
      String? fieldSeparator,
      this.isMyStopwatch = false,
      this.isQuiet = false}) {
    this.result = result ?? PerfTestLotResult(this);

    if (fieldSeparator != null) {
      this.result.format.fieldSeparator = fieldSeparator;
    }

    this.outLot = outLot ?? PerfTestOutLot(this.result, printer: printer);
    this.stopwatch = stopwatch ?? Stopwatch();
  }

  /// The PerfTestOne adder
  ///
  void add(PerfTestOne test, {bool isDefault = false}) {
    test.lot = this;
    test.isMyStopwatch = isMyStopwatch;

    if (stopwatch != null) {
      test.stopwatch = stopwatch!;
    }

    tests.add(test);
  }

  /// If no magnetic test exists or there are only two tests or less
  /// then make them all magnetic
  ///
  void adjustMagnetic() {
    var count = tests.length;
    var hasMagnetic = false;

    if (count > 2) {
      for (var i = 0; i < count; i++) {
        if (tests[i].isMagnetic) {
          hasMagnetic = true;
          return;
        }
      }
    }
    if (!hasMagnetic) {
      for (var i = 0; i < count; i++) {
        tests[i].isMagnetic = true;
      }
    }
  }

  /// The runner
  ///
  void exec({int? laps, Duration? span}) {
    adjustMagnetic();

    for (var i = 0, n = tests.length; i < n; i++) {
      tests[i].exec(laps: laps, span: span);
    }

    if (!isQuiet) {
      outLot.exec();
    }
  }
}
