# Python function to populate the DB with initial data

import yfinance as yf

EUROPE = yf.Market("EUROPE")

status = EUROPE.status
summary = EUROPE.summary

print(status)

print("---")

print(summary)

# Interact, clean and save to database

