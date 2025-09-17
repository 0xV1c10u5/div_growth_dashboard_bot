FROM mcr.microsoft.com/playwright:v1.48.0-focal

WORKDIR /scraper

COPY scraper.py /scraper/

# Ensure pip is available and install packages
RUN apt-get update && apt-get install -y python3-pip \
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install --no-cache-dir requests \
    && python3 -m pip install playwright

CMD ["python3", "scraper.py"]

