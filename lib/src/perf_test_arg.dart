// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// Generic argument to generate any kind of test data
///
class PerfTestArg {
  /// The maximum value of a range
  ///
  Object? current;

  /// Type of the argument
  ///
  late final PerfTestArgType type;

  /// Flag indicating all values have been exhausted
  ///
  bool isFinished = false;

  /// The list of (non-unique) values
  ///
  final Iterable? iterable;

  /// The minimum value of a range
  ///
  final Object? min;

  /// The maximum value of a range
  ///
  final Object? max;

  /// The step of a range
  ///
  final Object? step;

  /// The constructor
  ///
  PerfTestArg({this.iterable, this.min, this.max, this.step}) {
    type = (
      (iterable != null) ? PerfTestArgType.iterable :
      (min is int) ||
      (max is int) ||
      (step is int) ? PerfTestArgType.int :
      (min is num) ||
      (max is num) ||
      (step is num) ? PerfTestArgType.num :
      (min is DateTime) ||
      (max is DateTime) ||
      (step is Duration) ? PerfTestArgType.dateTime :
      PerfTestArgType.unknown
    );

    reset();
  }

  Object? moveNext() {
    switch (type) {
      case PerfTestArgType.dateTime:
        current = moveNextDateTime(current as DateTime, min as DateTime?, max as DateTime?, step as Duration?);
        break;
      case PerfTestArgType.int:
        current = moveNextInt(current as int, min as int?, max as int?, step as int?);
        break;
      case PerfTestArgType.iterable:
        current = moveNextIterable(iterable!);
        break;
      case PerfTestArgType.num:
        current = moveNextNum(current as num, min as num?, max as num?, step as num?);
        break;
      default:
        current = null;
    }

    if (iterable != null) {
    } else if ((min is int) || (max is int) || (step is int)) {
      current = moveNextInt(current as int, min as int?, max as int?, step as int?);
    } else if ((min is num) || (max is int) || (step is int)) {
      current = moveNextNum(current as num, min as num?, max as num?, step as num?);
    } else {
      current = null;
    }

    return current;
  }

  static int moveNextDateTime(DateTime cur, DateTime? min, DateTime? max, Duration step) {
    cur.add(step);

    if ((max != null) && (cur.microsecondsSinceEpoch > max.microsecondsSinceEpoch)) {
      cur = min;
    }

    return i;
  }

  static int moveNextInt(int i, int? min, int? max, int? step) {
    i += (step ?? 1);

    if ((max != null) && (i > max)) {
      i = (min ?? 0);
    }

    return i;
  }

  static Object moveNextIterable(Iterable itr) {
    final i = itr.iterator;
    return (i.moveNext() ? i.current : itr.first);
  }

  static num moveNextNum(num i, num? min, num? max, num? step) {
    i += (step ?? 1);

    if ((max != null) && (i > max)) {
      i = (min ?? 0);
    }

    return i;
  }

  Object? reset() {
    switch (type) {
      case PerfTestArgType.dateTime:
    }
    if (iterable != null) {
      current = iterable!.first;
    } else if (min is num?) {
      current = min ?? 0;
    } else {
      current = null;
    }

    return current;
  }
}