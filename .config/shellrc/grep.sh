# grep and rg

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

# rg will read options from a config file.
export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/rg.rc
alias rgw='rg --max-columns=0'

# Clip output horizontally to not wrap lines in the terminal
alias ccc='cut -c-$(tput cols)'
