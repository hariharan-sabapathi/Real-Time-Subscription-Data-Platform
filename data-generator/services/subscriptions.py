import random
from datetime import datetime


def create_subscription(cursor, user_id):
    plan_id = random.choice([1, 2, 3])  # assuming plans seeded
    status = "active"
    start_date = datetime.utcnow()

    cursor.execute(
        """
        INSERT INTO subscriptions (user_id, plan_id, status, start_date, updated_at)
        VALUES (%s, %s, %s, %s, %s)
        RETURNING subscription_id
        """,
        (user_id, plan_id, status, start_date, start_date),
    )

    subscription_id = cursor.fetchone()[0]
    return subscription_id