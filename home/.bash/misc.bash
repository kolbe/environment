sshcreen(){ ssh -t "$@" screen -xR; }
msh(){ mosh "$@" -- screen -xR; }
joinargs(){ delim=${delim:-,}; local IFS=$delim; arr=("$@"); echo "$*"; }
lht() { ls -lhtr "$@"; }
rmln(){ file=$1; shift; { printf %sd\\n "$@"; echo w; } | ed -s "$file"; }
look(){ out=$(qlmanage -p "$@" 2>&1) || echo "$out" ; }
ql(){ out=$(qlmanage -p "$@" 2>&1) || echo "$out" ; }
lk(){ look "$@"; }
box() {
    local tput=$(tput bold)
    tputreset=$(tput sgr0)
    #width=${WIDTH:-$((COLUMNS-2))}
    width=${WIDTH:-72}
    if (($#>1)); then
        if [[ $1 = [0-9] ]]; then
            tput=$tput$(tput setaf $1)
        else
            tput=$1
        fi
        shift
    fi
    ((DEBUG)) && declare -p width

    printf -v line "%*s" "$width"
    printf %s\\n "┏${line// /━}┓"
    for msg in "$@"; do
        ((DEBUG)) && declare -p msg
        ((DEBUG)) && echo '${#msg}: '"${#msg}"
        pre_space=$(( width / 2 + ${#msg} / 2 ))
        ((DEBUG)) && declare -p pre_space
        post_space=$(( width - ((width-1)/2 + ${#msg}/2) + width%2 ))
        ((DEBUG)) && declare -p post_space
        printf -v center "%s%s %${pre_space}s %s%${post_space}s" ┃ "$tput" "$msg" "$tputreset" ┃
        printf %s\\n "$center"
    done
    printf %s\\n "┗${line// /━}┛"
}
retry(){
    local success=0 i=1
    while ! ((success)); do
        if "$@"; then
            success=1
            echo "$i: $(tput setaf 2)success$(tput sgr0)"
        else
            echo "$i: $(tput setaf 1; tput bold)failure$(tput sgr0)"
            sleep 1
        fi
        ((i++))
   done
}
prettystack(){
    sed -e 's/\\t/      /g' -e 's/\\n/\
        /g'
}

