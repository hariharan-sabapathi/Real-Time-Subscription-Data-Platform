import time
import random
import psycopg2
import yaml

from services.users import create_user
from services.subscriptions import create_subscription
from services.invoices import create_invoice
from services.payments import create_payment


def load_config():
    with open("config.yaml", "r") as f:
        return yaml.safe_load(f)


def main():
    config = load_config()
    db_config = config["database"]
    gen_config = config["generation"]

    conn = psycopg2.connect(
        host=db_config["host"],
        port=db_config["port"],
        user=db_config["user"],
        password=db_config["password"],
        dbname=db_config["dbname"],
    )

    conn.autocommit = True
    cursor = conn.cursor()

    print("Generator started...")

    users = []

    while True:
        if random.random() < gen_config["user_probability"]:
            user_id = create_user(cursor)
            users.append(user_id)
            print(f"Created user {user_id}")

        if users and random.random() < gen_config["subscription_probability"]:
            user_id = random.choice(users)
            subscription_id = create_subscription(cursor, user_id)
            print(f"Created subscription {subscription_id}")

            invoice_id = create_invoice(cursor, subscription_id)
            print(f"Created invoice {invoice_id}")

            if random.random() < gen_config["payment_probability"]:
                create_payment(cursor, invoice_id)
                print("Created payment")

        time.sleep(gen_config["sleep_seconds"])


if __name__ == "__main__":
    main()