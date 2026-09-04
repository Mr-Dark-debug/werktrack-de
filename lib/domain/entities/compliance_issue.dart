enum ComplianceSeverity { info, warning, critical }

class ComplianceIssue {
  const ComplianceIssue({
    required this.severity,
    required this.ruleId,
    required this.title,
    required this.description,
    required this.affectedDate,
    required this.source,
    required this.recommendation,
  });

  final ComplianceSeverity severity;
  final String ruleId;
  final String title;
  final String description;
  final DateTime affectedDate;
  final String source;
  final String recommendation;
}
