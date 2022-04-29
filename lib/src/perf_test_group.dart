// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// A class to group multiple tests and calculate mutual rates
///
class PerfTestGroup {
  /// A flag indicating that the stopwatch is started and
  /// stopped by the user rather than by this class object
  ///
  final bool isMyStopwatch;

  /// A flag indicating that no output is expected
  ///
  final bool isQuiet;

  /// The name of the group
  ///
  final String name;

  /// The reference to the result object
  ///
  late final PerfTestGroupResult result;

  /// The actual user-defined procedure to display group result
  ///
  late final PerfTestGroupShow show;

  /// The group-wide stopwatch used to measure performance
  ///
  late final Stopwatch? stopwatch;

  /// The actual number of the test iterations upon execution completion
  ///
  final tests = <PerfTest>[];

  /// The constructor
  ///
  PerfTestGroup(this.name,
      {Stopwatch? stopwatch,
      PerfTestPrinter? printer,
      PerfTestGroupResult? result,
      PerfTestGroupShow? show,
      String? fieldSeparator,
      this.isMyStopwatch = false,
      this.isQuiet = false}) {
    this.result = result ?? PerfTestGroupResult(this);

    if (fieldSeparator != null) {
      this.result.format.fieldSeparator = fieldSeparator;
    }

    this.show = show ?? PerfTestGroupShow(this.result, printer: printer);
    this.stopwatch = stopwatch ?? Stopwatch();
  }

  /// The default show proc
  ///
  void add(PerfTest test, {bool isDefault = false}) {
    test.group = this;
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
      show.exec();
    }
  }
}
