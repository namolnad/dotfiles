# dotfiles

Dotfiles/dev environment setup/backup

## Machine setup

On a new Mac:

```sh
curl -fsSL https://raw.githubusercontent.com/namolnad/dotfiles/main/scripts/bootstrap | bash
```

It asks for your password once and waits while you add the SSH key it makes to
GitHub; after that it runs on its own and ends with a summary of anything that
failed or needs doing by hand.

Afterwards, from this repo:

- `make update` brings packages, plugins and dotfiles up to date.
- `make bootstrap` does that and re-applies the macOS settings and login items.
- `scripts/bootstrap --dry-run` (with or without `--update`) prints what would change.

Each run is logged to `~/.local/state/dotfiles/`.

## iTerm customizations

Send Ctrl+Enter escape sequence by adding '[[CE' to Keys -> Escape Sequence
