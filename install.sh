#!/bin/bash
############################
# .make.sh
# # This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

# This variable is the name of the dotfiles directory
dir=dotfiles 
# This variable is the name of the directory where we will back up existing dotfiles
backup_dir=dotfiles_back
# This variable is the list of files/dirs to symlink from the home directory
files="conky conkyrc fortunes vimrc vim zshrc"    

##########

# We create a backup directory in the home directory
echo -en "[wait] creating ~/$backup_dir for backup of any existing dotfiles in ~\r"
mkdir -p ~/$backup_dir
echo "[done]"

# We change to the dotfiles directory
echo -en "[wait] changing to the ~/$dir directory\r"
cd ~/$dir
echo "[done]"

# We backup every existing files from the home directory, and symlink to our new dotfiles
echo -n "[wait] moving any existing dotfiles from ~ to $backup_dir, and creating symlinks: "
for file in $files; do
	# This variable is used to avoir searching the whole home directory
	maxdepth=`echo $file | fgrep -o "/" | wc -l`
	maxdepth=$((maxdepth + 1))
	# We backup every found file
	find ~ -maxdepth $maxdepth -name ".$file" -exec sh -c "echo -n \"$file \"; mv {} ~/$backup_dir" \;
	# We create a symlink in the home directory
	ln -s ~/$dir/$file ~/.$file
done
echo -e "\r[done]"

