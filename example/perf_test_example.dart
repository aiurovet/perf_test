// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// Test data holder
///
final codeUnits = <int>[];

/// Duration-based tests value
///
Duration? span;

/// Laps-based tests value
///
int? laps;

/// The entry point
///
void main(List<String> args) {
  parseArgs(args);
  setUp();

  PerfTestGroup('\nComparing loops')
    ..add(PerfTest('For', testProc: testProc1, isMagnet: true))
    ..add(PerfTest('ForEx', testProc: testProc2, isMagnet: true))
    ..add(PerfTest('ForRev', testProc: testProc3))
    ..add(PerfTest('ForEach', testProc: testProc4))
    ..exec(laps: laps, span: span);
}

/// Parse command-line arguments
///
void parseArgs(List<String> args) {
  int? microSeconds;

  if (args.length == 2) {
    switch (args[0].toLowerCase()) {
      case '-c':
        laps = int.parse(args[1]);
        break;
      case '-t':
        microSeconds =
            (num.parse(args[1]) * Duration.microsecondsPerSecond).floor();
        span = durationFromMicroseconds(microSeconds);
        break;
    }
  }
}

/// Data preparation
///
List<int> setUp() {
  codeUnits.clear();

  for (var c = 0x00; c < 0x7F; c++) {
    codeUnits.add(c);
  }

  return codeUnits;
}

/// The performance test #1
///
void testProc1(PerfTest test, int lapNo) {
  test.stopwatch.start();

  for (var i = 0, n = codeUnits.length; i < n; i++) {
    codeUnits[i].isEven;
    codeUnits[i].isOdd;
  }

  test.stopwatch.stop();
}

/// The performance test #2
///
void testProc2(PerfTest test, int lapNo) {
  test.stopwatch.start();

  for (var i = 0, n = codeUnits.length; i < n; i++) {
    final c = codeUnits[i];
    c.isEven;
    c.isOdd;
  }

  test.stopwatch.stop();
}

/// The performance test #3
///
void testProc3(PerfTest test, int lapNo) {
  test.stopwatch.start();

  for (var i = codeUnits.length; --i >= 0;) {
    codeUnits[i].isEven;
    codeUnits[i].isOdd;
  }

  test.stopwatch.stop();
}

/// The performance test #4
///
void testProc4(PerfTest test, int lapNo) {
  test.stopwatch.start();

  for (var c in codeUnits) {
    c.isEven;
    c.isOdd;
  }

  test.stopwatch.stop();
}
