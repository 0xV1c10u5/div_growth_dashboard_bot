# Main Lib Entrypoint

## ! This is where to control user data flow

## ! Also, add a profiler here

# Populate Data Function
import yfinance as yf

def population(ticker):
    data = yf.Ticker(ticker)
    return data.info

print(population("MSFT"))
