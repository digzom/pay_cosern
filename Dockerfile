FROM elixir:latest

RUN apt-get update && apt-get install -y wget unzip libnss3

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install

RUN wget https://storage.googleapis.com/chrome-for-testing-public/121.0.6167.0/linux64/chromedriver-linux64.zip && \
    unzip chromedriver-linux64.zip && \
    rm chromedriver-linux64.zip && \
    mv chromedriver-linux64/chromedriver /usr/bin/chromedriver

RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /app
COPY . .

ENV MIX_ENV=prod

RUN mix deps.get
RUN mix compile
RUN mix release

# CMD ["mix", "run", "--no-halt"]
CMD ["_build/prod/rel/pay_cosern/bin/pay_cosern", "start"]
