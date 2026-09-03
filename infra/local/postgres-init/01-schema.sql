
-- Correspondence ledger schema (synthetic bank — no real data, see repo README)

CREATE TABLE correspondence_request (
    request_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id     TEXT NOT NULL,
    template_code   TEXT NOT NULL CHECK (template_code IN ('STMT_MONTHLY','LOAN_WELCOME','REG_NOTICE')),
    channel         TEXT NOT NULL CHECK (channel IN ('EMAIL','PRINT','PORTAL')),
    status          TEXT NOT NULL DEFAULT 'RECEIVED' CHECK (status IN ('RECEIVED','GENERATING','GENERATED','DELIVERED','FAILED')),
    idempotency_key TEXT NOT NULL UNIQUE,
    document_id     UUID,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_corr_req_customer ON correspondence_request (customer_id);
CREATE INDEX idx_corr_req_status   ON correspondence_request (status);

CREATE TABLE document (
    document_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id    UUID NOT NULL REFERENCES correspondence_request (request_id),
    s3_key        TEXT NOT NULL,
    content_type  TEXT NOT NULL DEFAULT 'application/pdf',
    size_bytes    BIGINT,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE delivery (
    delivery_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id    UUID NOT NULL REFERENCES correspondence_request (request_id),
    channel       TEXT NOT NULL CHECK (channel IN ('EMAIL','PRINT','PORTAL')),
    status        TEXT NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING','SENT','FAILED')),
    attempted_at  TIMESTAMPTZ
);