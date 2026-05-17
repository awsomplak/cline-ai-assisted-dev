# Template: Bug Fix

## Trigger Keywords
`fix`, `debug`, `broken`, `failing`, `error`, `crash`, `bug`, `issue`, `not working`

## Plan Skeleton

### Phase 1: Diagnose
- [ ] Reproduce the issue and document exact steps/error messages
- [ ] Identify the root cause (trace through code, logs, stack trace)
- [ ] Determine scope of impact (which features/components are affected)
- [ ] Write a failing test that captures the bug (if testable)

### Phase 2: Fix & Verify
- [ ] Implement the fix with minimal changes
- [ ] Verify the failing test now passes
- [ ] Run full test suite — no regressions
- [ ] Test edge cases related to the fix
- [ ] Update documentation if the bug revealed a gap
