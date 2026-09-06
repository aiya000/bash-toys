# CLAUDE.md

## READ `AGENTS.md` FIRST

**Before touching a single file in this repository, read [`AGENTS.md`](../AGENTS.md) in
the project root.**

This is not optional, and it is not something to do after the first edit has already
been made. Read it first, then decide how to do the work.

- Read it **before** the first read or edit of any file, not after
- Re-read it **before** committing, opening a Pull Request, or releasing
- Its rules **override** any default habit of yours, and any general convention you
  would otherwise apply

`AGENTS.md` is where this project records how it wants to be worked on: its bash coding
style, how assertions are written, and the checklist of files that must be updated
alongside a change. Skipping it produces work that looks fine and is wrong for this
repository.

## What `AGENTS.md` Covers

Read the file itself for the details. It is the authority; the list below is only a map
of what is in there:

- Bash coding style — quoting, `[[ ]]` over `[ ]`, 2-space indentation, spaces around
  semicolons
- `DEBUG_BASHTOYS_*` test injection
- How to run the tests (`lib/bats/bin/bats test/<name>.bats`)
- Writing assertions with `expects` — `to_be` compares as a string, `eq` compares as a
  number
- The checklists for changing `bin/` commands and `sources/` functions, which name
  every file that has to be updated together
- Option implementation guidelines — position-independent options, unknown option
  rejection
