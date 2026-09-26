# Erlang Network Notes

## What We Learned

- `workstation:8080` is exposed as a public HTTPS URL, but that only covers HTTP/HTTPS traffic.
- Distributed Erlang needs raw TCP access, not HTTP.
- To connect Erlang nodes, the important ports are:
  - `4369` for `epmd`
  - one fixed Erlang distribution port, for example `9100`
- `-sname` is the simpler mode for the lab when using short hostnames.
- `epmd -names` on `workstation` showed the running node registered as `worker`.
- `net_adm:ping('worker@workstation')` from `gateway` returned `pang` because the distribution port was not reachable yet.
- `labctl port-forward` is for reaching lab services from your local machine.
- The public HTTPS URL exposed by iximiuz is not the same thing as raw TCP exposure for Erlang.

## Current Mental Model

1. Name resolution works.
2. `epmd` may be running.
3. The actual Erlang distribution port must also be reachable.
4. Cookie must match.
5. If any of those fail, `net_adm:ping/1` returns `pang`.

## Next Useful Setup

- Use `erl -sname ... -setcookie ...` on both machines.
- Pin the distribution port with:
  - `-kernel inet_dist_listen_min 9100 inet_dist_listen_max 9100`
- Verify the target machine is reachable on:
  - `4369`
  - the pinned distribution port

