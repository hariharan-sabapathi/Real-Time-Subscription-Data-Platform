SELECT s.*
FROM {{ ref('staging_subscription') }} s
LEFT JOIN {{ ref('table_users') }} u
ON s.user_id = u.user_id
LEFT JOIN {{ ref('table_plans') }} p
ON s.plan_id = p.plan_id
WHERE u.user_id IS NULL
OR p.plan_id IS NULL
