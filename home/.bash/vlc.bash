vlcpass=vlcpass
vlcfile(){
    host=127.0.0.1
    port=8080

    if ! name=$(
        #curl -sS http://:"$vlcpass"@127.0.0.1:8080/requests/status.xml | 
        #    xmlstarlet sel -t -v "/root/information/category[@name='meta']/info[@name='filename']"
        curl -sS http://:"$vlcpass"@$host:$port/requests/playlist.xml |
            xmlstarlet sel -t -v '//node[@name="Playlist"]/leaf[@current]/@uri'
            #jq -er '.children[] | select (.name=="Playlist") | .children[] | select(.current) | .uri'
    ); then
        printf >&2 "[error] could not get a file from VLC (is anything currently playing?)\n"
        return 1
    fi
    if [[ $name = file://* ]]; then
        name=${name#file://}
    else
        printf >&2 "[error] name does not have file:// prefix (%s)\n" "$name"
        return 1
    fi
    printf '%b\n' "${name//%/\\x}"
}

vlcmv(){
    if ! (( $# == 1 )); then
        printf >&2 "[error] vlcmv should be invoked with only 1 argument\n"
        return 1
    fi
    if ! src=$(vlcfile); then
        printf >&2 "[error] no filename from VLC http api\n"
        return 1
    fi
    command mv -vi "$src" "$1"
}

vlcrm(){
    if ! src=$(vlcfile); then
        printf >&2 "[error] no filename from VLC http api\n"
        return 1
    fi
    command rm -i "$src"
}
