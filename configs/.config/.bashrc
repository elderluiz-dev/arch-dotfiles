#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias e='gnome-text-editor'
alias calc='gnome-calculator'
alias pdf='xdg-open'
alias refresh='exec bash'
alias bashrc='gnome-text-editor /home/athlas/.bashrc &'
alias ff='\clear; fastfetch'
alias clear='clear; fastfetch'
alias waybar='waybar &>/dev/null &'
alias hypr='gnome-text-editor ~/.config/hypr/hyprland.lua'
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage'
alias wl="wl-copy"
alias ds="cd ~/Documentos/GitHub/data_structure"

#use 'source ~/.bashrc' every time you add a new alias
PS1='[\u@\h \W]\$ '
fastfetch

export GTK_THEME=Adwaita:dark
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
