import random
import datetime
import os

# --- Configuration ---
RECORDS_TO_GENERATE = 1000
OUTPUT_FILE = 'seed.sql'

# --- Data Constants ---
DEPARTMENTS = ['Engineering', 'Sales', 'HR',
               'Marketing', 'Customer Support', 'Product']
FIRST_NAMES = ['Alice', 'Bob', 'Charlie', 'David', 'Eve', 'Frank',
               'Grace', 'Hank', 'Ivy', 'Jack', 'Liam', 'Noah', 'Emma', 'Olivia']
LAST_NAMES = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones',
              'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez']

# --- Helper Functions ---


def get_random_date(start_date, end_date):
    """Generate a random datetime between `start_date` and `end_date`"""
    time_between_dates = end_date - start_date
    days_between_dates = time_between_dates.days
    random_number_of_days = random.randrange(days_between_dates)
    random_date = start_date + datetime.timedelta(days=random_number_of_days)
    return random_date.strftime('%Y-%m-%d')


def generate_employees(count):
    values = []
    print(f"Generating {count} employees...")

    for _ in range(count):
        full_name = f"{random.choice(FIRST_NAMES)} {random.choice(LAST_NAMES)}"
        dept = random.choice(DEPARTMENTS)
        salary = random.randint(50000, 180000)

        # SQL Injection safety: escape single quotes by doubling them
        safe_name = full_name.replace("'", "''")
        values.append(f"('{safe_name}', '{dept}', {salary})")

    # Return as a tuple: (Header, Body)
    return (
        "INSERT INTO employees (name, department, salary) VALUES",
        ",\n".join(values) + ";"
    )


def generate_sales(count):
    values = []
    print(f"Generating {count} sales records...")

    start_date = datetime.date(2024, 1, 1)
    end_date = datetime.date.today()

    for _ in range(count):
        sale_date = get_random_date(start_date, end_date)
        amount = random.randint(100, 10000)

        values.append(f"('{sale_date}', {amount})")

    return (
        "INSERT INTO sales (sale_date, amount) VALUES",
        ",\n".join(values) + ";"
    )


def main():
    try:
        emp_header, emp_body = generate_employees(RECORDS_TO_GENERATE)
        sales_header, sales_body = generate_sales(RECORDS_TO_GENERATE)

        # Build the full SQL content
        file_content = [
            f"-- Auto-generated Seed Data: {datetime.datetime.now().isoformat()}",
            f"-- Records: {RECORDS_TO_GENERATE} per table",
            "",
            "BEGIN;",  # Start Transaction
            "",
            "-- Employees",
            emp_header,
            emp_body,
            "",
            "-- Sales",
            sales_header,
            sales_body,
            "",
            "COMMIT;",
            ""
        ]

        # Write to file
        with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
            f.write("\n".join(file_content))

        print(f"✅ Successfully generated {os.path.abspath(OUTPUT_FILE)}")

    except Exception as e:
        print(f"Error generating seed file: {e}")


if __name__ == "__main__":
    main()
