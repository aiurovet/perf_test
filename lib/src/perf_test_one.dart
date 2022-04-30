// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// A wrapper class to execute user-defined procedures multiple times
/// and measure either actual laps for a given time span or time
/// span for a given number of iterations
///
class PerfTestOne {
  /// The parent
  ///
  PerfTestLot? lot;

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

  /// The stopwatch used to measure performance
  ///
  Stopwatch stopwatch = Stopwatch();

  /// The actual user-defined procedure
  ///
  final PerfTestOneProc testProc;

  /// The constructor
  ///
  PerfTestOne(this.name,
      {this.lot,
      Stopwatch? stopwatch,
      this.isMagnetic = false,
      this.isMyStopwatch = false,
      this.testProc = emptyTestProc}) {
    if (stopwatch != null) {
      this.stopwatch = stopwatch;
    }
  }

  /// The default dummy test proc
  ///
  static void emptyTestProc(PerfTestOne test, int lapNo) {}

  /// The test runner
  ///
  PerfTestOne exec({int? laps, Duration? span}) {
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
