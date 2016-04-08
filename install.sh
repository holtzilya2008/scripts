#! /bin/sh

#admin
USER1=$USER


apt-get -y install iptables
apt-get -y purge ufw
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

  /bin/echo "umask 077" >> /home/$USER1/.bashrc
  /bin/echo "-:ALL:ALL EXCEPT LOCAL"    > /etc/security/access.conf
  /bin/echo "$USER1  -  maxlogins 1" > /etc/security/limits.conf
  /bin/echo "ALL: PARANOID"             > /etc/hosts.deny
  /bin/echo "tty1"                      > /etc/securetty

sleep 3

apt-get -y install aptitude
aptitude -y update

# Removing "garbage"
aptitude -y purge \
empathy \
empathy-common \
evolution \
evolution-common \
gbrainy \
gnome-screensaver \
libubuntuone-1.0-1 \
nautilus-sendto-empathy \
nautilus-share \
popularity-contest \
python-ubuntuone \
python-ubuntuone-client \
python-ubuntuone-storageprotocol \
rhythmbox \
rhythmbox-plugin-cdrecorder \
rhythmbox-plugins \
rhythmbox-ubuntuone-music-store \
ubuntu-desktop \
ubuntu-standard \
ubuntuone-client \
ubuntuone-client-gnome \
gwibber \
gwibber-service \
rdesktop \
telepathy-client \
vinagre \
gnome-sudoku gnome-mahjongg quadrapassel aisleriot gnomine tomboy ufw \
rhythmbox-plugin-cdrecorder \
rhythmbox-plugin-magnatune \
rhythmbox-mozilla \
ubuntu-gnome-desktop \
evolution-indicator \
evolution-plugins \
mcp-account-manager-goa \
rhythmbox-mozilla \
rhythmbox-plugin-magnatune \
rhythmbox-plugin-zeitgeist \
totem-plugins mono-complete printer-driver-all samba bluez-tools bluez bluetooth \
telepathy-mission-control-5 skanlite telepathy-gabble telepathy-haze telepathy-logger \
pulseaudio-module-bluetooth bluedevil brltty bluez-alsa akregator


dpkg -i /home/$USER1/Programs/*.deb

wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -

/bin/echo 'deb http://download.virtualbox.org/virtualbox/debian trusty contrib' >> /etc/apt/sources.list

aptitude -y update

# Installing necessary programs
aptitude -y install smplayer codeblocks codeblocks-contrib diffuse texmaker g++ \
vlc unrar gstreamer0.10-ffmpeg \
gstreamer0.10-plugins-good   \
thunderbird enigmail thunderbird-locale-ru \
thunderbird-locale-en-gb thunderbird-locale-en-us eclipse dkms linux-headers


aptitude -y install virtualbox-5.0

/home/$USER1/Programs/VMware-Player-6.0.5-2443746.i386.bundle


# Installing all updates for packages
aptitude -y safe-upgrade


printf "PLEASE REBOOT TO COMPLETE INSTALLATION.\n"

exit 0
