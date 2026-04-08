#!/usr/bin/env bash
set -euo pipefail

#=============================================================================#
#[ Main Variables ]===========================================================#
#=============================================================================#

EMAIL="${1?ERROR: Please provide a valid email}"
DISTRO_INSTALLER="${2?ERROR: Please provide desired distro installer}"
USERNAME="${3-Salvador Gudino}"
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

git config --global user.name "${USERNAME}"
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
  fi
done

#=============================================================================#
#[ Vim Plugins (native vim 8+ package manager) ]==============================#
#=============================================================================#

# Vim auto-loads anything under ~/.vim/pack/*/start/ — no plugin manager needed.
# On most Linux distros the vim-airline and vim-gitgutter packages are available
# and install to /usr/share/vim/vimfiles/, which is even cleaner. If your distro
# installer already handled those, this section is a harmless no-op.

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

# Only clone if the plugin isn't already available via system package
if ! vim -es -c 'echo globpath(&rtp, "plugin/airline.vim")' -c 'q' 2>/dev/null | grep -q airline; then
  _clone_vim_plugin "vim-airline/vim-airline"
fi
if ! vim -es -c 'echo globpath(&rtp, "plugin/gitgutter.vim")' -c 'q' 2>/dev/null | grep -q gitgutter; then
  _clone_vim_plugin "airblade/vim-gitgutter"
fi

unset -f _clone_vim_plugin

#=============================================================================#
#[ Linux-only tweaks ]========================================================#
#=============================================================================#

if [[ "$(uname -s)" == "Linux" ]]; then
  # Disable suspend and hibernation
  sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
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
  chsh -s "${ZSH_PATH}" "${USER}"
fi
