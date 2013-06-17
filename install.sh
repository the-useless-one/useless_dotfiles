#!/bin/bash
############################
# .make.sh
# # This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=dotfiles                    # dotfiles directory
olddir=dotfiles_old             # old dotfiles backup directory
files="conky conkyrc fortunes vimrc vim zshrc"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -en "[wait] creating ~/$olddir for backup of any existing dotfiles in ~\r"
mkdir -p ~/$olddir
echo "[done]"

# change to the dotfiles directory
echo -en "[wait] changing to the ~/$dir directory\r"
cd ~/$dir
echo "[done]"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
echo -n "[wait] moving any existing dotfiles from ~ to $olddir, and creating symlinks: "
for file in $files; do
	find ~ -name "$olddir" -type d -prune -o \( -name ".$file" -exec sh -c "echo -n \"$file \"; mv {} ~/$olddir" \; \)
	ln -s ~/$dir/$file ~/.$file
done
echo -e "\r[done]"

