# ADR 0001: Adopt API-led connectivity with three layers

## Status
Accepted — 2026-09-02

## Context
Correspondence requests touch a CRM (Salesforce), a relational ledger (PostgreSQL), an
object store (S3), a third-party document service, and downstream event consumers. A single
monolithic API would couple portal-facing change to backend change, prevent reuse of
customer and document access by future consumers, and blur ownership boundaries.

## Decision
Split into Experience (per-consumer shaping and security), Process (orchestration,
idempotency, business rules) and System (one backend each, no business logic) APIs per
MuleSoft's API-led connectivity model. System APIs are published to Exchange for reuse.

## Consequences
+ Backend changes (e.g. replacing the document service) are isolated to one System API.
+ customer-sapi and document-store-sapi are reusable by other platforms.
+ Clear ownership and independent deployment/scaling per API.
- More deployables to build, test, secure and monitor (mitigated by a shared
  integration-common library and CI templates).
- Extra network hop per layer (acceptable: p95 target still met).
