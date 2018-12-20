#!/bin/bash

blue() { printf "\n\033[0;34m $* \033[0m\n\n" && (echo $* >> /tmp/VARBS.log) ;}
red() { printf "\n\033[0;31m $* \033[0m\n\n" && (echo ERROR: $* >> /tmp/VARBS.log) ;}

NAME=$(whoami)

blue Activating Pulseaudio if not already active...
pulseaudio --start && blue Pulseaudio enabled...

#Install an AUR package manually.
aurinstall() { curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz && tar -xvf $1.tar.gz && cd $1 && makepkg --noconfirm -si && cd .. && rm -rf $1 $1.tar.gz ;}

#aurcheck runs on each of its arguments, if the argument is not already installed, it either uses packer to install it, or installs it manually.
aurcheck() {
qm=$(pacman -Qm | awk '{print $1}')
for arg in "$@"
do
if [[ $qm = *"$arg"* ]]; then
	echo $arg is already installed.
else 
	echo $arg not installed
	blue Now installing $arg...
	if [[ -e /usr/bin/packer ]]
	then
		(packer --noconfirm -S $arg && blue $arg now installed) || red Error installing $arg.
	else
		(aurinstall $arg && blue $arg now installed) || red Error installing $arg.
	fi

fi
done
}


blue Installing AUR programs...
blue \(This may take some time.\)

