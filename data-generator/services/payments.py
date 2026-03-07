import random
from datetime import datetime


def create_payment(cursor, invoice_id):
    payment_status = random.choice(["success", "failed"])
    payment_amount = round(random.uniform(10, 100), 2)
    payment_date = datetime.utcnow()

    cursor.execute(
        """
        INSERT INTO payments (invoice_id, payment_date, payment_amount, payment_status)
        VALUES (%s, %s, %s, %s)
        """,
        (invoice_id, payment_date, payment_amount, payment_status),
    )