// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:intl/intl.dart';
import 'package:perf_test/perf_test.dart';

/// A type for the actual user-defined procedure to test
///
typedef PerfTestProc = void Function(PerfTest test, int lapNo);

/// A wrapper class to execute user-defined procedures multiple times
/// and measure either actual laps for a given time span or time
/// span for a given number of iterations
///
class PerfTest {
  /// The parent group
  ///
  PerfTestGroup? group;

  /// Can engage any element in performance comparison
  ///
  bool isMagnetic;

  /// A flag indicating that the stopwatch is started and
  /// stopped by a user rather than by this class object
  ///
  bool isMyStopwatch;

  /// The actual number of the test iterations upon execution completion
  ///
  int laps = 0;

  /// The pure total duration of testProc execution
  ///
  Duration span = Duration();

  /// The name of the test
  ///
  final String name;

  /// The pattern for number conversion to display string
  ///
  static final numberFormat = NumberFormat();

  /// The stopwatch used to measure performance
  ///
  Stopwatch stopwatch = Stopwatch();

  /// The actual user-defined procedure
  ///
  final PerfTestProc testProc;

  /// The constructor
  ///
  PerfTest(this.name,
      {this.group,
      Stopwatch? stopwatch,
      this.isMagnetic = false,
      this.isMyStopwatch = false,
      this.testProc = emptyTestProc}) {
    if (stopwatch != null) {
      this.stopwatch = stopwatch;
    }
  }

  /// The default show proc
  ///
  static void defaultShowProc(PerfTest test) =>
      print(test.getDefaultShowRecord());

  /// The default dummy test proc
  ///
  static void emptyTestProc(PerfTest test, int lapNo) {}

  /// The test runner
  ///
  PerfTest exec({int? laps, Duration? span}) {
    stopwatch.reset();

    if (laps != null) {
      this.laps = laps;

      for (var i = 0; i < laps; i++) {
        if (!isMyStopwatch) {
          stopwatch.start();
        }
        testProc(this, i);
        if (!isMyStopwatch) {
          stopwatch.stop();
        }
      }
    } else if (span != null) {
      this.laps = 0;
      final maxMicroseconds = span.inMicroseconds;

      for (; stopwatch.elapsedMicroseconds < maxMicroseconds; this.laps++) {
        if (!isMyStopwatch) {
          stopwatch.start();
        }
        testProc(this, this.laps);
        if (!isMyStopwatch) {
          stopwatch.stop();
        }
      }
    }

    this.span = durationFromMicroseconds(stopwatch.elapsedMicroseconds);

    return this;
  }

  /// The default show proc
  ///
  String getDefaultShowRecord() =>
      '$name | ${numberFormat.format(laps)} | $span';
}

/// A helper static method to create Duration from a total number of microseconds
///
Duration durationFromMicroseconds(int totalMicroseconds) {
  final days = totalMicroseconds ~/ Duration.microsecondsPerDay;
  totalMicroseconds -= days * Duration.microsecondsPerDay;

  final hours = totalMicroseconds ~/ Duration.microsecondsPerHour;
  totalMicroseconds -= hours * Duration.microsecondsPerHour;

  final minutes = totalMicroseconds ~/ Duration.microsecondsPerMinute;
  totalMicroseconds -= minutes * Duration.microsecondsPerMinute;

  final seconds = totalMicroseconds ~/ Duration.microsecondsPerSecond;
  totalMicroseconds -= seconds * Duration.microsecondsPerSecond;

  final milliseconds = totalMicroseconds ~/ Duration.microsecondsPerMillisecond;
  totalMicroseconds -= milliseconds * Duration.microsecondsPerMillisecond;

  return Duration(
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: totalMicroseconds);
}
