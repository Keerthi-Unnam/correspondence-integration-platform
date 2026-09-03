
-- Synthetic seed: 200 correspondence requests across ~40 fake customers.
WITH base AS (
    SELECT gs,
           now() - (random() * 30 || ' days')::interval AS created
    FROM generate_series(1, 200) AS gs
)
INSERT INTO correspondence_request
    (customer_id, template_code, channel, status, idempotency_key, created_at, updated_at)
SELECT
    'CUST-' || lpad((1 + floor(random() * 40))::int::text, 4, '0'),
    (ARRAY['STMT_MONTHLY','LOAN_WELCOME','REG_NOTICE'])[1 + floor(random() * 3)::int],
    (ARRAY['EMAIL','PRINT','PORTAL'])[1 + floor(random() * 3)::int],
    (ARRAY['RECEIVED','GENERATING','GENERATED','DELIVERED','FAILED'])[1 + floor(random() * 5)::int],
    'seed-' || gs,
    created,
    created + (random() * 48 || ' hours')::interval
FROM base;