FROM elixir:1.20

WORKDIR /app

COPY . .

CMD ["iex", "--name", "bar@host.docker.internal", "--cookie", "mycookie123", "-S", "mix"]
