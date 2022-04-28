// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:collection/collection.dart';
import 'package:perf_test/perf_test.dart';

/// A class to group multiple tests and calculate mutual rates
///
class PerfTestGroup {
  /// The reference to the result object
  ///
  PerfTestGroupResult? result;

  /// The actual user-defined procedure to display group result
  ///
  final PerfTestGroupShowProc showProc;

  /// The group-wide stopwatch used to measure performance
  ///
  final Stopwatch? stopwatch;

  /// The actual number of the test iterations upon execution completion
  ///
  final tests = <PerfTest>[];

  /// The name of the group
  ///
  final String name;

  /// The actual user-defined procedure to display every test result
  ///
  final PerfTestShowProc testShowProc;

  /// The constructor
  ///
  PerfTestGroup(this.name,
      {this.stopwatch,
      this.result,
      this.showProc = defaultGroupShowProc,
      this.testShowProc = PerfTestGroupResult.defaultTestShowProc});

  /// The default show proc
  ///
  void add(PerfTest test, {bool isDefault = false}) {
    test.group = this;

    if (stopwatch != null) {
      test.stopwatch = stopwatch!;
    }

    tests.add(test);
  }

  /// If no adhesive test exists or there are only two tests or less
  /// then make them all adhesive
  ///
  void adjustAdhesive() {
    var count = tests.length;
    var hasAdhesive = false;

    if (count > 2) {
      for (var i = 0; i < count; i++) {
        if (tests[i].isMagnet) {
          hasAdhesive = true;
          return;
        }
      }
    }
    if (!hasAdhesive) {
      for (var i = 0; i < count; i++) {
        tests[i].isMagnet = true;
      }
    }
  }

  /// The default group show proc
  ///
  static void defaultGroupShowProc(PerfTestGroup group) =>
      PerfTestGroupResult(group).defaultShowProc();

  /// The runner
  ///
  void exec({int? laps, Duration? span}) {
    adjustAdhesive();

    for (var i = 0, n = tests.length; i < n; i++) {
      tests[i].exec(laps: laps, span: span);
    }
    showProc(this);
  }

  /// The silent show proc
  ///
  static void noShowProc(Object group) {}
}
