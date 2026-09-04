class LegalRule {
  const LegalRule({
    required this.id,
    required this.key,
    required this.effectiveFrom,
    required this.value,
    required this.unit,
    required this.sourceUrl,
    required this.sourceTitle,
    required this.lastVerified,
    required this.metadataJson,
    this.effectiveTo,
  });

  final String id;
  final String key;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;
  final num value;
  final String unit;
  final String sourceUrl;
  final String sourceTitle;
  final DateTime lastVerified;
  final String metadataJson;
}
