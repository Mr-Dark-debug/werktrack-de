class AcademicPeriod {
  const AcademicPeriod({
    required this.id,
    required this.semesterName,
    required this.semesterStart,
    required this.semesterEnd,
    required this.lectureStart,
    required this.lectureEnd,
    required this.exceptionalLectureFreeJson,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String semesterName;
  final DateTime semesterStart;
  final DateTime semesterEnd;
  final DateTime lectureStart;
  final DateTime lectureEnd;
  final String exceptionalLectureFreeJson;
  final DateTime createdAt;
  final DateTime updatedAt;
}

enum AcademicContext { lecturePeriod, lectureFree, outsideConfiguredSemester }
