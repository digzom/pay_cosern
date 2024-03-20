FROM elixir:latest

RUN apt-get update && apt-get install -y wget unzip libnss3

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install


RUN wget -O - https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN wget -c https://github.com/gleam-lang/gleam/archive/refs/tags/v1.0.0.zip && \
    unzip v1.0.0.zip && \
    rm v1.0.0.zip && \
    mv gleam-1.0.0 /usr/bin/gleam && \
    cd /usr/bin/gleam && make install

RUN wget https://storage.googleapis.com/chrome-for-testing-public/121.0.6167.0/linux64/chromedriver-linux64.zip && \
    unzip chromedriver-linux64.zip && \
    rm chromedriver-linux64.zip && \
    mv chromedriver-linux64/chromedriver /usr/bin/chromedriver

RUN mix local.hex --force && \
    mix local.rebar --force 

ENV MIX_ENV=prod

RUN wget https://github.com/gleam-lang/mix_gleam/archive/refs/tags/v0.6.2.zip && ls -la &&  \
    unzip v0.6.2.zip && \
    rm v0.6.2.zip && \
    cd mix_gleam-0.6.2 && mix do archive.build, archive.install --force

WORKDIR /app
COPY . .

ENV GUARDIAN_SECRET=${GUARDIAN_SECRET}

RUN mix deps.get
RUN mix compile
RUN mix release

# CMD ["mix", "run", "--no-halt"]
CMD ["_build/prod/rel/pay_cosern/bin/pay_cosern", "start"]
