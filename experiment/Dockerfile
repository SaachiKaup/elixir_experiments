FROM ubuntu:24.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      erlang \
      iproute2 \
      procps \
      net-tools \
      dnsutils \
      iputils-ping \
      strace && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /lab
