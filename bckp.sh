#!/bin/bash


usage="Usage: ./bckp.sh /path/directory_to_encrypt /path/destination_directory"
user=$USER
srcdir=$1
dstdir=$2
tmpdir=./tmp
time=$(date +%d.%m.%y_%T)     # Time of backup
filename=backup-$time.tar.gz  # Backup file name format.

if [[ $# -eq 0 ]] ; then
    echo $usage
    exit 1
fi


if [ -d "$dstdir" ]; then
    tar -cpjfW $tmpdir/$filename $srcdir
    openssl aes-256-cbc -in $tmpdir/$filename -out $tmpdir/$filename.enc
    rm -f $tmpdir/$filename
    mv $tmpdir/$filename.enc $dstdir/$filename.enc
else
    echo "$dstdir not a directory."
    echo $usage
fi

exit 0

