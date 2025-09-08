# div_growth_dashboard_bot/playwright/scraper.py
from playwright.sync_api import sync_playwright

def run():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        page.goto("https://example.com")
        print("Title:", page.title())
        browser.close()

if __name__ == "__main__":
    run()

