A set of classes to run performance test(s) and compare results against the first test.

Most likely, you'll need to add this package name and version to *dev_dependencies* rather than *dependencies*.

## Features

- Check the performance of a single test or run multiple performance tests and compare results against the first test
- Display results as either a grid or a field-separated values list (CSV, tab-separated, pipe-separated, etc.)
- Change the sequence of fields and even break into multiple outputs by manipulating placeholders
- Turn the stopwatch on and off in your code, achieving better result precision
- Run tests synchronously or asynchronously when needed

## Usage

The working example which can also be found in the repository in `example/perf_test_example.dart`

```dart
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

/// Execute multiple tests with the pretty output
///
void execPrettySync() => PerfTestLot('\nComparing loops - {M} - {D}')
  ..add(PerfTestOne('For, "as primary"', testProcSync: testProc1))
  ..add(PerfTestOne('ForEx', testProcSync: testProc2))
  ..add(PerfTestOne('ForRev', testProcSync: testProc3))
  ..add(PerfTestOne('ForEach', testProcSync: testProc4))
  ..execSync(maxLaps: laps, maxSpan: span);

/// Execute single test with the pretty output
///
void execPrettyOneSync() =>
    PerfTestOne('For, "as primary"', testProcSync: testProc1)
        .execSync(maxLaps: laps, maxSpan: span);

/// Execute multiple tests with the raw output
///
Future execRaw() async => await (PerfTestLot('Comparing loops,{M},',
        isMyStopwatch: true, format: PerfTestFormat.rawCsv)
      ..add(PerfTestOne('For, "as primary"', testProc: testProc1w))
      ..add(PerfTestOne('ForEx', testProc: testProc2w))
      ..add(PerfTestOne('ForRev', testProc: testProc3w))
      ..add(PerfTestOne('ForEach', testProc: testProc4w)))
    .exec(maxLaps: laps, maxSpan: span);

/// The entry point
///
Future main(List<String> args) async {
  parseArgs(args);
  setUp();
  execPrettyOneSync();
  execPrettySync();
  await execRaw();
}

/// Parse command-line arguments
///
void parseArgs(List<String> args) {
  int? milliseconds;

  if (args.length == 2) {
    switch (args[0].toLowerCase()) {
      case '-c':
        laps = int.parse(args[1]);
        break;
      case '-t':
        milliseconds =
            (num.parse(args[1]) * Duration.millisecondsPerSecond).floor();
        span = Duration(milliseconds: milliseconds);
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

/// Performance test #1
///
void testProc1(PerfTestOne test, int lapNo) {
  for (var i = 0, n = codeUnits.length; i < n; i++) {
    codeUnits[i].isEven;
    codeUnits[i].isOdd;
  }
}

/// Performance test #1 with the user-controlled stopwatch
///
Future testProc1w(PerfTestOne test, int lapNo) async {
  test.stopwatch.start();

  for (var i = 0, n = codeUnits.length; i < n; i++) {
    codeUnits[i].isEven;
    codeUnits[i].isOdd;
  }

  test.stopwatch.stop();
}

/// Performance test #2
///
void testProc2(PerfTestOne test, int lapNo) {
  for (var i = 0, n = codeUnits.length; i < n; i++) {
    final c = codeUnits[i];
    c.isEven;
    c.isOdd;
  }
}

/// Performance test #2 with the user-controlled stopwatch
///
Future testProc2w(PerfTestOne test, int lapNo) async {
  test.stopwatch.start();

  for (var i = 0, n = codeUnits.length; i < n; i++) {
    final c = codeUnits[i];
    c.isEven;
    c.isOdd;
  }

  test.stopwatch.stop();
}

/// Performance test #3
///
void testProc3(PerfTestOne test, int lapNo) {
  for (var i = codeUnits.length; --i >= 0;) {
    codeUnits[i].isEven;
    codeUnits[i].isOdd;
  }
}

/// Performance test #3 with the user-controlled stopwatch
///
Future testProc3w(PerfTestOne test, int lapNo) async {
  test.stopwatch.start();

  for (var i = codeUnits.length; --i >= 0;) {
    codeUnits[i].isEven;
    codeUnits[i].isOdd;
  }

  test.stopwatch.stop();
}

/// Performance test #4
///
void testProc4(PerfTestOne test, int lapNo) {
  for (var c in codeUnits) {
    c.isEven;
    c.isOdd;
  }
}

/// Performance test #4 with the user-controlled stopwatch
///
Future testProc4w(PerfTestOne test, int lapNo) async {
  test.stopwatch.start();

  for (var c in codeUnits) {
    c.isEven;
    c.isOdd;
  }

  test.stopwatch.stop();
}
```
