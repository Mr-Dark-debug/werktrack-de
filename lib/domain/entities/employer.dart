enum EmploymentType {
  minijob,
  werkstudent,
  partTime,
  fullTime,
  universityAssistant,
  researchAssistant,
  shortTerm,
  internship,
  selfEmployment,
  custom,
}

class Employer {
  const Employer({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.employmentType,
    required this.hourlyRateCents,
    required this.startDate,
    required this.isActive,
    required this.countsForResidenceLimit,
    required this.countsForStudentHourRule,
    required this.isSocialInsuranceLiable,
    required this.pensionExempt,
    required this.taxClass,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.endDate,
  });

  final String id;
  final String name;
  final String jobTitle;
  final EmploymentType employmentType;
  final int hourlyRateCents;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final bool countsForResidenceLimit;
  final bool countsForStudentHourRule;
  final bool isSocialInsuranceLiable;
  final bool pensionExempt;
  final int taxClass;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
}
