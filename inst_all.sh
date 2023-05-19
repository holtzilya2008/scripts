#!/bin/bash

echo "Enabling snap..."
rm /etc/apt/preferences.d/nosnap.pref

echo "Updating aptitude..."
aptitude update

echo "Installing gtypist..."
aptitude install gtypist -y

echo "Installing vlc..."
aptitude install vlc -y

echo "Installing gimp..."
aptitude install gimp -y

echo "Installing snapd..."
aptitude install snapd -y

echo "Installing atom via snap..."
snap install atom --classic

echo "Installing code via snap..."
snap install code --classic

echo "Installing htop..."
aptitude install htop -y
