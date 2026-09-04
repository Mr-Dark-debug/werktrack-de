import 'package:go_router/go_router.dart';

import '../features/calendar/calendar_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/employers/employer_form_screen.dart';
import '../features/employers/employers_screen.dart';
import '../features/export/export_backup_screen.dart';
import '../features/insights/insights_screen.dart';
import '../features/insights/compliance_review_screen.dart';
import '../features/legal_rules/rules_screen.dart';
import '../features/legal_rules/rule_override_screen.dart';
import '../domain/entities/legal_rule.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/payslips/payslip_form_screen.dart';
import '../features/payslips/income_screen.dart';
import '../features/semesters/academic_period_form_screen.dart';
import '../features/semesters/academic_periods_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/settings/profile_screen.dart';
import '../features/sync/sync_screen.dart';
import '../features/work_entries/can_i_work_screen.dart';
import '../features/work_entries/work_entry_form_screen.dart';
import '../features/work_entries/work_screen.dart';
import '../domain/entities/work_entry.dart';
import '../domain/entities/academic_period.dart';
import '../domain/entities/employer.dart';
import 'shell/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingGate()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/calendar',
          builder: (context, state) => const CalendarScreen(),
        ),
        GoRoute(path: '/work', builder: (context, state) => const WorkScreen()),
        GoRoute(
          path: '/insights',
          builder: (context, state) => const InsightsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/employers',
      builder: (context, state) => const EmployersScreen(),
    ),
    GoRoute(
      path: '/employers/add',
      builder: (context, state) => EmployerFormScreen(
        existing: state.extra is Employer ? state.extra! as Employer : null,
      ),
    ),
    GoRoute(
      path: '/periods',
      builder: (context, state) => const AcademicPeriodsScreen(),
    ),
    GoRoute(
      path: '/periods/add',
      builder: (context, state) => AcademicPeriodFormScreen(
        existing: state.extra is AcademicPeriod
            ? state.extra! as AcademicPeriod
            : null,
      ),
    ),
    GoRoute(
      path: '/work/add',
      builder: (context, state) => WorkEntryFormScreen(
        planned: state.uri.queryParameters['planned'] == 'true',
        existing: state.extra is WorkEntry ? state.extra! as WorkEntry : null,
      ),
    ),
    GoRoute(
      path: '/can-i-work',
      builder: (context, state) => const CanIWorkScreen(),
    ),
    GoRoute(path: '/rules', builder: (context, state) => const RulesScreen()),
    GoRoute(
      path: '/rules/override',
      builder: (context, state) =>
          RuleOverrideScreen(base: state.extra! as LegalRule),
    ),
    GoRoute(path: '/sync', builder: (context, state) => const SyncScreen()),
    GoRoute(path: '/income', builder: (context, state) => const IncomeScreen()),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/review',
      builder: (context, state) => const ComplianceReviewScreen(),
    ),
    GoRoute(
      path: '/export',
      builder: (context, state) => const ExportBackupScreen(),
    ),
    GoRoute(
      path: '/payslips/add',
      builder: (context, state) => const PayslipFormScreen(),
    ),
  ],
);
