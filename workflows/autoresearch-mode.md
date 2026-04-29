# AutoResearch-Inspired Experiment Mode

Inspired by controlled research loops: baseline → hypothesis → small change → measure → keep/discard → log.

Use for bounded optimization tasks, not sensitive production changes.

## Good Fits
- Bundle size reduction.
- Test coverage improvement.
- Prompt/eval iteration.
- Performance micro-optimizations.
- Flaky test reduction.
- Query optimization with safe local benchmarks.
- Lint/type improvements.

## Bad Fits / Stop First
- Auth, billing, permissions.
- Database migrations.
- Secrets, production config, infra.
- Destructive data changes.
- Large refactors.
- Ambiguous product behavior.

## Required Setup

```md
# Experiment Setup

## Goal

## Baseline command

## Primary metric

## Secondary metrics

## Allowed files

## Forbidden areas

## Experiment budget

## Keep/discard rule

## Validation commands
```

## Loop
For each experiment:
1. State hypothesis.
2. Make smallest change.
3. Run measurement.
4. Compare to baseline.
5. Keep if improvement meets rule.
6. Otherwise revert.
7. Log result.

## Experiment Log Row

```md
| # | Hypothesis | Change | Metric before | Metric after | Result | Keep? | Notes |
```

## Rules
- One variable per experiment.
- Never silently keep a failed experiment.
- Always preserve a clean diff.
- Stop if validation fails unrelated to experiment.
