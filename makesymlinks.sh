#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################
if [ -z "$1" ]
  then
    echo "Please select a machine: "
    ls -d */ | sed  's/\///g'
    exit 1
fi


########## Variables

dir=~/Documents/dotfiles/$1 # dotfiles directory

if [ ! -d "$dir" ] 
	then
	echo "$dir does not exist."
	echo "Please select a machine: "
    ls -d */ | sed  's/\///g'
    exit 1

fi

olddir=~/Documents/dotfiles_old # old dotfiles backup directory
files="aliases bash_profile bashrc exports gitignore hushlogin viminfo" # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/Documents/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

