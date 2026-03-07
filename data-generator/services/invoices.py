from datetime import datetime
import random


def create_invoice(cursor, subscription_id):
    invoice_date = datetime.utcnow()
    invoice_amount = round(random.uniform(10, 100), 2)
    invoice_status = "issued"

    cursor.execute(
        """
        INSERT INTO invoices (subscription_id, invoice_date, invoice_amount, invoice_status)
        VALUES (%s, %s, %s, %s)
        RETURNING invoice_id
        """,
        (subscription_id, invoice_date, invoice_amount, invoice_status),
    )

    invoice_id = cursor.fetchone()[0]
    return invoice_id