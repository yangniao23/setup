#!/bin/bash
set -e
if [ $UID = 0 ]; then
	echo "You must not run this as root."
	exit 1
fi
# mkdir /tmp/yay && cd /tmp/yay && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si --noconfirm
INSTALL="openssh pulseaudio pavucontrol vim fcitx-mozc fcitx-im fcitx-configtool chromium git os-prober ntfs-3g ttf-genshin-gothic adobe-source-han-serif-jp-fonts visual-studio-code-bin ghostscript cups gsfonts cups-pdf poppler xsel dosfstools wget cronie rsync"
yay -S $INSTALL --noconfirm
wget -O /tmp/cnijfilter-mg6300-3.80-9-x86_64.pkg.tar.xz  https://ymu.dl.osdn.jp/storage/g/b/bl/bluestarlinux/repo/x86_64/cnijfilter-mg6300-3.80-9-x86_64.pkg.tar.xz
sudo pacman -U /tmp/cnijfilter-mg6300-3.80-9-x86_64.pkg.tar.xz

yay -Rs $(yay -Qdtq)
echo -e 'Section "InputClass"\n Identifier "Keyboard Defaults"\n MatchIsKeyboard "yes"\n Option "XKbLayout" "jp"\n EndSection' | sudo tee /etc/X11/xorg.conf.d/10-keyboard.conf > /dev/null
echo -e 'KEYMAP=jp106' | sudo tee  /etc/vconsole.conf > /dev/null
echo -e 'export GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport XMODIFIERS="@im=fcitx"' | sudo tee  ~/.xprofile > /dev/null
git config --global user.name "yangniao23"
git config --global user.email "yangniao23@gmail.com"
sudo systemctl start org.cups.cupsd.service
sudo systemctl enable org.cups.cupsd.service
/usr/sbin/lpadmin -p MG6300LAN -m canonmg6300.ppd -v cnijnet:/2C-9E-FC-94-A2-02 -E > /dev/null
DOMAIN="sl"
KEY="a7c8bd7459d8ef668aaaff4400fcd434"
echo "0-59 * * * * wget -O DDNSNow_update.log 'https://f5.si/update.php?domain=${DOMAIN}&password=${KEY}'" | crontab -
rm -rf /tmp/yay
#Function if happend error
trap "rm -rf /tmp/yay" 1
