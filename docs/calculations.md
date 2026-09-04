# Calculations

## Monthly planning target

The personal monthly hours card is not a statutory monthly allowance. It sums completed working minutes across all employers by Berlin calendar day, including the correct side of overnight month boundaries. Planned minutes are shown separately; active/cancelled records do not fill the bar.

Each configured lecture day contributes the lecture weekly budget divided by seven; each lecture-free day contributes the lecture-free budget divided by seven. Round the total once to minutes. Unconfigured days use the lecture budget and remain counted as unknown. Defaults are editable 20/40 hours per week; these are product planning choices, not legal conclusions. A monthly override replaces the computed target.

Empty is zero completed work; in-progress is below 80%; nearly-full is 80% to below target; full equals target; over-target exceeds it. Colors are paired with text and accessibility semantics. A zero target is handled without division by zero. The separate weekly, residence and Minijob references remain independent.

Work duration is elapsed UTC time minus the recorded total break. Paid duration adds back only the configured paid portion of that break, which cannot exceed the total break. Gross cents are rounded once from paid minutes times the captured hourly-rate cents, then integer bonuses and tips are added. Monetary input is parsed directly into cents, without a binary floating-point intermediate.

Residence units are aggregated per Berlin calendar date across qualifying employers before classification. Weekly student hours split overnight work by local date and group dates by ISO week-year. Working-time checks aggregate employers per day and compare chronologically adjacent completed shifts.

Minijob figures aggregate matching employers and expose reference usage plus advisory states. The 2026 income-tax calculator implements §32a independently. “Estimated net” must disclose missing withholding, contribution, insurance, and personal inputs; the UI shows no invented net amount.

An overnight shift is split at Berlin calendar midnights. Without exact break timestamps, the recorded break is allocated to the longest day segment first; this approximation can affect residence-day and daily break classification. Overlapping records are retained and explicitly warned about rather than silently discarded. Users must review the timestamps before relying on their totals.

Can I Work includes recorded plans in its forward-looking scenario but never changes historical totals until the user saves. Residence impact is the difference between the combined before/after day aggregates, not a separately rounded candidate shift. Editing simulation inputs invalidates the old preview. Overnight end times are constructed on the next calendar date, not by adding an assumed 24-hour day across DST.
