# Fintech / payments / crypto domain

Loaded when `domain == fintech`. **Most restrictive profile in this skill.**

## Auto risk modifiers

These stack additively. If a single change touches money math AND state transitions, you add +2 AND +2 (= +4 above base). This is intentional — fintech compounding risk is real.

- Anything touching money math: **+2**
- Anything touching transaction state machines (e.g. pending → settled → refunded): **+2**
- Anything touching idempotency / retry logic: **+2**
- Anything touching webhook signature verification: **+2**
- Tests required at every risk level ≥ 1 (no exceptions).

Cap: a single task cannot exceed Risk 10. Anything calculated above 10 is treated as Risk 10 (analysis only, exact diff approval).

## Hard stops (Risk 4 — analysis only, never edit without explicit approval)

- Currency math (rounding, conversion, fees, FX rates).
- Transaction state transitions (pending → settled → refunded).
- Webhook signature verification.
- Idempotency key handling.
- Reconciliation jobs.
- Any code that produces or stores account balances.
- KYC / AML decision logic.
- Anything that emits events into accounting/ledger.

## Money math rules

- **Never use floats** for currency. Integer minor units (cents/agorot) or `Decimal`/`BigInt`.
- Round only at the boundary of display, never in the middle of computation.
- Always store the original currency code with the amount.
- Document the rounding mode explicitly.

## Audit trail

Any state change to a transaction or balance must:
- Be append-only (event-sourced or immutable log row).
- Include actor, timestamp, reason, and prior state.
- Be emitted to a durable audit sink before responding to the client.

## Reversibility

Before any change that modifies transactional code:
1. Confirm a feature flag wraps the new behavior.
2. Confirm a kill switch / rollback path exists.
3. Confirm the change is observable (metric, log, or alert).

## Testing

- Property-based tests for money math (no float drift, no negative balances, sum invariants).
- Integration tests against a sandbox of the payment provider — never mock signature verification.
- Tests for both success and every documented failure mode.

## Specific anti-patterns

- "Just adjusting the precision a tiny bit" — refuse.
- Catching `DecimalException` and falling back to floats — refuse.
- Comparing money with `==` after arithmetic — use a tolerance only at display.
- Storing card numbers, even partially, anywhere outside the PCI-scoped vault — refuse.
