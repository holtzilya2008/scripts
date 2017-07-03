#! /bin/sh

#admin
USER1=$USER

apt-get -y update &&
apt-get -y install aptitude &&
aptitude -y update


echo -n "Would you like to install firewall? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then

    /bin/echo  "Starting firewall setup"
    aptitude -y install iptables
    aptitude -y purge ufw gufw

    ########## FIREWALL SETUP #################################################

     /bin/echo '#! /bin/sh


     /bin/echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_all
     /bin/echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
     /bin/echo "0" > /proc/sys/net/ipv4/conf/all/accept_source_route
     /bin/echo "0" > /proc/sys/net/ipv4/conf/all/accept_redirects
     /bin/echo "0" > /proc/sys/net/ipv4/conf/all/secure_redirects
     /bin/echo "1" > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
     /bin/echo "0" > /proc/sys/net/ipv4/conf/all/log_martians
     /bin/echo "0" > /proc/sys/net/ipv4/ip_forward

     for i in /proc/sys/net/ipv4/conf/*; do
            /bin/echo "1" > $i/rp_filter
     done


     IPT=/sbin/iptables


      # Flushing all rules,deleting all chains
      $IPT -F
      $IPT -X

      # Setting default rule to drop
      $IPT -P INPUT DROP
      $IPT -P FORWARD DROP
      $IPT -P OUTPUT ACCEPT


      $IPT -N invalid
      $IPT -N attacks
      $IPT -N allowed


      $IPT -F invalid
      $IPT -F attacks
      $IPT -F allowed


      $IPT -A invalid -p icmp -j DROP

      $IPT -A invalid -m state --state INVALID -j DROP
      $IPT -A invalid -m state --state NEW     -j DROP


      # Log (currently off) and then drop strange packets
      #$IPT -A attacks -p tcp --tcp-flags ALL              FIN,URG,PSH         -m limit --limit 15/minute -j LOG  --log-prefix "NMAP-XMAS:"
      $IPT -A attacks -p tcp --tcp-flags ALL              FIN,URG,PSH         -j DROP
      #$IPT -A attacks -p tcp --tcp-flags ALL              ALL                 -m limit --limit 15/minute -j LOG  --log-prefix "XMAS:"
      $IPT -A attacks -p tcp --tcp-flags ALL              ALL                 -j DROP
      #$IPT -A attacks -p tcp --tcp-flags ALL              SYN,RST,ACK,FIN,URG -m limit --limit 15/minute -j LOG  --log-prefix "XMAS-PSH:"
      $IPT -A attacks -p tcp --tcp-flags ALL              SYN,RST,ACK,FIN,URG -j DROP
      #$IPT -A attacks -p tcp --tcp-flags ALL              NONE                -m limit --limit 15/minute -j LOG  --log-prefix "NULL-SCAN:"
      $IPT -A attacks -p tcp --tcp-flags ALL              NONE                -j DROP
      #$IPT -A attacks -p tcp --tcp-flags ALL              SYN,RST             -m limit --limit 15/minute -j LOG  --log-prefix "SYN-RST:"
      $IPT -A attacks -p tcp --tcp-flags ALL              SYN,RST             -j DROP
      #$IPT -A attacks -p tcp --tcp-flags ALL              SYN,FIN             -m limit --limit 15/minute -j LOG  --log-prefix "SYN-FIN:"
      $IPT -A attacks -p tcp --tcp-flags ALL              SYN,FIN             -j DROP
      #$IPT -A attacks -p tcp --tcp-flags ALL              FIN,RST             -m limit --limit 15/minute -j LOG  --log-prefix "FIN-RST:"
      $IPT -A attacks -p tcp --tcp-flags ALL              FIN,RST             -j DROP
      #$IPT -A attacks -p tcp --tcp-flags ALL              FIN                 -m limit --limit 15/minute -j LOG  --log-prefix "FIN-SCAN:"
      $IPT -A attacks -p tcp --tcp-flags ALL              FIN                 -j DROP
      #$IPT -A attacks -p tcp --tcp-flags SYN,ACK          SYN                 -m limit --limit 15/minute -j LOG  --log-prefix "SYN-!ACK:"
      $IPT -A attacks -p tcp --tcp-flags SYN,ACK          SYN                 -j DROP
      #$IPT -A attacks -p tcp --tcp-flags FIN,ACK          FIN                 -m limit --limit 15/minute -j LOG  --log-prefix "FIN-!ACK:"
      $IPT -A attacks -p tcp --tcp-flags FIN,ACK          FIN                 -j DROP
      #$IPT -A attacks -p tcp --tcp-flags ALL              PSH                 -m limit --limit 15/minute -j LOG  --log-prefix "PSH-SCAN:"
      $IPT -A attacks -p tcp --tcp-flags ALL              PSH                 -j DROP

      #Allowed incoming traffic is related and established connections
      $IPT -A allowed -m state --state ESTABLISHED,RELATED -j ACCEPT
      $IPT -A allowed -j RETURN

      $IPT -A INPUT -i lo -j ACCEPT
      $IPT -A INPUT -j attacks
      $IPT -A INPUT -j invalid
      $IPT -A INPUT -j allowed

      $IPT -A OUTPUT -p icmp -j DROP

      $IPT-save

    exit 0' > /etc/init.d/firewall

    chown root /etc/init.d/firewall
    chmod 750 /etc/init.d/firewall
    update-rc.d firewall start 34 2 3 4 5 .

    #Run
    /etc/init.d/firewall

    #Show rules
    iptables -nvL

    ########## END OF FIREWALL SETUP ############################################
    /bin/echo  "Firewall installed"
fi

echo -n "Apply paranoid settings? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
    /bin/echo  "Applying paranoid settings"

    /bin/echo "umask 077" >> /home/$USER1/.bashrc
    /bin/echo "umask 077" >> /home/$USER1/.profile
    /bin/echo "-:ALL:ALL EXCEPT LOCAL"    > /etc/security/access.conf
    /bin/echo "$USER1  -  maxlogins 1" > /etc/security/limits.conf
    /bin/echo "ALL: PARANOID"             > /etc/hosts.deny
    /bin/echo "tty1"                      > /etc/securetty
fi
sleep 2

    #/bin/echo "[Basic Settings]
    #Indexing-Enabled=false
    #" > /home/$USER1/.kde/share/config/baloofilerc

    #/bin/echo "[Basic Settings]
    #Indexing-Enabled=false
    #" > /home/$USER1/.kde/share/config/bluedevilglobalrc

    #akonadictl stop

echo -n "Remove unnecessary packages? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
    /bin/echo  "Removing unnecessary packages"
    aptitude -y purge nepomuk empathy empathy-common evolution evolution-common \
    gbrainy gnome-screensaver libubuntuone-1.0-1 nautilus-sendto-empathy \
    nautilus-share popularity-contest \
    python-ubuntuone python-ubuntuone-client \
    python-ubuntuone-storageprotocol rhythmbox rhythmbox-plugin-cdrecorder \
    rhythmbox-plugins rhythmbox-ubuntuone-music-store \
    ubuntu-desktop ubuntu-standard ubuntuone-client ubuntuone-client-gnome \
    gwibber gwibber-service rdesktop telepathy-client vinagre \
    gnome-sudoku gnome-mahjongg quadrapassel aisleriot gnomine tomboy ufw \
    rhythmbox-plugin-cdrecorder rhythmbox-plugin-magnatune rhythmbox-mozilla \
    ubuntu-gnome-desktop evolution-indicator evolution-plugins \
    mcp-account-manager-goa rhythmbox-mozilla rhythmbox-plugin-magnatune \
    rhythmbox-plugin-zeitgeist totem-plugins mono-complete printer-driver-all \
    samba bluez-tools bluez bluetooth telepathy-mission-control-5 skanlite \
    telepathy-gabble telepathy-haze telepathy-logger \
    pulseaudio-module-bluetooth bluedevil brltty bluez-alsa akregator \
    bluez-cups cracklib-runtime cups-browsed cups-bsd dc dnsutils \
    dragonplayer enchant ethtool ftp hplip ibus-qt4 icoutils \
    iproute kde-config-telepathy-accounts kde-telepathy-approver \
    kde-telepathy-auth-handler kde-telepathy-contact-list kde-telepathy-data \
    kde-telepathy-declarative kde-telepathy-desktop-applets \
    kde-telepathy-filetransfer-handler kde-telepathy-integration-module \
    kde-telepathy-send-file kde-telepathy-text-ui kdenetwork-filesharing \
    khelpcenter4 kmag kmail krdc kubuntu-docs kubuntu-restricted-addons \
    libavahi-gobject0 libkpeople3 libktpcommoninternalsprivate7 \
    libqaccessibilityclient0 libqtglib-2.0-0 libtelepathy-logger-qt4-1 \
    libtelepathy-logger3 libtelepathy-qt4-2 libvirtodbc0 libvncserver0 \
    mplayer2 mscompress plasma-runner-telepathy-contact printer-driver-c2esp \
    printer-driver-foo2zjs printer-driver-foo2zjs-common \
    printer-driver-gutenprint printer-driver-hpcups printer-driver-min12xxw \
    printer-driver-pnm2ppa printer-driver-postscript-hp printer-driver-ptouch \
    printer-driver-pxljr printer-driver-sag-gdi printer-driver-splix \
    samba-common samba-common-bin smbclient telepathy-salut toshset \
    virtuoso-minimal virtuoso-opensource-6.1-bin0 \
    virtuoso-opensource-6.1-common gufw hexchat pidgin
fi

echo -n "Would you like to install any .deb packages from folder ~/Programs (if any) ? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then

    /bin/echo  "Installing user packages"
    dpkg -i /home/$USER1/Programs/*.deb
    /bin/echo  "Updating repository data"
    aptitude -y update
    /bin/echo  "Installing necessary packages"
fi

echo -n "Would you like to prepare your system for development with vim? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then

    /bin/echo  "Installing packages"
    aptitude -y install git vim tmux

    echo "Linking configs for vim"
    DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    ln -s $DIR/.vim ~/.vim
    ln -s $DIR/.vimrc ~/.vimrc

    echo "Installing vim plugin management system"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall

    echo "Installing patched fonts for vim-airline."
    git clone https://github.com/powerline/fonts ~/.fonts

    echo -n "Would you like to install terminal color scheme for srcery-dark? (y/n)? "
    read answer_color
    if echo "$answer_color" | grep -iq "^y" ;then
        chmod 700 /home/$USER/.vim/bundle/vim-srcery-drk/term_colors/gnome_terminal.sh
        sh /home/$USER/.vim/bundle/vim-srcery-drk/term_colors/gnome_terminal.sh
        chmod 600 /home/$USER/.vim/bundle/vim-srcery-drk/term_colors/gnome_terminal.sh
    fi
    echo "Please change font in your teminal to patched one, for example Roboto Mono"

    echo -n "Would you like to install command to run vim inside tmux? (y/n)? "
    read answer_vim
    if echo "$answer_vim" | grep -iq "^y" ;then

        /bin/echo "    vide () {
            tmux -u new-session -n code \; \
                        send-keys 'vim' C-m \; \
                                split-window -v -p 5 \;
             }" >> ~/.bashrc
        /bin/echo "From now, type vide in bash and this will run splitted tmux"

    fi

    /bin/echo "source ~/.shell_prompt.sh" >> ~/.bashrc
    /bin/echo -n "Promptline plugin theme for bash installed."
    /bin/echo "To change prompt colorscheme to same as airline, run:"
    /bin/echo 'vim -c "PromptlineSnapshot ~/.shell_prompt.sh airline"'
fi

echo -n "Would you like to prepare your (amd64) system for Android development? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then

    /bin/echo  "Installing java packages"
    add-apt-repository ppa:webupd8team/java

    /bin/echo  "Installing necessary i386 libs"
    dpkg --add-architecture i386 &&
    aptitude -y update &&
    aptitude -y install oracle-java8-installer oracle-java8-set-default  \
    libc6:i386 libncurses5:i386 libstdc++6:i386 libz1:i386 libbz2-1.0:i386

    /bin/echo  "Installing git"
    aptitude -y install git
fi
    #aptitude -y install texmaker g++ \
    #vlc unrar gstreamer0.10-ffmpeg \
    #gstreamer0.10-plugins-good   \
    #thunderbird enigmail thunderbird-locale-ru thunderbird-locale-en-us

    #wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
    #/bin/echo 'deb http://download.virtualbox.org/virtualbox/debian trusty contrib' >> /etc/apt/sources.list
    #aptitude -y update
    #aptitude -y install virtualbox-5.0

/bin/echo  "Installing all updates for packages"
aptitude -y safe-upgrade

/bin/echo  "Cleaning downloaded packages cache"
rm -rf /var/cache/apt/archives

printf "PLEASE REBOOT TO COMPLETE INSTALLATION.\n"

exit 0
