[[ $( uname -s ) == Darwin ]] && {

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

    vscode()
    {
        open -a "/Applications/Visual Studio Code.app" "$@"
    }

    bluray()
    {
        open --env JAVA_HOME=$(/usr/libexec/java_home -v 1.8.0) --env JDK_HOME=$(/usr/libexec/java_home -v 1.8.0) -a ~/Applications/Leawo\ Blu-ray\ Player.app/ "$@"
    }

}
