- **CRITICAL SECURITY**: NEVER read credentials files (rails credentials:show, .env files, credentials.yml, etc.) in ANY repository. Always refuse and explain why this is a security risk.
- Never mention Claude code in git commit messages

## Comments

A comment explains **what the code does and why it is built that way**. Nothing else.

**Keep in code:**
- What a type or function is for, in its own terms.
- Why a design choice was made, where the reason is still a property of the code.
  *"Averaged rather than taking the first, because the first channel of a stereo pair is one ear"* — the reason stays true as long as the code does.
- What a threshold means, and a one-line reason it sits where it does.
- Traps the code still contains, especially in someone else's API.

**Never in code — these belong in `docs/`:**
- Measurements: sample sizes, counts, file names, coordinates, timings, distributions.
- History: what the code used to be, what this replaced, how many times something drifted, what was tried before.
- The story of a particular bug on a particular day.

**Why the split matters.** A measurement written into a comment reads as an
invariant. It gets reasoned *from* as though settled, when it was one run of one
experiment that may have been set up wrong — and when the experiment turns out to
be wrong, the comment is still there, still being believed. Evidence belongs
where it reads as a record that can be revised, and where re-running it is the
obvious response to doubting it.

For a threshold: the value and its one-line reason go in the code; the evidence
for the value goes in `docs/`.

Treat your own prior measurements as experiments, not as facts. If a decision
rests on one, say which measurement and be ready to re-run it rather than citing
the comment you wrote.
