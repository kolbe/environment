[[ $HOSTNAME == ideapad ]] || return

vlc(){
    chromecast_device="Living Room TV"
    chromecast_ip=$(
        avahi-browse -ptcr _googlecast._tcp | 
            awk -v pattern="\"fn=$chromecast_device\"" -F\; '$10 ~ pattern {print $8}'
    )
    command vlc --sout-chromecast-ip="$chromecast_ip" "$@"
}
