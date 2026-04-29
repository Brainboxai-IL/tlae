# Experiment Log Checklist

Use with AutoResearch-inspired mode.

## Experiment Table

```md
| # | Hypothesis | Change | Baseline | Result | Keep? | Validation | Notes |
|---|------------|--------|----------|--------|-------|------------|-------|
```

## Required Per Experiment
- Hypothesis stated before edit.
- One variable changed.
- Measurement command run.
- Result compared to baseline.
- Keep/discard decision made.
- Reverted if discarded.
- Validation run for kept changes.

## Stop Conditions
- Metric cannot be measured.
- Validation fails and root cause is unclear.
- Change touches forbidden area.
- Experiment budget exhausted.
