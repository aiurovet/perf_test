// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// Actual user-defined procedure to test
///
typedef PerfTestOneProc = Future Function(PerfTestOne test, int lapNo);

/// Convenience definition, similar to PerfTestOneProc
///
typedef PerfTestProc = Future Function(PerfTestOne test, int lapNo);

/// Actual user-defined procedure to test
///
typedef PerfTestOneProcSync = void Function(PerfTestOne test, int lapNo);

/// Convenience definition, similar to PerfTestOneProcSync
///
typedef PerfTestProcSync = void Function(PerfTestOne test, int lapNo);

/// User-defined procedure to show lot result
///
typedef PerfTestOutProc = void Function(PerfTestLot lot);

/// Lowest level printing routine
///
typedef PerfTestPrinter = void Function(String);
