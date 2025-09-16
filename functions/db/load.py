# Python function to populate the DB with initial data
# ** Make sure you check to see if live trading is enabled first, if not, populate with this info data **

import yfinance as yf

def load_industry(industry):
    
    


EUROPE = yf.Market("EUROPE")

status = EUROPE.status
summary = EUROPE.summary

print(status)

print("---")

print(summary)

# Interact, clean and save to database

