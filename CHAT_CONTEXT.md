# Chat Context

Last updated: 2026-08-29

## Goal
Understand distributed Erlang/Elixir networking using iximiuz playgrounds, then get a working two-node setup from the local Mac to the remote `workstation` VM and understand the networking path.

## What We Established

- The public `https://...iximiuz.com` URL is the iximiuz exposure entrypoint, but it is not the same thing as raw Erlang TCP reachability.
- For Erlang distribution, the important pieces are:
  - DNS/host resolution for the host part after `@`
  - TCP reachability to `epmd` on `4369`
  - TCP reachability to the fixed distribution port
  - matching cookies
- The local Mac and the remote playground VM are not on the same network, so raw TCP access to the VM ports has to go through `labctl port-forward`.

## Playground State

- Playground created successfully:
  - Name: `client-server-lab-0713460e`
  - Run ID: `6a8ec4cb490b59d073c3f695`
- Machines:
  - `workstation`
  - `server-01`
- The remote machine is the one the user is calling `workstation` in the current tunnel tests.
- The remote VM runs `epmd` on `0.0.0.0:4369` and Erlang distribution on a fixed port.

## Working Erlang Naming Pattern

- Local Mac node:
  - `lovecraft@localhost`
  - `lovecraft@workstation` was also tried, depending on `/etc/hosts`
- Remote node:
  - `cthulu@localhost`
  - `cthulu@workstation`

The exact node name host part has been a moving target during debugging, but the remote VM node currently reports itself as:

```erlang
node().
```

with output seen as:

```erlang
cthulu@localhost
```

and in earlier attempts:

```erlang
cthulu@workstation
```

## Erlang/OTP Behavior Observed

- `epmd` is running on the remote VM and listening on:
  - `0.0.0.0:4369`
  - `[::]:4369`
- The distribution port on the remote VM has been pinned to `5000` in several tests.
- On the remote VM:
  - `epmd -names` shows both nodes when queried locally
  - `net_adm:names("localhost")` and `net_adm:names("127.0.0.1")` returned:
    - `{"cthulu",5000}`
    - `{"lovecraft",5001}`
- On the Mac:
  - `gen_tcp:connect("127.0.0.1", 4369, ...)` succeeded when the `labctl` local forward was active
  - `gen_tcp:connect("127.0.0.1", 5000, ...)` also succeeded when the local forward was active
  - `net_adm:names("127.0.0.1")` was inconsistent across tunnel iterations; when the forward was correct it should show the remote node entries
  - `net_adm:ping('cthulu@localhost')` returned `pang`

## Important Tunneling Notes

- `labctl port-forward` supports:
  - `-L` for playground VM -> local Mac forwarding
  - `-R` for local Mac -> playground VM forwarding
- A previous `-R` attempt failed with:
  - `status 409`
  - `websocket: bad handshake`
- The useful local forwards for Mac -> VM Erlang tests were:
  - `labctl port-forward 6a9173b0d74f382f8443b543 -L 4369:4369`
  - `labctl port-forward 6a9173b0d74f382f8443b543 -L 5000:5000`
- `labctl port-forward --list` showed multiple entries during debugging, including:
  - local forwards on `4369`, `5000`, and `5001`
  - a reverse forward experiment on `4369`

## Current Debug State

- `strace` is not available on macOS.
- `dtruss` was mentioned as the macOS fallback if syscall-level tracing is needed.
- The immediate issue is no longer basic DNS resolution or local port binding.
- The remaining problem is matching the tunnel, node name, and ping target exactly for distributed Erlang.

## Current User Goal

Persist the current distributed Erlang / iximiuz debugging context, then continue from the tunnel and node-name mismatch investigation.

## Tool / Environment Notes

- `tcpdump` was not installed on the VM where tracing was attempted.
- `strace` is not available on macOS.
- `dtruss` is the macOS syscall-tracing fallback if needed.

## Useful Checks Already Run

### On the remote VM

```erlang
node().
```

Observed outputs included:

```erlang
cthulu@localhost
```

and earlier:

```erlang
cthulu@workstation
```

### On the remote VM

```erlang
net_adm:names("localhost").
net_adm:names("127.0.0.1").
```

Observed:

```erlang
{ok,[{"cthulu",5000},{"lovecraft",5001}]}
```

### On the Mac

```erlang
gen_tcp:connect("127.0.0.1", 4369, [binary, {active, false}], 2000).
gen_tcp:connect("127.0.0.1", 5000, [binary, {active, false}], 2000).
```

These succeeded when the local `labctl` forwards were active.

### On the Mac

```erlang
net_adm:ping('cthulu@localhost').
```

Observed:

```erlang
pang
```

## Notes to Resume From

When resuming, continue from:
- exact node-name matching between local and remote
- whether the Mac should ping `cthulu@localhost` or `cthulu@workstation`
- whether the remaining problem is cookie mismatch or host-part mismatch rather than TCP reachability
