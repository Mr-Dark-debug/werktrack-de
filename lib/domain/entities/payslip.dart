class Payslip {
  const Payslip({
    required this.id,
    required this.employerId,
    required this.month,
    required this.year,
    required this.grossCents,
    required this.wageTaxCents,
    required this.solidaritySurchargeCents,
    required this.churchTaxCents,
    required this.pensionCents,
    required this.healthCents,
    required this.careCents,
    required this.unemploymentCents,
    required this.otherDeductionsCents,
    required this.netCents,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String employerId;
  final int month;
  final int year;
  final int grossCents;
  final int wageTaxCents;
  final int solidaritySurchargeCents;
  final int churchTaxCents;
  final int pensionCents;
  final int healthCents;
  final int careCents;
  final int unemploymentCents;
  final int otherDeductionsCents;
  final int netCents;
  final DateTime createdAt;
  final DateTime updatedAt;
}
