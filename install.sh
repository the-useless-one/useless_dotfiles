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
echo -n "[wait] creating ~/$backup_dir for backup of any existing dotfiles in ~"
mkdir -p ~/$backup_dir
echo -e "\r[done]"

# We change to the dotfiles directory
echo -n "[wait] changing to the ~/$dir directory"
cd ~/$dir
echo -e "\r[done]"

# We backup every existing files from the home directory, and symlink to our new dotfiles
echo -n "[wait] moving any existing dotfiles from ~ to $backup_dir, and creating symlinks: "
for file in $files; do
	# If the file already exists, we move it in the backup directory
	if [ -f ~/.$file ] || [ -d ~/.$file ]
	then
		echo -n "$file "
		mv ~/.$file ~/$backup_dir/
	fi
	# Then, we create the symlink
	ln -s ~/$dir/$file ~/.$file
done
echo -e "\r[done]"

