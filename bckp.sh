#!/bin/bash


usage="Usage: ./bckp.sh /path/directory_to_encrypt"
user=$USER
srcdir=$1
tmpdir=/tmp
dir=/media/$user/disk/backup
time=$(date +%d.%m.%y_%T)     # Time of backup
filename=backup-$time.tar.gz  # Backup file name format.

if [[ $# -eq 0 ]] ; then
    echo $usage
    exit 1
fi


if [ -d "$dir" ]; then 
  tar -cpzf $tmpdir/$filename $srcdir 
  openssl aes-256-cbc -in $tmpdir/$filename -out $tmpdir/$filename.enc
  rm -f $tmpdir/$filename
fi

mv $tmpdir/$filename.enc $dir/$filename.enc

exit 0

