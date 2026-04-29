# B2C consumer domain

Loaded when `domain == b2c`.

## Auto risk modifiers

- Anything affecting the signup/login funnel: **+1**.
- Anything affecting checkout/conversion: **+2**.
- Email/SMS/push notification copy or triggers: **+1** (deliverability + spam-reporting risk).
- A/B test surfaces: **+1** (you may invalidate an experiment).

## Hard stops (Risk 3+)

- Active A/B tests .  don't change the code path without coordinating with whoever owns the experiment.
- Push notification triggers .  sending a "test" notification to production is a real incident.
- Email templates .  broken HTML lands in millions of inboxes.

## Performance is a feature

- Any new dependency on the user-facing critical path: **+1**.
- Any blocking server call added to a hot route: **+1**.
- Bundle size budget changes need explicit approval if the project has a budget set.

## Privacy

- New data collection on users must list:
  - What field, why, where stored, retention period, who can read it.
- Cookie or local-storage additions need a check against the consent banner / privacy policy.

## Common anti-patterns

- "Temporary" tracking pixel or query param without a removal date.
- Logging full URLs that may contain query-string PII (emails, names).
- Fingerprinting libraries added without a privacy review.
