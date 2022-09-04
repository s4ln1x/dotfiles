#!/usr/bin/env bash

#=============================================================================#
#[ Install Packages ]=========================================================#
#=============================================================================#
# Setting email
email="${1?ERROR: Please provide a valid email}"

# Choosing right installer
distro="${2?ERROR: Please provide desire distro}"

REPO_PATH=$(dirname "${BASH_SOURCE[0]-$0}")

exit 1

case "${distro}" in

    "leap")
        installer="leap.sh"
        ;;

    "ubuntu")
        installer="ubuntu.sh"
        ;;

    "arch")
        installer="arch.sh"
        ;;

    "debian")
        installer="debian.sh"
        ;;

    "fedora")
        installer="fedora.sh"
        ;;

    "redhat")
        installer="redhat.sh"
        ;;

    "tumbleweed")
        installer="tumbleweed.sh"
        ;;
    "*")
	echo "ERROR: That module does not exist!"

esac

echo DISTRO="${distro}" > ~/.zshrc_install
scripts/${installer}
#installers/i3.sh
#pip3 install -r installers/requeriments.txt --user
#sudo pip3 install --upgrade pip

#=============================================================================#
#[ Configure git ]============================================================#
#=============================================================================#

rm ~/.gitconfig
git config --global user.name "Salvador Gudino"
git config --global user.email "${email}"
git config --global commit.template "$HOME/.gitmessage"
git config --global core.editor "vim"
git config --global alias.poh "push origin HEAD"
git config --global alias.l "!clear && git log --color --graph --pretty=format:'%Cred%H%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -25"
git config --global core.pager ''
git config --global core.excludesfile "$HOME/.gitignore"
git config --global init.defaultBranch main

#=============================================================================#
#[ Update Configuration Files ]===============================================#
#=============================================================================#

rm "$HOME"/.gitmessage
rm "$HOME"/.gitignore
rm "$HOME"/.zshrc
rm "$HOME"/.zshrc_aliases
rm "$HOME"/.zshrc_variables
rm "$HOME"/.vimrc
mkdir -p "$HOME"/.vim
ln -fs "${REPO_PATH}/home/gitmessage" "$HOME"/.gitmessage
ln -fs "${REPO_PATH}/home/gitignore" "$HOME"/.gitignore
ln -fs "${REPO_PATH}/home/zshrc" "$HOME"/.zshrc
ln -fs "${REPO_PATH}/home/zshrc_aliases" "$HOME"/.zshrc_aliases
ln -fs "${REPO_PATH}/home/zshrc_variables" "$HOME"/.zshrc_variables
ln -fs "${REPO_PATH}/home/vimrc" "$HOME"/.vimrc

#=============================================================================#
#[ Install GitHub Packages ]==================================================#
#=============================================================================#

# Install dracula grub2 theme
#sudo git clone https://github.com/dracula/grub.git /usr/share/grub2/themes/dracula
#Change the theme in /etc/default/grub
#sudo grub2-mkconfig -o /boot/grub2/grub.cfg


# Remove header bar from gnome-terminal
#gsettings set org.gnome.Terminal.Legacy.Settings headerbar "@mb false"

# Install rustup
#curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

# Install pop shell
#pop_shell_dir="${HOME}/repos/shell"
#if [ ! -d "${pop_shell_dir}" ]; then
#    git clone https://github.com/pop-os/shell ~/repos/
#    cd ~/repos/shell
#    make local-install
#fi

# vim-plug for neovim
#sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# vim-plug for vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Hack Nerd Font
mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts && curl -fLo 'Hack Regular Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf
fc-cache -f

# Install jetbrains fonts
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

# Fira Code
installers/fira_code.sh

## Set dracula theme for gnome
#themes_dir="${HOME}/.themes"
#if [ ! -d "${themes_dir}" ]; then
#    echo "mkdir -p $themes_dir"
#    mkdir -p "${themes_dir}"
#fi
#git clone https://github.com/dracula/gtk.git "${themes_dir}"/Dracula
#gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
#gsettings set org.gnome.desktop.wm.preferences theme "Dracula"
#if [ ! -d "$HOME/Downloads" ]; then
#    echo "mkdir -p $HOME/Downloads"
#    mkdir -p "$HOME/Downloads"
#fi
#wget https://github.com/dracula/gtk/files/5214870/Dracula.zip -P ~/Downloads
#icons_dir="${HOME}/.local/share/icons"
#if [ ! -d "${icons_dir}" ]; then
#    echo "mkdir -p $icons_dir"
#    mkdir -p "${icons_dir}"
#fi
#unzip ~/Downloads/Dracula.zip -d "${icons_dir}"/
#gtk-update-icon-cache "${icons_dir}/Dracula"
#gsettings set org.gnome.desktop.interface icon-theme "Dracula"

# Oh my zsh
rm -rf "$HOME"/.oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash -s -- --unattended --keep-zshrc

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# Select zsh shell
chsh -s /bin/zsh
