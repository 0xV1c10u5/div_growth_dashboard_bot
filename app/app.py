# Main Lib Entrypoint

## ! This is where to control user data flow

## ! Also, add a profiler here

# Populate Data Function
import yfinance as yf

def population(ticker):
    data = yf.Ticker(ticker)
    return data.info

print(population("MSFT"))


## FIX THIS -- BROKEN CODE

# Save to Database Function
import sqlite3

def save_input_to_db(user_input: str, db_name: str = "my_database.db"):
    # Connect to the database (creates file if it doesn't exist)
    conn = sqlite3.connect(db_name)
    cursor = conn.cursor()

    # Create table if it doesn't exist
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS inputs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text_input TEXT NOT NULL
        )
    ''')

    # Insert the input into the table
    cursor.execute('INSERT INTO inputs (text_input) VALUES (?)', (user_input,))

    # Commit changes and close connection
    conn.commit()
    conn.close()

    return "Save to DB Successful"

print(save_input_to_db(population("MSFT")))
