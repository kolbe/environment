socks () 
{ 
    : ${IF:=Wi-Fi}
    if [[ $# == 0 ]]; then
        cmd=(-getsocksfirewallproxy);
    else
        cmd=(-setsocksfirewallproxystate);
    fi;
    networksetup "${cmd[@]}" "$IF" "$@"
}

