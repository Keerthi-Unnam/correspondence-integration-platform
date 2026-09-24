%dw 2.0

fun toResource(row) = {
    requestId:      row.request_id,
    customerId:     row.customer_id,
    templateCode:   row.template_code,
    channel:        row.channel,
    status:         row.status,
    idempotencyKey: row.idempotency_key,
    (documentId: row.document_id) if (row.document_id != null),
    createdAt:      row.created_at,
    updatedAt:      row.updated_at
}