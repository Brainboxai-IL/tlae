# Performance Budget Workflow

Use for latency, throughput, memory, bundle size, render performance, query performance, cost, or cold start improvements.

## Required Flow
1. Define metric.
2. Measure baseline.
3. Set target/budget.
4. Identify likely bottleneck.
5. Propose small experiments.
6. Change one variable at a time.
7. Measure after each change.
8. Keep only measurable improvements.

## Output

```md
# Performance Plan

## Goal

## Primary metric

## Secondary metrics

## Baseline command

## Baseline result

## Target budget

## Hypotheses

## Experiment limit

## Keep/discard rule

## Validation
```

## Common Metrics
- Frontend: bundle size, LCP, CLS, INP, hydration time.
- API: p50/p95/p99 latency, error rate, throughput.
- DB: query time, round trips, index usage.
- Node/server: memory, CPU, cold start.
- Cost: tokens, API calls, compute time.
