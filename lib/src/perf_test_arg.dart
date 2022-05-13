// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:lim/lim.dart';
import 'package:perf_test/perf_test.dart';
import 'package:random_unicode/random_unicode.dart';

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

  /// The value of a step indicating taking a random value
  ///
  static const num randomStep = 0;

  /// The maximum value of a range
  ///
  Object? current;

  /// Flag indicating all values have been exhausted
  ///
  bool isFinished = false;

  /// The list of (non-unique) values
  ///
  late final Iterable iterable;

  /// Maximum DateTime value of a range
  ///
  late final DateTime dateTimeMax;

  /// Minimum DateTime value of a range
  ///
  late final DateTime dateTimeMin;

  /// Step for the DateTime range
  ///
  late final Duration dateTimeStep;

  /// Maximum int value of a range
  ///
  late final int intMax;

  /// Minimum int value of a range
  ///
  late final int intMin;

  /// Step for the int range
  ///
  late final int intStep;

  /// Flag indicating random value pick up
  ///
  late final bool isRandom;

  /// Maximum num value of a range
  ///
  late final num numMax;

  /// Minimum num value of a range
  ///
  late final num numMin;

  /// Step for the num range
  ///
  late final num numStep;

  /// Random unicode string generator
  /// 
  late final RandomUnicode? randomUnicode;

  /// Scope of the argument
  ///
  late final PerfTestArgScope scope;

  /// The constructor
  ///
  PerfTestArg({Iterable? iterable, Object? min, Object? max, Object? step, RandomUnicode? randomUnicode}) {
    isRandom = (((step is num) && (step == randomStep)) || (randomUnicode != null));

    if (iterable != null) {
      scope = PerfTestArgScope.iterable;
      this.iterable = iterable;
    } else if ((min is int) || (max is int) || (step is int)) {
      scope = PerfTestArgScope.intRange;
      intMin = ((min as int?) ?? Lim.minInt);
      intMax = ((max as int?) ?? Lim.maxInt);
      intStep = ((step as int?) ?? defaultStepForInt);
    } else if ((min is num) || (max is num) || (step is num)) {
      scope = PerfTestArgScope.numRange;
      numMin = ((min as num?) ?? Lim.minNum);
      numMax = ((max as num?) ?? Lim.maxNum);
      numStep = ((step as num?) ?? defaultStepForNum);
    } else if ((min is DateTime) || (max is DateTime) || (step is Duration)) {
      scope = PerfTestArgScope.numRange;
      dateTimeMin = ((min as DateTime?) ?? Lim.minDateTime);
      dateTimeMax = ((max as DateTime?) ?? Lim.maxDateTime);
      dateTimeStep = ((step as Duration?) ?? defaultStepForDateTime);
      intMin = dateTimeMin.microsecondsSinceEpoch;
      intMax = dateTimeMax.microsecondsSinceEpoch;
    } else if (randomUnicode != null) {
      scope = PerfTestArgScope.stringRange;
      this.randomUnicode = randomUnicode;
      intMin = ((min as int?) ?? Lim.minCharCode);
      intMax = ((max as int?) ?? Lim.maxCharCode);
    } else {
      scope = PerfTestArgScope.unknown;
    }

    reset();
  }

  Object? moveNext() {
    switch (scope) {
      case PerfTestArgScope.dateTimeRange:
        if (isRandom) {
          intMin ;
        } else {
          final cur = current as DateTime;
          isFinished = (cur == dateTimeMax);
          current = (isFinished ? dateTimeMin : cur.add(dateTimeStep));
        }
        break;
      case PerfTestArgScope.intRange:
        var cur = current as int;
        isFinished = (cur == intMax);
        current = (isFinished ? intMin : cur + intStep);
        break;
      case PerfTestArgScope.iterable:
        final itr = iterable.iterator;
        current = (itr.moveNext() ? itr.current : iterable.first);
        break;
      case PerfTestArgScope.numRange:
        var cur = current as num;
        isFinished = (cur == numMax);
        current = (isFinished ? numMin : cur + numStep);
        break;
      case PerfTestArgScope.stringRange:
        current = randomUnicode!.string(intMin, intMax);
        break;
      default:
        current = null;
    }

    return current;
  }

  Object? reset() {
    switch (scope) {
      case PerfTestArgScope.dateTimeRange:
        current = dateTimeMin;
        break;
      case PerfTestArgScope.intRange:
        current = intMin;
        break;
      case PerfTestArgScope.iterable:
        current = iterable.first;
        break;
      case PerfTestArgScope.numRange:
        current = numMin;
        break;
      default:
        current = null;
    }

    return current;
  }
}