// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// Generic argument to generate any kind of test data
///
class PerfTestArg {
  /// The default iterable value
  ///
  static final defaultIterable = [];

  /// The default step for DateTime value
  ///
  static final int defaultStepForInt = 1;

  /// Default step for DateTime value
  ///
  static final num defaultStepForNum = 1;

  /// Default step for DateTime value
  ///
  static final Duration defaultStepForDateTime = Duration(days: 1);

  /// Maximum DateTime value
  ///
  static final DateTime maxDateTime = DateTime.utc(275760, 09, 13);

  /// Minimum DateTime value
  ///
  static final DateTime minDateTime = DateTime.utc(-271821, 04, 20);

  /// Maximum int value
  ///
  static const int maxInt =  9007199254740991;

  /// Minimum int value
  ///
  static const int minInt = -9007199254740992;

  /// Maximum num value
  ///
  static const num maxNum =  9223372036854775807;

  /// Minimum num value
  ///
  static const num minNum = -9223372036854775808;

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
  Iterable iterable = defaultIterable;

  /// Maximum DateTime value of a range
  ///
  DateTime dateTimeMax = maxDateTime;

  /// Minimum DateTime value of a range
  ///
  DateTime dateTimeMin = minDateTime;

  /// Step for the DateTime range
  ///
  Duration dateTimeStep = defaultStepForDateTime;

  /// Maximum int value of a range
  ///
  int intMax = maxInt;

  /// Minimum int value of a range
  ///
  int intMin = minInt;

  /// Step for the int range
  ///
  int intStep = defaultStepForInt;

  /// Maximum num value of a range
  ///
  num numMax = maxNum;

  /// Minimum num value of a range
  ///
  num numMin = minNum;

  /// Step for the num range
  ///
  num numStep = defaultStepForNum;

  /// The constructor
  ///
  PerfTestArg({Iterable? iterable, Object? min, Object? max, Object? step}) {
    if (iterable != null) {
      type = PerfTestArgType.iterable;
      this.iterable = iterable;
    } else if ((min is int) || (max is int) || (step is int)) {
      type = PerfTestArgType.int;
      intMin = ((min as int?)  ?? minInt);
      intMax = ((max as int?)  ?? maxInt);
      intStep = ((step as int?) ?? defaultStepForInt);
    } else if ((min is num) || (max is num) || (step is num)) {
      type = PerfTestArgType.num;
      numMin = ((min as num?)  ?? minNum);
      numMax = ((max as num?)  ?? maxNum);
      numStep = ((step as int?) ?? defaultStepForInt);
    } else if ((min is DateTime) || (max is DateTime) || (step is Duration)) {
      type = PerfTestArgType.num;
      dateTimeMin = ((min as DateTime?) ?? minDateTime);
      dateTimeMax = ((max as DateTime?) ?? maxDateTime);
      dateTimeStep = ((step as Duration?) ?? defaultStepForDateTime);
    } else {
      type = PerfTestArgType.unknown;
    }

    reset();
  }

  Object? moveNext() {
    switch (type) {
      case PerfTestArgType.dateTime:
        var cur = current as DateTime;
        isFinished = (cur == dateTimeMax);
        current = (isFinished ? dateTimeMin : cur.add(dateTimeStep));
        break;
      case PerfTestArgType.int:
        var cur = current as int;
        isFinished = (cur == intMax);
        current = (isFinished ? intMin : cur + intStep);
        break;
      case PerfTestArgType.iterable:
        final itr = iterable.iterator;
        current = (itr.moveNext() ? itr.current : iterable.first);
        break;
      case PerfTestArgType.num:
        var cur = current as num;
        isFinished = (cur == numMax);
        current = (isFinished ? numMin : cur + numStep);
        break;
      default:
        current = null;
    }

    return current;
  }

  Object? reset() {
    switch (type) {
      case PerfTestArgType.dateTime:
        current = dateTimeMin;
        break;
      case PerfTestArgType.int:
        current = intMin;
        break;
      case PerfTestArgType.iterable:
        current = iterable.first;
        break;
      case PerfTestArgType.num:
        current = numMin;
        break;
      default:
        current = null;
    }

    return current;
  }
}