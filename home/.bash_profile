PS1="\[$(tput sgr0; tput bold; tput setaf 7)\]\u@\h \[$(tput sgr0; tput dim; tput setaf 7)\][\t]\[$(tput bold; tput setaf 4)\] \W \$ \[$(tput sgr0)\]"
FIGNORE=DS_Store
#DISPLAY=:0.0
PATH=/Users/kolbe/Devel/bin:/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/mysql/bin:~/Devel/go/bin:/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin
PATH=$PATH:/opt/homebrew/lib/ruby/gems/3.1.0/bin
[[ $(uname -m) = arm64 ]] && [[ $(uname -s) = Darwin ]] && PATH=/opt/homebrew/bin:$PATH
MANPATH=/opt/homebrew/share/man:/usr/local/share/man:/usr/share/man:/usr/local/man:/usr/local/mysql/man
#JAVA_HOME=/usr
CLICOLOR=yes
LESS=-IMFXRj.3
PYTHONPATH=/Users/kolbe/Devel/pylib/
LSCOLORS=cxfxbxdxbxegedabagacad
GOPATH=/Users/kolbe/Devel/go
EDITOR=vim
export PS1 FIGNORE PATH MANPATH CLICOLOR LESS PYTHONPATH LSCOLORS GOPATH EDITOR

shopt -s histreedit extglob nocaseglob direxpand

fwdX() { socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"; }

# start new tmux instance or reconnect to existing instance
tm(){ if pgrep -x tmux; then tmux attach; else tmux; fi; }

#alias sshinit='ssh-agent -s > ~/.ssh/sshagent; source ~/.ssh/sshagent; ssh-add;'
#source ~/.ssh/sshagent

remx ()
{
    for ((i=0; $#>1; i++))
    do
        ( set -x;
        ssh "$1" "${!#}" ) & shift;
    done
}

g(){ grep -ri "$@" ${GREPPATH:-*}; }

awksum() { if [[ $1 ]]; then c=$1; else c=1; fi; awk '{s+=$'$c'}END{print s}'; }
c(){ local IFS=';'; e="scale=6;$*"; bc<<<"$e"; }
sprunge() { curl -F 'sprunge=<-' http://sprunge.us; }
clbin()   { curl -F 'clbin=<-' https://clbin.com; }
ix()      { curl -F 'f:1=<-' http://ix.io; }
myip () { ip=$(curl -4 -sS http://icanhazip.com/); echo "$ip"; host "$ip" >&2; }
pbsprunge () { pbpaste | ix | tr -d '\n' | pbcopy; pbpaste; printf '\n'; }
pbuy () { pbpaste | uy | tr -d '\n' | pbcopy; pbpaste; printf '\n'; }

human() { l=('' K M G T P E Z Y); i=$1 j=0; while ((i>=1024)); do  ((i=i/1024)); ((j++)); done; echo $i${l[$j]}; }

cpclip() {
    osascript - "$@"  2> /dev/null <<'END'
on run {a}
set the clipboard to POSIX file (POSIX path of ((POSIX file a) as alias))
end
END

}


#findi() { args=(); while (($#)); do args+=("-iname"); args+=("*${1}*"); shift; (($#)) && args+=("-o"); done; find . "${args[@]}"; }
findi() { args=(); cmd=(); if [[ $1 == -vlc ]]; then cmd=(-exec open -a VLC '{}' +); shift; fi; while (($#)); do args+=("-iname"); args+=("*${1}*"); shift; (($#)) && args+=("-o"); done; find . "${args[@]}" "${cmd[@]}" ; }
ifind() { findi "$@"; }

# many ev 1234 gf -- 1 2 4
many() { local c=() i; while :; do i=$1; shift; [[ $i = -- ]] && break; c+=("$i"); (($#)) || return; done; for i; do "${c[@]}" "$i"; done; }

#kash() { unset IFS; [[ -n $1 ]] && top=$1 || top=100; eval $(printf 'kill '; printf '%%%i ' $(seq 1 $top)) 2>/dev/null; }
#kash() { kill $(jobs -p "$@"); }
kash() { while read -r job _; do kill "%${job//[^0-9]/}"; done < <(jobs); }

ls() { env ls -F "$@"; }

nowrap ()
{
    cut -c -"$(($(tput cols)-5))"
}

function ltx() {
	for i in $*; do
		/usr/local/teTeX/bin/powerpc-apple-darwin-current/latex $i;
		/usr/local/teTeX/bin/powerpc-apple-darwin-current/dvipdfm `basename $i latex`dvi;
		open `basename $i latex`pdf;
	done
}
find_uniq() { max_iter=100; [[ -z $1 ]] && { printf "must specify filename\n">&2; return 1; }; file=$1; base=${file%.*}; ext=${file##*.}; for ((i=0; i<=max_iter;)); do if ! [[ -e "$file" ]]; then printf "%s\n" "$file"; return; else file="${base} ($((++i))).${ext}"; fi; done; printf "could not find suitable file within 100 iterations\n">&2; return 1;  }

dns(){ command dscacheutil -q host -a name "$@"; }

h(){
    if ! (($#)); then
        x=-1 y=-1
    else
        x=$1 y=$1
    fi
    [[ $2 ]] && y=$2
    while IFS= read -r ln; do
        printf %s\\n "${ln:2}"
    done < <(fc -nl "$x" "$y")
}

alias calc='open /Applications/Calculator.app/'
alias duh='du -skc -- * | sort -n | hr -k'
alias hide='unset HISTFILE'
alias mv='mv -vi'
[[ $(uname) == Darwin ]] && vlc(){ open -a VLC "$@"; }

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|screen*|tmux*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

alias nohist='unset HISTFILE'

alias awskmk='ln -sf ~/.awssecret_kolbe ~/.awssecret'
alias awssky='ln -sf ~/.awssecret_skysql ~/.awssecret'

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

for f in ~/.bash/*.bash ~/.bash/*.sh; do [[ -e $f ]] && source "$f"; done
[[ -e ~/.bash_profile.private ]] && source ~/.bash_profile.private

#export FLEETCTL_ENDPOINT=http://172.17.8.101:4001
#export KUBERNETES_MASTER=http://172.17.8.101:8080


source ~/.bashrc
complete -C /usr/local/bin/mc mc
rmv(){ rsync -avP --remove-source-files "$@"; }
export PATH=/Users/kolbe/.tiup/bin:$PATH

if type brew >/dev/null 2>&1 && [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]]
then
     . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
fi

ssh-auth-fix(){
    if [[ $(uname -s) == Darwin ]]
    then
        while read -r row
        do
            export SSH_AUTH_SOCK="${row:1}"
        done < <(
            lsof -F n -p $(pgrep ssh-agent) -a -d 3 2>/dev/null | grep '^n'
        )
    fi
}
