#!/bin/sh

iex --sname cthulu --cookie howard \
  --erl "-kernel inet_dist_listen_min 9100 inet_dist_listen_max 9100"
