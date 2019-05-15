#dsh(){ eval $(boot2docker shellinit); }
# set boot2docker environment if not already set
#docker(){ [[ $DOCKER_HOST ]] || dsh; command docker "$@"; }
