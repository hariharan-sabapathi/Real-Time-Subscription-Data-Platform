from faker import Faker
import random
from datetime import datetime

fake = Faker()


def create_user(cursor):
    email = fake.unique.email()
    country = random.choice(["US", "UK", "CA", "DE", "IN"])
    signup_date = datetime.utcnow()
    account_status = "active"

    cursor.execute(
        """
        INSERT INTO users (email, country, signup_date, account_status)
        VALUES (%s, %s, %s, %s)
        RETURNING user_id
        """,
        (email, country, signup_date, account_status),
    )

    user_id = cursor.fetchone()[0]
    return user_id