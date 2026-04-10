# dotfiles

My personal dotfiles — configuration files for the tools I use daily on my
main machines. These are tailored to my own workflow, so take anything that's
useful and ignore the rest.

## What's inside

- **`dot.sh`** — top-level bootstrap: runs the distro installer, configures
  git, symlinks every file from `home/` into `$HOME/.*`, installs vim
  plugins, and switches the default shell to zsh.
- **`home/`** — dotfiles that get symlinked into `$HOME` (prefixed with `.`).
  Contains `zshrc`, `vimrc`, `tmux.conf`, `gitignore`, `gitmessage`.
- **`scripts/`** — one installer per distro (`arch.sh`, `debian.sh`,
  `fedora.sh`, `leap.sh`, `mac.sh`, `oracle.sh`, `redhat.sh`,
  `tumbleweed.sh`, `ubuntu.sh`). Each one installs the packages I want on
  that platform.

## Usage

```sh
./dot.sh <email> <distro> [full name]
```

- `<email>` — used for `git config --global user.email`
- `<distro>` — the basename of an installer in `scripts/` (e.g. `fedora`,
  `arch`, `mac`, `ubuntu`)
- `[full name]

### Examples

```sh
./dot.sh me@example.com fedora
./dot.sh me@example.com mac "Jane Doe"
./dot.sh me@example.com oracle
```

### Environment flags

- `DOTFILES_DISABLE_SLEEP=1` — force-mask sleep/suspend/hibernate targets
  on Linux even when the chassis looks like a laptop. By default this is
  only done on desktops/servers/towers (detected via `hostnamectl`).

## After installation

- A new zsh session will start using the powerlevel10k theme if it's
  available on your distro; otherwise the prompt falls back gracefully.
- Vim plugins (`vim-airline`, `vim-gitgutter`) are auto-loaded from
  `~/.vim/pack/plugins/start/` — no plugin manager needed.
- Work-specific overrides can live in `~/.zshrc_work`; it's sourced last
  so anything it defines wins.

## License

GPL-3.0 — see [LICENSE](./LICENSE).
