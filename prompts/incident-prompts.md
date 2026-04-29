# Incident Prompts

## Triage
```txt
We have a production issue: <symptom>.
Use incident debugging mode.
Do not edit code yet.
Assess severity, blast radius, recent changes, current evidence, top hypotheses, immediate mitigation, rollback path, and safe fix plan.
```

## Mitigation First
```txt
Before proposing a code fix, identify the fastest safe mitigation and rollback path.
List what evidence we need to confirm root cause.
```

## Postmortem
```txt
Create a post-incident report.
Include timeline, impact, root cause, detection gap, mitigation, permanent fix, follow-up actions, and tests/alerts to add.
```
