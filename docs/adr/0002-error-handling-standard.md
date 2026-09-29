
# ADR 0002 — Standard error handling and error envelope

## Status
Accepted — 2026-09-28

## Context
(What problem existed? Errors could be reported differently by every
endpoint. Callers would need a parser per endpoint. Backend details
could leak to callers.)

## Decision
(One global error handler, referenced by every flow. One envelope:
code, message, correlationId. Backend errors mapped to application
error types at the point they occur. on-error-propagate, not continue.)

## Consequences
(Good: one parser for callers, one place to change, no leakage.
Cost: a custom error type needs a producer before a handler can
reference it — which is a real build failure I hit.)

## Alternatives considered
(Per-endpoint handlers — rejected because...
Returning the raw backend message — rejected because...)