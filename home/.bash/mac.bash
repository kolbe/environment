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

power_info()
{
    system_profiler -json SPPowerDataType |
        jq -C '.SPPowerDataType[]|select(._name == "sppower_ac_charger_information")'
}
