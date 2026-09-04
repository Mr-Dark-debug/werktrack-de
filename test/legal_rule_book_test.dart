import 'package:flutter_test/flutter_test.dart';
import 'package:werktrack_de/domain/entities/legal_rule.dart';
import 'package:werktrack_de/domain/rules/legal_rule_book.dart';

void main() {
  LegalRule rule(int year, int cents, {DateTime? end}) => LegalRule(
    id: 'wage-$year',
    key: 'minimum_wage',
    effectiveFrom: DateTime.utc(year),
    effectiveTo: end,
    value: cents,
    unit: 'euro_cents',
    sourceUrl: 'https://www.bmas.de',
    sourceTitle: 'Test fixture',
    lastVerified: DateTime.utc(2026),
    metadataJson: '{}',
  );
  test(
    'effective-date resolution never applies a future rule to past work',
    () {
      final book = LegalRuleBook([rule(2026, 1390), rule(2027, 1460)]);
      expect(book.ruleFor('minimum_wage', DateTime(2026, 12, 31))!.value, 1390);
      expect(book.ruleFor('minimum_wage', DateTime(2027, 1, 1))!.value, 1460);
      expect(book.ruleFor('minimum_wage', DateTime(2025, 12, 31)), isNull);
    },
  );
  test('expired rule versions are unavailable rather than silently reused', () {
    final book = LegalRuleBook([
      rule(2026, 1390, end: DateTime.utc(2026, 12, 31)),
    ]);
    expect(book.ruleFor('minimum_wage', DateTime(2027, 1, 1)), isNull);
    expect(book.forDate(DateTime(2026, 9, 3)), isNull);
  });
}
