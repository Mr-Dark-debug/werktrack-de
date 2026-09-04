# Regulatory research

Retrieval date: 2026-09-02. This document records the rules represented by the built-in 2026 configuration. Rules are not permanent constants; the database resolves them by effective date.

## General minimum wage

- Rule: €13.90 gross per hour from 2026-01-01.
- Interpretation: show a review hint when a configured rate is below the general reference; exceptions can apply, so do not silently alter wages.
- Source: [BMAS — General minimum wage](https://www.bmas.de/DE/Arbeit/Arbeitsrecht/Mindestlohn/mindestlohn.html).
- Implementation: `minimum_wage = 1390 euro_cents_per_hour`, effective 2026-01-01.
- Edge cases: statutory exceptions, sectoral rates, apprenticeships, mandatory internships.
- Confidence: high.

## Minijob earnings reference

- Rule: €603 monthly and €7,236 annual reference from 2026-01-01; the monthly limit is dynamically linked to minimum wage.
- Interpretation: combine multiple Minijobs when there is no liable main job. With a liable main job, normally only the first Minijob keeps privileged treatment and further jobs require assessment.
- Source: [Minijob-Zentrale — Multiple jobs](https://www.minijob-zentrale.de/DE/die-minijobs/mehrere-jobs/mehrere-jobs_node.html) and [2026 marginal-employment guidance](https://www.minijob-zentrale.de/SharedDocs/Downloads/DE/Rundschreiben/Geringfuegigkeitsrichtlinien-2026.pdf?__blob=publicationFile).
- Implementation: monthly and annual integer-cent rules; projections are advisory and a single month above the reference is never declared invalid automatically.
- Edge cases: permissible unforeseeable exceedances, fluctuating regular earnings, short-term employment, multiple-job start order.
- Confidence: high for the reference values; medium for individual classification without payroll facts.

## Third-country student work allowance

- Rule: 140 full days or 280 half-days per year; up to four hours counts as a half-day.
- Interpretation: these are two representations of one allowance. Aggregate qualifying work across employers by Berlin calendar date before classifying a day.
- Source: [Make it in Germany — Study and work](https://www.make-it-in-germany.com/en/study-vocational-training/studies-in-germany/work) and [official FAQ](https://www.make-it-in-germany.com/en/service/faq).
- Implementation: 0 minutes = 0, 1–240 minutes = one half-day unit, above 240 minutes = two units. Employers expose a manual inclusion switch.
- Edge cases: university/student-assistant work, self-employment, permit annotations, work spanning midnight, different immigration-authority interpretations.
- Confidence: high for the base allowance and four-hour boundary; individual inclusion requires confirmation.

## Student/Werkstudent weekly hours and 26-week test

- Rule: study normally remains predominant at up to 20 hours per week. Limited exceptions can concern evenings, nights, weekends, or lecture-free periods and a rolling 26-week/182-day assessment.
- Interpretation: aggregate all relevant concurrent employment across employers. More than 20 hours is “review required,” not automatically illegal. The 26-week counter alone cannot decide insurance status.
- Source: [TK — employed students](https://www.tk.de/techniker/versicherung/gut-versichert-in-jeder-lebenslage/versichert-als-studierende/geld-verdienen-im-studium/beschaeftigte-studenten-2007410), [TK — 26-week rule](https://www.tk.de/firmenkunden/versicherung/versicherung-faq/haeufige-fragen-zu-studenten-und-praktikanten/wie-oft-duerfen-werkstudenten-ueber-20-std-arbeiten-2036712), and [Deutsche Rentenversicherung — Werkstudent privilege](https://www.deutsche-rentenversicherung.de/DRV/DE/Experten/Arbeitgeber-und-Steuerberater/summa-summarum/Lexikon/W/werkstudentenprivileg.html).
- Implementation: ISO-week aggregate with 15/18/20-hour UI bands; rolling detail tracks weeks over 20. Academic context comes only from user-entered university dates.
- Edge cases: pre-planned duration, permanent employment, exam completion, leave, multiple jobs, compulsory internships, self-employment, exact rolling-year endpoint.
- Confidence: high for tracking references; medium for final status classification.

## Working Time Act

- Rule: working time across employers is added together. The standard working day is eight hours; extension to ten hours is possible subject to averaging. More than six through nine hours requires at least 30 minutes of break, more than nine requires 45; base rest is 11 continuous hours.
- Source: [Arbeitszeitgesetz §§2–5](https://www.gesetze-im-internet.de/arbzg/BJNR117100994.html).
- Implementation: 8:01–10:00 produces an extended-day notice, above 10:00 a high-priority warning, exact break boundaries are respected, and adjacent entries are checked for the base rest reference.
- Edge cases: sector exceptions, collective agreements, on-call work, Sundays/holidays, averaging evidence not held by the app.
- Confidence: high for base statutory text; individual exceptions require review.

## 2026 income-tax tariff

- Rule: §32a EStG for 2026 uses a €12,348 basic allowance and the official progressive-zone formulae through the 42% and 45% zones.
- Source: [EStG §32a](https://www.gesetze-im-internet.de/estg/__32a.html) and [BMF — 2026 tax changes](https://www.bundesfinanzministerium.de/Content/DE/Standardartikel/Themen/Steuern/das-aendert-sich-2026.html).
- Implementation: taxable income is floored to whole euros and the tariff result is floored to whole euros. This annual income-tax result is separate from wage-tax withholding and payroll deductions.
- Edge cases: taxable income is not the same as gross wages; joint assessment, allowances, progression proviso, church tax, solidarity surcharge, social insurance, and payroll periods require more data.
- Confidence: high for the tariff formula; low for personal net pay without complete inputs, so unavailable values remain blank or explicitly estimated.

## Disclaimer

WerkTrack DE is an organisational and estimation tool. German employment, immigration, tax and social-insurance treatment can depend on individual circumstances, employment type and residence conditions. Users should consult their employer, university/international office, immigration authority, health insurer, tax adviser or relevant authority where necessary.
