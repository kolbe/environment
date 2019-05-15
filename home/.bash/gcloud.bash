gcloud_new_vm(){
    project=kolbe-sandbox
    basename=kmkvm
    zone=us-central1-f
    machinetype=${TYPE:-n1-standard-1}

    declare -A imgs
    while IFS=$'\t' read -r k v
    do 
        imgs[$k]=$v
    done < <(
        gcloud compute images list --format json | 
            jq -r '.[] | (.family +"\t"+ .selfLink)'
    )
    if [[ $1 ]]
    then
        img=$1
        if ! [[ ${imgs[$img]} ]]
        then
            printf '[error] image family "%s" not found. aborting.\n' >&2
            return 1
        fi
    else
        select img in "${!imgs[@]}"; do break; done
    fi
    vmimage=${imgs[$img]}
    printf "Using image '%s'\n" "$vmimage"
    lastvm=$(
        gcloud compute instances list --format json --filter 'name : '"$basename"'-*' |
            jq -r 'sort_by(.name | sub(".*-";"") | tonumber) | .[] | .name | sub(".*-";"")' |
            tail -n 1
        )
    [[ $lastvm ]] || lastvm=0
    vmname="${basename}-$((lastvm+1))"
    printf "Using vmname '%s'\n" "$vmname"
    time gcloud compute --project "$project" instances create "$vmname" --zone "$zone" --machine-type "$machinetype" --image "$vmimage" --boot-disk-size 30 --boot-disk-type pd-standard --boot-disk-device-name "$vmname"
    cmd=( gcloud compute ssh --project kolbe-sandbox --zone "$zone" "$vmname" )
    printf "$s\n" "${cmd[*]}"
    "${cmd[@]}"
}
