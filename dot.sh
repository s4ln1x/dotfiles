#!/usr/bin/env bash
set -euo pipefail

#=============================================================================#
#[ Main Variables ]===========================================================#
#=============================================================================#

EMAIL="${1?ERROR: Please provide a valid email}"
DISTRO_INSTALLER="${2?ERROR: Please provide desired distro installer}"
DEVELOPER_NAME="${3?ERROR: Please provide a developer name}"
DOTFILES_PATH=$(dirname "$(realpath "${BASH_SOURCE[0]-$0}")")

#=============================================================================#
#[ Install Packages ]=========================================================#
#=============================================================================#

INSTALLER="${DOTFILES_PATH}/scripts/${DISTRO_INSTALLER}.sh"
if [[ -f "${INSTALLER}" ]]; then
  "${INSTALLER}"
else
  echo "No '${DISTRO_INSTALLER}' installer was found. Available installers:"
  ls -1 "${DOTFILES_PATH}/scripts"
  exit 1
fi

#=============================================================================#
#[ Configure git ]============================================================#
#=============================================================================#

# Back up existing gitconfig if present (don't error on fresh install)
[[ -f "${HOME}/.gitconfig" ]] && mv "${HOME}/.gitconfig" "${HOME}/.gitconfig.bk"

git config --global user.name "${DEVELOPER_NAME}"
git config --global user.email "${EMAIL}"
git config --global commit.template "${HOME}/.gitmessage"
git config --global core.editor "vim"
git config --global core.pager ''
git config --global core.excludesfile "${HOME}/.gitignore"
git config --global init.defaultBranch main
git config --global alias.poh "push origin HEAD"
git config --global alias.l "!clear && git log --color --graph --pretty=format:'%Cred%H%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -25"
git config --global alias.full '!git fetch && git reset --hard @{u}'

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
  # `chsh -s <shell>` (no username) changes the *current* user's shell without
  # needing root. Passing a username requires root on several distros.
  chsh -s "${ZSH_PATH}"
fi
