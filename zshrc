# my zshrc -- Alexis ROBERT <alexis.robert@gmail.com>

# Display a Firefly quote if there is a fortune file

# We determine if fortune is installed
which fortune > /dev/null 2>&1
retval=$?
fortune_command=fortune

# On Debian systems, fortune is not in the path, so we check directly in
# the installation directory
if [[ $retval == 1 ]]
then
    ls /usr/games/fortune > /dev/null 2>&1
    retval=$?
    fortune_command=/usr/games/fortune
fi

if [[ $retval == 0 && -f ~/.fortunes/firefly ]]
then
	$fortune_command ~/.fortunes/firefly
else
	echo -n "Don't panic. And carry a towel."
fi

[[ -f $HOME/.zsh/debug && "${ZSH_NO_DEBUG}" != "1" ]] && echo -n " (debug mode)"
[[ "${ZSH_PRIVACY_MODE}" == "1" ]] && echo -n " (privacy mode)"
echo
echo

autoload is-at-least

function debugPrint() {
	[[ -f $HOME/.zsh/debug && "${ZSH_NO_DEBUG}" != "1" ]] && echo -e $@
}

### Privacy mode ###
function privacy_mode() {
	if [[ "${ZSH_PRIVACY_MODE}" != "1" ]] ; then
		echo "Type 'exit' to disable privacy mode"
		ZSH_PRIVACY_MODE="1" ZSH_NO_DEBUG="1" zsh
		echo
		echo "Privacy mode disabled."
	else
		echo "You're already in privacy mode !"
	fi
}

### ENVIRONMENT VARIABLES ###
debugPrint "=> Setting up environment variables ..."

# Path
if [[ "$OSTYPE" == "darwin10.0" ]] ; then
	debugPrint -n "- Updating PATH for OSX"
	export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

	if [[ -f "/opt/local/bin/port" ]] ; then
		debugPrint -n " (+macports)"
		export PATH="/opt/local/sbin:/opt/local/bin:$PATH"
	fi

	if [[ -f "/sw/bin/fink" ]] ; then
		debugPrint -n " (+fink)"
		export PATH="/sw/sbin:/sw/bin:$PATH"
	fi

	debugPrint -n ", DISPLAY"
	export DISPLAY=:0.0
	export LC_ALL="C"
	export LANG="C"

	if ! which wget 2>&1 >/dev/null ; then
		debugPrint -n ", fake-wget wrapper"
		function wget() {
			curl -o "`basename $1`" "$1"
		}
	fi

	alias eject="diskutil eject"

	debugPrint ""
fi

if [[ -d $HOME/bin/ ]] ; then
	debugPrint "- Adding $HOME/bin/ to PATH ..."
	export PATH="$PATH:$HOME/bin/"
fi

### /etc/profile ###
if [[ -f /etc/profile ]] ; then
	debugPrint "=> Importing /etc/profile ..."
	source /etc/profile
fi

# Prompt
debugPrint "- Setting up prompt (PS1) ..."
autoload -U colors && colors

# We define color shortcuts
local reset="%{${reset_color}%}"
local magenta="%{$fg[magenta]%}"
local white="%{$fg[white]%}"
local gray="%{$fg_bold[black]%}"
local green="%{$fg_bold[green]%}"
local red="%{$fg[red]%}"
local blue="%{$fg[blue]%}"
local yellow="%{$fg[yellow]%}"

local op="${gray}%B[%b${reset}"
local cp="${gray}%B]%b${reset}"

source ~/.zsh/zsh-git-prompt/zshrc.sh

