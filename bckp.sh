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

    # random iv to keep along with encrypted file
    echo $RANDOM | md5sum | cut -d' ' -f1 > $dstdir/iv

    openssl aes-256-cbc -md sha256 -iv $(cat $dstdir/iv) -in $tmpdir/$filename -out $tmpdir/$filename.enc

    # to decrypt:
    # openssl aes-256-cbc -d -md sha256 -iv $dstdir/iv -in $tmpdir/$filename.enc -out $tmpdir/$filename

    rm -f $tmpdir/$filename

    mv $tmpdir/$filename.enc $dstdir/$filename.enc

    sha512sum $dstdir/$filename.enc > $dstdir/$filename.enc.sha512
else
    echo "$dstdir not a directory."
    echo $usage
fi

exit 0

