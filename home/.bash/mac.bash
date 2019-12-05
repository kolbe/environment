ask ()
{
    (( $# )) || set -- 'Query?';
    printf -v script 'set T to text returned of (display dialog "%s" buttons {"Cancel", "OK"} default button "OK" default answer "")' "$*";
    osascript -e "$script"
}

alert ()
{
    (( $# )) || set -- 'Alert!';
    printf -v script 'display dialog "%s"' "$*";
    osascript -e "$script"
}
