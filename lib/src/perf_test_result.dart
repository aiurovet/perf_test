// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// A class to store and display ratio of a performance
/// test result (actual laps, time spent) against another one
///
class PerfTestResult {
  /// The pattern for the ratio conversion to display string
  ///
  late final PerfTestFormat format;

  /// The default name
  ///
  String get name => '${test1.name} / ${test2.name}';

  /// The string showing the ratio
  ///
  late final String displayRatio;

  /// The ratio
  ///
  late final num ratio;

  /// The primary test result
  ///
  final num result1;

  /// The secondary test result
  ///
  final num result2;

  /// The primary test object
  ///
  final PerfTest test1;

  /// The secondary test object
  ///
  final PerfTest test2;

  /// The constructor
  ///
  PerfTestResult(this.test1, this.result1, this.test2, this.result2,
      {PerfTestFormat? format}) {
    this.format = format ?? PerfTestFormat();

    if (result2 == 0) {
      ratio = -1;
      displayRatio = format?.infinite ?? '';
    } else if (result1 == result2) {
      ratio = 1;
      displayRatio = format?.identical ?? '';
    } else {
      ratio = (result1 / result2);
      displayRatio = this.format.percent(ratio);
    }
  }

  /// The serializer
  ///
  @override
  String toString() => displayRatio;
}
