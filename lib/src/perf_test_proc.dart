// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// A type for the actual user-defined procedure to test
///
typedef PerfTestOneProc = void Function(PerfTestOne test, int lapNo);

/// A type for the user-defined procedure to show lot result
///
typedef PerfTestOutLotProc = void Function(PerfTestLot lot);

/// A type for the user-defined procedure to show result
///
typedef PerfTestOutOneProc = void Function(
    PerfTestOutLot outLot, PerfTestOne test);

/// A type for the printing routine
///
typedef PerfTestPrinter = void Function(String);
