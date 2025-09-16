# div_growth_dashboard_bot
Automated Quant Focused on Dividend Growth Gordon Growth w/Dashboard, Scraper, and Localized Chatbot

### To Do
- Add Poetry
- Add optional -native flag
- <s>Switch to Flask?</s>
- <s>Functions/features are all over the place, consolidate to one...</s>
- Apple Silicon containers (just for compatibility)
- Embedded tableau/grafana?
- Containerized Langchain Summary bot
- MVP Dividend Algo
- Add Backtesting
- MVP Dashboard
- Add Advanced Features
- conf file prompt/auto-creation

## Why?
The idea is simple. Identify which stocks are currently priced below value that belong to a certain subset of dividend growth stocks.  The application will return a ranked list of suggestions for which stocks are the most undervalued relative to it's percieved potential value.  The challenge is that by having a system design that runs locally instead of a centralized server, the results might differ due to the effect the various processing power of different machines can vary drastically. Due to this fact and other reasons, **Nothing related to this app constitutes financial advice.  For informative purposes only. All risk and responsibility is assumed by the user.  Not responsible for any losses as a result of use of this application.**

## Goals
- Run webserver, interact with program through webserver
- (Optional) provide API keys for sentiment analysis/scraping
- Gather Stock Data
- Filter potential picks by criteria
- Identify and rank picks based on criteria

## Advanced
- Track personal portfolio
- Weight decisions based on diversification goals
- Add Growth/Speculative Strategies
- Track historical gains
- Feedback
- Transaction Automation
