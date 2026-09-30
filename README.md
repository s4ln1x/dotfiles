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
- **`scripts/`** — one installer per distro (`fedora.sh`, `mac.sh`,
  `oracle.sh`, `redhat.sh`). Archived installers for other distros live
  in `scripts/archived/`.

## Usage

```sh
./dot.sh <email> <distro> [full name]
```

- `<email>` — used for `git config --global user.email`
- `<distro>` — the basename of an installer in `scripts/` (e.g. `fedora`,
  `mac`, `oracle`, `redhat`)
- `[full name]` — full name for `git config --global user.name`

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

- Zsh uses a native two-line prompt: directory and Git branch above a green
  or red `❯` for the previous command's success or failure. Git markers are
  `+N` (staged), `!N` (modified), `?N` (untracked), and `~N` (conflicted),
  where N counts files in that state. A partially staged file counts in both
  staged and modified; conflicts have their own count. Merge/rebase actions
  also appear. The clock is on the right. This uses zsh's bundled `vcs_info`
  and one Git status scan for the counts, with no downloaded theme or daemon.
  Exact untracked counts include files inside untracked directories; large
  unignored build/dependency trees can therefore slow prompt refreshes.
- `sshx` explicitly enables trusted X11 forwarding; ordinary `ssh` keeps
  its normal behavior. `dnfup-shutdown` powers off only after every available
  update step succeeds.
- Vim plugins (`vim-airline`, `vim-gitgutter`) are auto-loaded from
  `~/.vim/pack/plugins/start/` — no plugin manager needed.
- Work-specific overrides can live in `~/.zshrc_work`; they load after the
  defaults and before autosuggestions and syntax highlighting, so those
  plugins can see any custom widgets.

## License

GPL-3.0 — see [LICENSE](./LICENSE).
