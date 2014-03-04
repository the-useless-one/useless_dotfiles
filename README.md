# Dotfiles
Several configuration files.

Fork me on [GitHub](https://github.com/the-useless-one/useless_dotfiles).

## HISTORY

I wanted to have access to my configuration file whatever computer I used. So
I decided to create a git repository with my favorite dotfiles, and an
install script to easily backup existing config files and create the symlinks.

## USAGE

Make sure the `install` script is executable:

    chmod +x install.sh

Then, just issue a

    ./install.sh

to install my dotfiles. You can specify the dotfiles you want as arguments:

    ./install.sh vim vimrc zshrc

**WARNING:** to install my awesome wm configuration, the command is:

    ./install.sh config/awesome #not just config

**WARNING:** there is a hard-coded path in
`/useless_dotfiles/config/awesome/themes/default/theme/lua` (to wit,
`theme.wallpaper_cmd = { "awsetbg /home/useless/.config/awesome/themes/
wallpaper"}`). This is because you can't use a relative path in the theme
configuration file, so make sure to change this line.

## COPYRIGHT

Dotfiles

Yannick Méheut [useless (at) utouch (dot) fr] - Copyright © 2013

This program is free software: you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published by the 
Free Software Foundation, either version 3 of the License, or (at your 
option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General 
Public License for more details.

You should have received a copy of the GNU General Public License along 
with this program. If not, see
[http://www.gnu.org/licenses/](http://www.gnu.org/licenses/).