function collapse_pwd() {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

function setprompt() {
# First line has user info...
local usercolor="${blue}"
if [[ "$UID" == "0" ]] ; then
    usercolor="${red}" # RED prompt for root
fi
local user_host="${op}$usercolor%B%n%b${reset}@${green}%B%m%b${cp}"
local userinfo="${gray}╭─${reset}${user_host}"
local userinfo_width="${#${(S%%)${userinfo}//(\%([KF1]|)\{*\}|\%[Bbkf])}}"

# ... and current working directory
local path_p="${op}$(collapse_pwd)${cp}"
local path_p_width=${(S)path_p//\%\{*\%\}}
path_p_width="${#${(S%%)${path_p_width}//(\%([KF1]|)\{*\}|\%[Bbkf])}}"

# ... and current git status
local git_status=$(git_super_status)
if [[ -z $git_status ]] ; then
    local git_p=""
    local git_p_width=0
else
    local git_p="${gray}─${op}$(git_super_status)${cp}${gray}──${reset}"
    local git_p_width=${(S)git_p//\%\{*\%\}}
    git_p_width="${#${(S%%)${git_p_width}//(\%([KF1]|)\{*\}|\%[Bbkf])}}"
fi

local filler_width=$(($COLUMNS - ${userinfo_width} - ${git_p_width} - ${path_p_width} - 5))
local filler="${gray}${(l:${filler_width}::─:)}${reset}"

# Second line, with return code and smiley
local ret_status="${op}%B%?%b${cp}"
local smiley="%(?,${green}%B:)%b${reset},${red}%B:(%b${reset})"

# Final PROMPT
PROMPT="${userinfo}${filler}${git_p}${path_p}
${gray}╰─${reset}${ret_status}-${op}${smiley}${cp} %# "

local cur_cmd="${op}%_${cp}"
PROMPT2="${cur_cmd}> "
}

# Aliases
debugPrint "- Setting up aliases ..."
if [[ "$OSTYPE" == "darwin10.0" ]] ; then
	alias ls="ls -G"
elif [[ "$OSTYPE" == "solaris2.10" ]] ; then
	alias ls="ls -F"
else
	alias ls="ls --color=auto"
	alias grep="grep --color=auto"
fi

alias "cd.."="cd .."
alias "sl"="ls"
alias "recd"='cd $PWD'
alias "ls-l"="ls -l"
alias "grpe"="grep"

# Other environment variables (like EDITOR)
debugPrint "- Other environment variables (like EDITOR) ..."
if [[ -x /usr/bin/editor ]] ; then
	debugPrint "  -> /usr/bin/editor found"
	export EDITOR="/usr/bin/editor"
elif [[ "${EDITOR}" == "" ]] ; then
	debugPrint "  -> Falling back to vim"
	export EDITOR="vim"
fi

### ZSH SETTINGS ###
debugPrint "\n=> ZSH settings ..."

# ZKBD, for keyboard purposes :)
autoload zkbd

# Patch by Pierre-Hugues HUSSON <phhusson@free.fr>
local ZKBD_FILE
if is-at-least 4.3.6 ; then
	ZKBD_FILE=$TERM-${DISPLAY:-$VENDOR-$OSTYPE}
else
	ZKBD_FILE=$TERM-$VENDOR-$OSTYPE
fi

debugPrint "- Setting up ZKBD ($ZKBD_FILE) ..."

[[ ! -d $HOME/.zkbd/ ]] && mkdir $HOME/.zkbd/
if [[ (! -f $HOME/.zkbd/$ZKBD_FILE) && (! -f /etc/zsh/zkbd/$ZKBD_FILE) ]] ; then
	debugPrint "  -> If keys don't work, type zkbd to configure them"
fi

if [[ -f $HOME/.zkbd/$ZKBD_FILE ]] ; then
	debugPrint "  -> Loading local one."
	source $HOME/.zkbd/$ZKBD_FILE
elif [[ -f /etc/zsh/zkbd/$ZKBD_FILE ]] ; then
	debugPrint "  -> Loading global one."
	source /etc/zsh/zkbd/$ZKBD_FILE
fi

bindkey -e # Force emacs mode when EDITOR="vim"

# Add standard bindings (zsh doesn't read inputrc)
bindkey "\e[1~" beginning-of-line
bindkey "\e[2~" quoted-insert
bindkey "\e[3~" delete-char
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word

bindkey '^?' backward-delete-char 

# And override them with zkbd ones (if present)
[[ -n ${key[Home]}    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n ${key[End]}     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n ${key[Insert]}  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n ${key[Delete]}  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n ${key[Up]}      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n ${key[Down]}    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n ${key[Left]}    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n ${key[Right]}   ]]  && bindkey  "${key[Right]}"   forward-char

# Completion
debugPrint "- Completion ..."
# echo -n "Waiting, computing completion list ... "
zmodload zsh/complist
autoload -U compinit
compinit

_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1	# Because we didn't really complete anything
}
zstyle ':completion:::::' completer _complete _list _oldlist _expand _ignored _match _correct _approximate _prefix _force_rehash
#zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) )'

# Esthetic tweaks
zstyle ':completion:*:descriptions' format "- %d -"
zstyle ':completion:*:corrections' format "- %d - (errors %e})"
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^l*)' insert-sections true
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes

# Remove parent directory from completion (cd ../<TAB>)
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# ignore completion functions
zstyle ':completion:*:functions' ignored-patterns '_*'

# completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/compcache

# add colors
export LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# add hosts (from asyd)
if [[ -f ~/.zsh/hosts ]] ; then
	zstyle ':completion:*' hosts $(<~/.zsh/hosts)
fi

# echo "Done !"

# History
debugPrint -n "- Setting up history ..."
if [[ "${ZSH_PRIVACY_MODE}" != "1" ]] ; then
	export HISTFILE=$HOME/.zsh_history
	export HISTSIZE=10000
	export SAVEHIST=10000
	export LISTMAX=10000
	debugPrint ""
else
	export HISTFILE=/dev/null
	export HISTSIZE=0
	export SAVEHIST=0
	export LISTMAX=0
	debugPrint " in privacy mode."
fi

# ZSH options
debugPrint "- Setting up ZSH options ..."

# a neat time output (maybe need more testing)
export TIMEFMT="%J  %U user %S system %P cpu %*E total %Mk maxmem"

# history things
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_VERIFY

setopt AUTO_CD

setopt CORRECT # try to correct spelling

setopt NOBEEP

setopt EXTENDED_GLOB

setopt AUTOPUSHD
setopt PUSHD_MINUS
setopt PUSHD_TO_HOME
setopt PUSHD_IGNORE_DUPS

setopt AUTO_LIST

setopt AUTO_PARAM_KEYS

setopt AUTO_PARAM_SLASH
setopt AUTO_REMOVE_SLASH

setopt COMPLETE_ALIASES
setopt EQUALS
setopt EXTENDED_GLOB
setopt MAIL_WARNING
setopt MAGIC_EQUAL_SUBST
setopt NUMERICGLOBSORT

setopt AUTOMENU
setopt EXTENDEDGLOB
setopt COMPLETEINWORD
setopt NO_ALWAYSTOEND

setopt INTERACTIVECOMMENTS

# Terminal titlebar trick
function title {
	if [[ $TERM == "screen" ]]; then
		# Use these two for GNU Screen:
		print -nR $'\033k'$1$'\033'\\\

		print -nR $'\033]0;'$2$'\a'
	elif [[ $TERM == "xterm" || $TERM == "xterm-color" || $TERM == "rxvt" ]]; then
		# Use this one instead for XTerms:
		print -nR $'\033]0;'$*$'\a'
	fi
}
  
function precmd {
    title zsh `collapse_pwd`
    setprompt
}
  
function preexec {
	emulate -L zsh
	local -a cmd; cmd=(${(z)1})
	title $cmd[1]:t "$cmd[2,-1]"
}

function flip() {
  perl -C3 -Mutf8 -lpe '$_=reverse;y/a-zA-Z.['\'',({?!\"<_;‿⁅∴\r/ɐqɔpǝɟƃɥıɾʞ|ɯuodbɹsʇnʌʍxʎzɐqɔpǝɟƃɥıɾʞ|ɯuodbɹsʇnʌʍxʎz˙],'\'')}¿¡,>‾؛⁀⁆∵\n/' <<< "$1"
}

function fuck() {
    CMD="pkill"
    which $CMD >/dev/null || CMD="killall"
    echo
    FLIP=' (╯°□°）╯︵'
    if [ "$1" "==" "off" ]; then
        shift
        SIG="-9"
    else
        [ "$1" "==" "you" ] && shift
        SIG=""
    fi
    [ -z "$1" ] && { echo "┬─┬﻿ ノ( ゜-゜ノ) patience young grasshopper"; echo; return; }
    if $CMD $SIG "$1"; then
        echo "$FLIP$(flip $1)"; echo
    else
        echo "┬─┬﻿ ︵ /(.□. \）"; echo
    fi
}

### SYSTEM DEPENDENT TRICKS ###
debugPrint "\n=> System dependent tricks ..."

# Java path
if [[ "$OSTYPE" == "linux-gnu" ]] ; then
	debugPrint "- JVM autodetection ..."
	
	if [[ -h /etc/alternatives/java ]] ; then
		JAVA_HOME=$(stat --printf="%N" /etc/alternatives/java | awk -F" -> " '{print $2}' | sed s/\`// | sed s/\'// | sed "s/jre\/bin\/java//")

		if [[ -d /usr/lib/jvm/`basename $JAVA_HOME` ]] ; then
			export JAVA_HOME
			debugPrint "	JVM found at $JAVA_HOME"
		else
			unset JAVA_HOME
			debugPrint "	/!\ Error while parsing /etc/alternatives/java symlink"
		fi
	else
		debugPrint "	The autodetection needs Java and /etc/alternatives"
	fi
fi

# Autocomplete for Ubuntu (>= Feisty) -- disabled because conflicts with titlebar.
#if [[ -f /etc/zsh_command_not_found ]] ; then
#	debugPrint "- Setting ZSH 'command not found' hook ..." 
#	debugPrint "	/!\ WARNING : This conflicts with titlebar settings"
#	. /etc/zsh_command_not_found
#fi

# User's config file
debugPrint "\n=> Loading user's config file ..."
[[ -f ~/.zsh/user.zshrc ]] && source ~/.zsh/user.zshrc

debugPrint ""

true
