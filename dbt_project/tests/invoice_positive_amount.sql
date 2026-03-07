SELECT *
FROM {{ ref('staging_invoices') }}
WHERE amount <= 0
