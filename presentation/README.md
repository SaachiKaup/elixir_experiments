# A Little Bit of Elixir

This folder contains a simple Beamer deck for the three distributed-Elixir experiments.

Compile it from this directory:

```bash
xelatex -interaction=nonstopmode elixir-distributed-demo.tex
xelatex -interaction=nonstopmode elixir-distributed-demo.tex
```

The two image links in `assets/` point to the copies in `~/Notes/Personal/Personal`.

The public-network slide deliberately uses `REMOTE_PUBLIC_NAME` and `LOCAL_PUBLIC_NAME`: replace these with the actual long node names used in the demo. Both sides must use `--name`, not `--sname`.
