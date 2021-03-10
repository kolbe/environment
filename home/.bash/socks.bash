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
ssh-socks ()
{
    : ${PORT:=1337}
    if ! ssh -D "$PORT" -C -N -n -f -o ExitOnForwardFailure=yes "$@"; then
        echo >&2 "Failed to execute ssh command (exit $?)"
        return 1
    fi
    pgrep -lfa ssh
    socks on
    socks
    echo export http_proxy=socks5://localhost:1337
}