cat << "EOF"
   [0;1;33;93mm[0;1;32;92mm[0m   [0;1;34;94mm[0m    [0;1;31;91mm[0m [0;1;33;93mm[0;1;32;92mmm[0;1;36;96mmm[0m        [0;1;32;92mmm[0;1;36;96mmm[0;1;34;94mmm[0;1;35;95mm[0m [0;1;31;91mmm[0;1;33;93mmm[0;1;32;92mm[0m  [0;1;36;96mm[0m    [0;1;31;91mm[0m [0;1;33;93mmm[0;1;32;92mmm[0;1;36;96mmm[0m   [0;1;35;95mm[0m   
   [0;1;32;92m#[0;1;36;96m#[0m   [0;1;35;95m#[0m    [0;1;33;93m#[0m [0;1;32;92m#[0m   [0;1;34;94m"[0;1;35;95m#[0m          [0;1;34;94m#[0m      [0;1;32;92m#[0m    [0;1;34;94m#[0;1;35;95m#[0m  [0;1;31;91m#[0;1;33;93m#[0m [0;1;32;92m#[0m        [0;1;31;91m#[0m   
  [0;1;36;96m#[0m  [0;1;34;94m#[0m  [0;1;31;91m#[0m    [0;1;32;92m#[0m [0;1;36;96m#[0;1;34;94mmm[0;1;35;95mmm[0;1;31;91m"[0m          [0;1;35;95m#[0m      [0;1;36;96m#[0m    [0;1;35;95m#[0m [0;1;31;91m#[0;1;33;93m#[0m [0;1;32;92m#[0m [0;1;36;96m#m[0;1;34;94mmm[0;1;35;95mmm[0m   [0;1;33;93m#[0m   
  [0;1;34;94m#m[0;1;35;95mm#[0m  [0;1;33;93m#[0m    [0;1;36;96m#[0m [0;1;34;94m#[0m   [0;1;31;91m"[0;1;33;93mm[0m          [0;1;31;91m#[0m      [0;1;34;94m#[0m    [0;1;31;91m#[0m [0;1;33;93m"[0;1;32;92m"[0m [0;1;36;96m#[0m [0;1;34;94m#[0m        [0;1;32;92m"[0m   
 [0;1;34;94m#[0m    [0;1;33;93m#[0m [0;1;32;92m"m[0;1;36;96mmm[0;1;34;94mm"[0m [0;1;35;95m#[0m    [0;1;32;92m"[0m          [0;1;33;93m#[0m    [0;1;34;94mmm[0;1;35;95m#m[0;1;31;91mm[0m  [0;1;33;93m#[0m    [0;1;34;94m#[0m [0;1;35;95m#m[0;1;31;91mmm[0;1;33;93mmm[0m   [0;1;36;96m#[0m   
EOF
                                                               

gpg --recv-keys 5FAF0A6EE7371805 #Add the needed gpg key for neomutt

aurcheck packer i3-gaps vim-pathogen tamzen-font-git neomutt unclutter-xfixes-git urxvt-resize-font-git polybar python-pywal xfce-theme-blackbird fzf-git arc-gtk-theme ttf-monaco || red Error with basic AUR installations...
#Also installing i3lock, since i3-gaps was only just now installed.
sudo pacman -S --noconfirm --needed i3lock

#packer --noconfirm -S ncpamixer-git speedometer cli-visualizer

choices=$(cat /tmp/.choices)
for choice in $choices
do
    case $choice in
    1)
		aurcheck vim-live-latex-preview
      	;;
	6)
		aurcheck ttf-ancient-fonts
		;;
	7)
		aurcheck transmission-remote-cli-git
		;;
	8)
		aurcheck bash-pipes cli-visualizer speedometer neofetch
		;;
    esac
done
cat << "EOF"

         ▄              ▄
        ▌▒█           ▄▀▒▌
        ▌▒▒▀▄       ▄▀▒▒▒▐
       ▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐
     ▄▄▀▒▒▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐
   ▄▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀██▀▒▌
  ▐▒▒▒▄▄▄▒▒▒▒▒▒▒▒▒▒▒▒▒▀▄▒▒▌
  ▌▒▒▐▄█▀▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐
 ▐▒▒▒▒▒▒▒▒▒▒▒▌██▀▒▒▒▒▒▒▒▒▀▄▌
 ▌▒▀▄██▄▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▌
 ▌▀▐▄█▄█▌▄▒▀▒▒▒▒▒▒░░░░░░▒▒▒▐
▐▒▀▐▀▐▀▒▒▄▄▒▄▒▒▒▒▒░░░░░░▒▒▒▒▌
▐▒▒▒▀▀▄▄▒▒▒▄▒▒▒▒▒▒░░░░░░▒▒▒▐
 ▌▒▒▒▒▒▒▀▀▀▒▒▒▒▒▒▒▒░░░░▒▒▒▒▌
 ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐
  ▀▄▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄▒▒▒▒▌
    ▀▄▒▒▒▒▒▒▒▒▒▒▄▄▄▀▒▒▒▒▄▀
   ▐▀▒▀▄▄▄▄▄▄▀▀▀▒▒▒▒▒▄▄▀
  ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀▀

EOF



browsers=$(cat /tmp/.browch)
for choice in $browsers
do
	case $choice in
		3)
			gpg --recv-keys 865E6C87C65285EC #Key required for Palemoon install.
			aurcheck palemoon-bin
			;;
		4)
			aurcheck waterfox-bin
			;;
	esac
done

blue Downloading config files...
cd /home/$NAME/
git clone https://github.com/vegarab/dotfiles.git dotfiles
sudo rm -r .config .vimrc .vim .bashrc .xinitrc .Xresources .Xmodmap .gtkrc-2.0 .Xdefaults
sudo ln -s /home/$NAME/dotfiles/.config /home/$NAME/.config
sudo ln -s /home/$NAME/dotfiles/.vimrc /home/$NAME/.vimrc
sudo ln -s /home/$NAME/dotfiles/.vim /home/$NAME/.vim
sudo ln -s /home/$NAME/dotfiles/.bashrc /home/$NAME/.bashrc
sudo ln -s /home/$NAME/dotfiles/.bash_aliases /home/$NAME/.bash_aliases 
sudo ln -s /home/$NAME/dotfiles/.xinitrc /home/$NAME/.xinitrc 
sudo ln -s /home/$NAME/dotfiles/.Xmodmap /home/$NAME/.Xmodmap 
sudo ln -s /home/$NAME/dotfiles/.Xdefaults /home/$NAME/.Xdefaults 
sudo ln -s /home/$NAME/dotfiles/.gtkrc-2.0 /home/$NAME/.gtkrc-2.0

mkdir /home/$NAME/docs
mkdir /home/$NAME/dev
mkdir /home/$NAME/pics
mkdir /home/$NAME/dl

blue Generating bash/ranger/qutebrowser shortcuts...
cd /home/$NAME/
python /home/$NAME/.config/Scripts/shortcuts.py
                                                               
