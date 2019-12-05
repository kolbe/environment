[[ $HOSTNAME == ideapad ]] || return 1

vlc(){
    command vlc \
        --sout "#chromecast" --sout-chromecast-ip=192.168.0.107 --demux-filter=demux_chromecast \
        --extraintf=http --http-password=vlcpass --http-port=8888 \
        "$@"
}
