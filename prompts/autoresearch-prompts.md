# AutoResearch Prompts

## Start Experiment Mode
```txt
Use AutoResearch-inspired mode.
Goal: <goal>
Do not edit files yet.
First define baseline command, primary metric, allowed files, forbidden areas, experiment budget, keep/discard rule, and validation commands.
Wait for approval before running experiments.
```

## Performance Experiment
```txt
Use AutoResearch-inspired mode to improve <metric>.
Measure baseline first.
Run up to <N> experiments.
Change one variable per experiment.
Keep only changes that improve the metric and pass validation.
Revert failed experiments.
Log every experiment.
```

## Test Coverage Experiment
```txt
Use AutoResearch-inspired mode to improve meaningful test coverage for <module>.
Do not change production behavior.
Add only tests that assert real behavior.
Run relevant tests after each experiment.
Keep only passing useful tests.
```
