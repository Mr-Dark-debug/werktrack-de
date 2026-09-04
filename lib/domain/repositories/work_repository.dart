import '../entities/academic_period.dart';
import '../entities/employer.dart';
import '../entities/legal_rule.dart';
import '../entities/payslip.dart';
import '../entities/work_entry.dart';
import '../entities/user_profile.dart';

abstract interface class WorkRepository {
  Stream<List<Employer>> watchEmployers();
  Stream<List<WorkEntry>> watchEntries();
  Stream<List<AcademicPeriod>> watchAcademicPeriods();
  Stream<List<Payslip>> watchPayslips();
  Stream<List<LegalRule>> watchLegalRules();
  Stream<bool> watchOnboardingComplete();
  Stream<UserProfile?> watchProfile();
  Future<void> completeOnboarding(
    String displayName, {
    bool isStudent = true,
    bool tracksResidenceAllowance = true,
  });
  Future<void> saveEmployer(Employer employer);
  Future<void> saveEntry(WorkEntry entry);
  Future<void> saveAcademicPeriod(AcademicPeriod period);
  Future<void> savePayslip(Payslip payslip);
  Future<void> addLegalRuleVersion(LegalRule rule);
  Future<void> deleteEntry(String id);
  Future<void> restoreEntry(String id);
  Future<String?> readSetting(String key);
  Future<void> writeSetting(String key, String valueJson);
}
