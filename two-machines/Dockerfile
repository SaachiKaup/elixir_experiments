FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y elixir tcpdump dnsutils

WORKDIR /app

COPY . .

RUN chmod +x run_client.sh run_server.sh
