#!/usr/bin/env bash
set -euo pipefail

DOTFILES_PATH=$(dirname "$(realpath "${BASH_SOURCE[0]-$0}")")

#=============================================================================#
#[ Help ]=====================================================================#
#=============================================================================#

_usage() {
  cat <<'EOF'
Bootstrap a fresh machine with dotfiles, packages, and shell configuration.

Usage:
  ./dot.sh <email> <distro> <full name>
  ./dot.sh -h | --help

Examples:
  ./dot.sh me@example.com fedora "Jane Doe"
  ./dot.sh me@example.com mac "Jane Doe"
  ./dot.sh me@example.com oracle "Jane Doe"
  DOTFILES_DISABLE_SLEEP=1 ./dot.sh me@example.com fedora "Jane Doe"

Arguments:
  <email>       email for git config --global user.email
  <distro>      basename of an installer in scripts/ (fedora, mac, oracle, redhat)
  <full name>   full name for git config --global user.name

Environment:
  DOTFILES_DISABLE_SLEEP=1   force-mask sleep/suspend/hibernate targets on Linux
                             even when the chassis looks like a laptop
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  _usage
  exit 0
fi

#=============================================================================#
#[ Main Variables ]===========================================================#
#=============================================================================#

EMAIL="${1?ERROR: Please provide a valid email. Run with --help for usage}"
DISTRO_INSTALLER="${2?ERROR: Please provide desired distro installer. Run with --help for usage}"
DEVELOPER_NAME="${3?ERROR: Please provide a developer name. Run with --help for usage}"

#=============================================================================#
#[ Install Packages ]=========================================================#
#=============================================================================#

INSTALLER="${DOTFILES_PATH}/scripts/${DISTRO_INSTALLER}.sh"
if [[ -f "${INSTALLER}" ]]; then
  "${INSTALLER}"
else
  echo "No '${DISTRO_INSTALLER}' installer was found. Available installers:"
  for _script in "${DOTFILES_PATH}"/scripts/*.sh; do
    [[ -f "${_script}" ]] && basename "${_script}" .sh
  done
  exit 1
fi

#=============================================================================#
#[ Configure git ]============================================================#
#=============================================================================#

# Back up existing gitconfig only on first run. If a timestamped backup already
# exists we've run before — skip the backup to stay idempotent.
if [[ -f "${HOME}/.gitconfig" ]] && ! ls "${HOME}"/.gitconfig.bk.* &>/dev/null; then
  mv "${HOME}/.gitconfig" "${HOME}/.gitconfig.bk.$(date +%Y%m%d%H%M%S)"
fi

git config --global user.name "${DEVELOPER_NAME}"
git config --global user.email "${EMAIL}"
git config --global commit.template "${HOME}/.gitmessage"
git config --global core.editor "vim"
git config --global core.pager ''
git config --global core.excludesfile "${HOME}/.gitignore"
git config --global init.defaultBranch main
git config --global alias.poh "push origin HEAD"
git config --global alias.l "!clear && git log --color --graph --pretty=format:'%Cred%H%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -25"

#=============================================================================#
#[ Symlink Configuration Files ]==============================================#
#=============================================================================#

for configuration_file in "${DOTFILES_PATH}"/home/*; do
  if [[ -f "${configuration_file}" ]]; then
    ln -sf "${configuration_file}" "${HOME}/.${configuration_file##*/}"
  else
    echo "SKIP: ${configuration_file} is not a regular file (directories are not handled yet)"
  fi
done

mkdir -p ~/.npm-global

#=============================================================================#
#[ Vim Plugins (native vim 8+ package manager) ]==============================#
#=============================================================================#

# Vim auto-loads anything under ~/.vim/pack/*/start/ — no plugin manager needed.
# On most Linux distros the vim-airline and vim-gitgutter packages are available
# and install to /usr/share/vim/vimfiles/, which is even cleaner. If your distro
# installer already handled those, we skip the clone.

VIM_PACK_DIR="${HOME}/.vim/pack/plugins/start"
mkdir -p "${VIM_PACK_DIR}"

_clone_vim_plugin() {
  local repo="$1"
  local name="${repo##*/}"
  local target="${VIM_PACK_DIR}/${name}"
  if [[ ! -d "${target}" ]]; then
    git clone --depth 1 "https://github.com/${repo}.git" "${target}"
  fi
}

# Check the filesystem directly — `vim -es` silent-ex mode swallows :echo
# output on most builds, so grepping that is unreliable.
_system_has_vim_plugin() {
  local plugin_file="$1"
  local candidates=(
    "/usr/share/vim/vimfiles/plugin/${plugin_file}"
    "/usr/share/vim-airline/plugin/${plugin_file}"
    "/usr/share/vim-gitgutter/plugin/${plugin_file}"
  )
  for candidate in "${candidates[@]}"; do
    [[ -f "${candidate}" ]] && return 0
  done
  return 1
}

if ! _system_has_vim_plugin "airline.vim"; then
  _clone_vim_plugin "vim-airline/vim-airline"
fi
if ! _system_has_vim_plugin "gitgutter.vim"; then
  _clone_vim_plugin "airblade/vim-gitgutter"
fi

unset -f _clone_vim_plugin _system_has_vim_plugin

#=============================================================================#
#[ Linux-only tweaks ]========================================================#
#=============================================================================#

# Masking sleep targets is desktop-only behavior — doing it on a laptop means
# closing the lid no longer suspends, battery drains in your bag, and thermal
# throttling kicks in. Opt in explicitly with DOTFILES_DISABLE_SLEEP=1, or let
# the script detect a desktop chassis via hostnamectl.
if [[ "$(uname -s)" == "Linux" ]]; then
  _is_desktop_chassis() {
    command -v hostnamectl &>/dev/null || return 1
    local chassis
    chassis=$(hostnamectl --json=short 2>/dev/null | grep -o '"Chassis":"[^"]*"' | cut -d'"' -f4)
    [[ -z "${chassis}" ]] && chassis=$(hostnamectl 2>/dev/null | awk -F': ' '/Chassis/ {print $2}')
    case "${chassis}" in
      desktop|server|tower) return 0 ;;
      *) return 1 ;;
    esac
  }

  if [[ "${DOTFILES_DISABLE_SLEEP:-0}" == "1" ]] || _is_desktop_chassis; then
    echo "Masking sleep/suspend/hibernate targets (desktop or forced)"
    sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
  else
    echo "Skipping sleep-target masking (laptop or unknown chassis)"
    echo "  Force with: DOTFILES_DISABLE_SLEEP=1 ./dot.sh ..."
  fi

  unset -f _is_desktop_chassis
fi

#=============================================================================#
#[ Default Shell ]============================================================#
#=============================================================================#

if command -v zsh &>/dev/null; then
  ZSH_PATH="$(command -v zsh)"

  # Ensure zsh is listed in /etc/shells before chsh (required on some distros)
  if ! grep -qx "${ZSH_PATH}" /etc/shells 2>/dev/null; then
    echo "${ZSH_PATH}" | sudo tee -a /etc/shells >/dev/null
  fi

  # Skip chsh if the shell is already set — avoids an unnecessary password
  # prompt on systems where chsh requires it.
  CURRENT_SHELL=$(getent passwd "${USER}" | cut -d: -f7)
  if [[ "${CURRENT_SHELL}" != "${ZSH_PATH}" ]]; then
    chsh -s "${ZSH_PATH}"
  fi
fi
