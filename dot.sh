#!/usr/bin/env bash

#=============================================================================#
#[ Main Variables ]===========================================================#
#=============================================================================#

EMAIL="${1?ERROR: Please provide a valid email}"
DISTRO_INSTALLER="${2?ERROR: Please provide desire distro installer}"
USERNAME="${3-Salvador Gudino}"
DOTFILES_PATH=$(dirname "$(realpath "${BASH_SOURCE[0]-$0}")")

#=============================================================================#
#[ Install Packages ]=========================================================#
#=============================================================================#

if [ -f install_scripts/"${DISTRO_INSTALLER}".sh ]; then
  install_scripts/"${DISTRO_INSTALLER}".sh
else
  echo "No '${DISTRO_INSTALLER}' installer was found, please check the following available installers:"
  ls -1 install_scripts
  exit 1
fi

#=============================================================================#
#[ Configure git ]============================================================#
#=============================================================================#

# Make backup of previous git configuration
mv "${HOME}"/.gitconfig "${HOME}"/.gitconfig.bk
git config --global user.name "${USERNAME}"
git config --global user.email "${EMAIL}"
git config --global commit.template "${HOME}/.gitmessage"
git config --global core.editor "vim"
git config --global alias.poh "push origin HEAD"
git config --global alias.l "!clear && git log --color --graph --pretty=format:'%Cred%H%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -25"
git config --global core.pager ''
git config --global core.excludesfile "${HOME}/.gitignore"
git config --global init.defaultBranch main

#=============================================================================#
#[ Update Configuration Files ]===============================================#
#=============================================================================#

for configuration_file in home_dir/*; do
  if [ -f "${configuration_file}" ]; then
    ln -sf "${DOTFILES_PATH}/${configuration_file}" "${HOME}"/."${configuration_file##*/}"
  fi
done

#=============================================================================#
#[ Install Extra Packages ]==================================================#
#=============================================================================#

# Install vim-plug for vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install Hack Nerd Font
# shellcheck disable=SC2164
mkdir -p ~/.local/share/fonts && pushd ~/.local/share/fonts && curl -fLo 'Hack Regular Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf && popd
fc-cache -f

# Install jetbrains fonts
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

# Install 'Oh my zsh'
OH_MY_ZSH_HOME="${HOME}"/.oh-my-zsh
rm -rf "${OH_MY_ZSH_HOME}"
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash -s -- --unattended --keep-zshrc

# Install zsh-syntax-highlighting 'oh my zsh' plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${OH_MY_ZSH_HOME}/custom/plugins/zsh-syntax-highlighting"

# Install zsh-autosuggestions  'oh my zsh' plugin
git clone https://github.com/zsh-users/zsh-autosuggestions "${OH_MY_ZSH_HOME}/custom/plugins/zsh-autosuggestions"

# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${OH_MY_ZSH_HOME}/custom/themes/powerlevel10k"

# Select zsh shell as default shell
chsh -s /bin/zsh
