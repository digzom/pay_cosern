FROM elixir:latest

RUN apt-get update && apt-get install -y wget unzip libnss3

RUN wget https://storage.googleapis.com/chrome-for-testing-public/121.0.6167.0/linux64/chromedriver-linux64.zip && \
    unzip chromedriver-linux64.zip && \
    rm chromedriver-linux64.zip && \
    mv chromedriver-linux64/chromedriver /usr/local/bin/chromedriver

RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /app
COPY . .

RUN mix deps.get

RUN mix compile

CMD ["mix", "run", "--no-halt"]
