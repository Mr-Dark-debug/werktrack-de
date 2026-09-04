import 'dart:convert';

import '../entities/academic_period.dart';

class AcademicContextCalculator {
  const AcademicContextCalculator();

  AcademicContext contextFor(DateTime date, Iterable<AcademicPeriod> periods) {
    final day = DateTime(date.year, date.month, date.day);
    for (final period in periods) {
      if (day.isBefore(_day(period.semesterStart)) ||
          day.isAfter(_day(period.semesterEnd))) {
        continue;
      }
      for (final interval in _exceptions(period.exceptionalLectureFreeJson)) {
        if (!day.isBefore(interval.$1) && !day.isAfter(interval.$2)) {
          return AcademicContext.lectureFree;
        }
      }
      if (!day.isBefore(_day(period.lectureStart)) &&
          !day.isAfter(_day(period.lectureEnd))) {
        return AcademicContext.lecturePeriod;
      }
      return AcademicContext.lectureFree;
    }
    return AcademicContext.outsideConfiguredSemester;
  }

  List<(DateTime, DateTime)> _exceptions(String json) {
    if (json.trim().isEmpty) return const [];
    try {
      final data = jsonDecode(json) as List<dynamic>;
      return data.map((item) {
        final map = item as Map<String, dynamic>;
        return (
          _day(DateTime.parse(map['start'] as String)),
          _day(DateTime.parse(map['end'] as String)),
        );
      }).toList();
    } on FormatException {
      return const [];
    }
  }

  DateTime _day(DateTime value) => DateTime(value.year, value.month, value.day);
}
