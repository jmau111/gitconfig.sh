alias cp='cp -rv'
alias mv='mv -v'
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias gitaliases="git config -l | grep alias | sed 's/^alias\.//g'"

function cd () {
    builtin cd "$1"
    ls -ACF
}
