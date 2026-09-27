#!/bin/sh

iex --sname lovecraft --cookie howard \
  --erl "-kernel inet_dist_listen_min 9101 inet_dist_listen_max 9101"
