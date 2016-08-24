#!/bin/bash

# This variable is the name of the dotfiles directory
install_dir=~/useless_dotfiles 
# This variable is the name of the directory where we will back up existing dotfiles
default_backup_dir=~/dotfiles_back
# This variable is the list of files/dirs available for installation
default_dotfiles="conky conkyrc fortunes vimrc vim zshrc zsh/zsh-git-prompt config/awesome"    

# If no dotfile was specified on the CLI, we ask the user which ones he wants
# to install
if [[ $# -eq 0 ]]
then
    echo "available dotfiles:"
    for file in $default_dotfiles
    do
        echo "+ $file"
    done

    echo -n "desired dotfiles [all]: "
    read desired_dotfiles

    # An empty line selects every dotfile
    if [[ -z $desired_dotfiles ]]
    then
        desired_dotfiles=$default_dotfiles
    fi
# If dotfiles were specified, we get them from the CLI
else
    desired_dotfiles=${@:1}
fi

# We check if the dotfiles are valid dotfiles
for dotfile in $desired_dotfiles
do
    if [[ "$default_dotfiles" != *"$dotfile"* ]]
    then
        echo "[fail] $dotfile is not a valid dotfile"
        exit 1
    fi
    if [[ "$dotfile" == "config/awesome" ]]
    then
        echo "[warn] there is a hardcoded path to change in config/awesome/themes/default/theme.lua, in the theme/wallpaper_cmd"
    fi
done

# We ask the user if he wants to backup existing dotfiles
backup=""
while [[ "$backup" != "y" ]] && [[ "$backup" != "n" ]]
do
    echo -n "backup existing dotfiles (non backed up file will be erased)? [Y/n]: "
    read backup
    if [[ -z $backup ]]
    then
        backup="y"
    fi
done

# If a backup was asked, we ask where we should put it
if [[ "$backup" == "y" ]]
then
    echo -n "enter backup directory [$default_backup_dir]: "
    read backup_dir
    if [[ -z $backup_dir ]]
    then
        backup_dir=$default_backup_dir
    fi
fi

# If it doesn't exist, we create the backup directory
if [ ! -d $backup_dir ]
then
    echo -n "[wait] creating $backup_dir to backup any existing dotfiles in ~"
    mkdir -p $backup_dir
    echo -e "\r[done]"
fi

# We change to the dotfiles directory
echo -n "[wait] changing to the $install_dir directory"
cd $install_dir
echo -e "\r[done]"

# We symlink to chosen dotfiles, and, if asked, we backup existing files
echo -n "[wait] symlinking to chosen dotfiles"
for file in $desired_dotfiles
do
	# If the file already exists...
    if [ -e ~/.$file ]
    then
        # ...and backup was asked, we move it to the backup directory
        if [ "$backup" == "y" ]
        then
            mv ~/.$file $backup_dir/
        # Otherwise, we remove it
        else
            rm ~/.$file
        fi
    fi
	# Then, we create the symlink
	ln -s $install_dir/$file ~/.$file
done
echo -e "\r[done]"

