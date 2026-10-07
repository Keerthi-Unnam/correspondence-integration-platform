
# ADR 0002 — Standard error handling and error envelope

## Status
Accepted — 2026-09-28

## Context
Every endpoint can fail in several ways: a malformed request, an unknown
ID, a duplicate, a database that is down. Without a shared approach, each
flow would handle these itself. With three endpoints and six kinds of
error that is eighteen blocks of near-identical code, and copies drift
apart: one flow returns "NOT_FOUND" while another returns
"RESOURCE_MISSING", and a caller cannot rely on either. Adding a field to
the error response would mean editing every copy and missing one. There
is also a risk of returning raw database messages, which expose table and
constraint names to callers.

## Decision
One error handler is defined in global-error-handler.xml and referenced by
every flow with <error-handler ref="global-error-handler" />. It contains
one block per kind of error, matched top to bottom, with ANY last.

Every failure returns the same three fields: code, message and
correlationId. Backend-specific errors are translated into application
error types where they happen — the database's generic query failure
becomes APP:DUPLICATE_KEY at the insert — so the handler responds
meaningfully without knowing anything about databases.

Handlers use on-error-propagate: an API that failed reports failure to its
caller. No database message or stack trace is ever returned.

## Consequences
Callers write one error parser instead of one per endpoint. Support staff
have a correlationId to search the logs with. Changing the envelope means
changing one file.

The cost: a custom APP:* error type must have something that produces it —
a raise-error or an error-mapping — before any handler may reference it.
This surfaced as a real build failure during implementation: the handler named APP:INVALID_ID and
APP:DUPLICATE_KEY before either existed, and the app refused to start
until a producer for each was added.

## Alternatives considered
A handler inside each flow. Rejected: eighteen copies of the same logic,
which drift apart silently and must all be edited for any change.

Returning the backend's own error message to the caller. Rejected: it
leaks table and constraint names, the wording changes when the database
version changes, and callers would be parsing text meant for developers
rather than a stable code.