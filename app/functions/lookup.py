# Basic Lookup Function

import yfinance as yf

def lookup_individual(ticker):
    info = yf.Ticker(ticker).info
    return info

# Test
if __name__ == "__main__":
    print(lookup_individual("MSFT"))
