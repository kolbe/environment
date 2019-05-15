myzip(){ 
    debug=${debug:-0}
    shopt -s extglob
    local result
    declare -A result
    while IFS=: read -r key value; do 
        key="${key%% *}"; 
        value="${value##*( )}"
        result["$key"]=$value
    done < <(whereami)
    coords="${result['Latitude']},${result['Longitude']}"
    ((debug)) && echo "$coords"
    if [[ $coords = "," ]]; then
        echo "[ERROR] failed to retrieve coordinates" >&2
        return 1
    fi
    curl -sS "http://maps.google.com/maps/api/geocode/json?latlng=$coords&sensor=false" |
        jq -r '[ .results[].address_components[] | select(.types[["postal_code"]] | has(0)) ][0].long_name'
        #jq -r '.["results"][] | .address_components[] | select(.types==["postal_code"]).long_name' | head -n1
        #jq -r '.["results"][] | .address_components[] | select(.types[] | select(.=="postal_code")) | .long_name'
        #jq -r '.results[0].address_components[7].long_name'
}


latlon(){ 
    debug=${debug:-0}
    shopt -s extglob
    local result
    declare -A result
    while IFS=: read -r key value; do 
        key="${key%% *}"; 
        value="${value##*( )}"
        result["$key"]=$value
    done < <(whereami)
    coords="${result['Latitude']},${result['Longitude']}"
    ((debug)) && echo "$coords"
    if [[ $coords = "," ]]; then
        echo "[ERROR] failed to retrieve coordinates" >&2
        return 1
    fi
    echo "$coords"
    #curl -sS "http://maps.google.com/maps/api/geocode/json?latlng=$coords&sensor=false" |
    #    jq -r '[ .results[].address_components[] | select(.types[["postal_code"]] | has(0)) ][0].long_name'
        #jq -r '.["results"][] | .address_components[] | select(.types==["postal_code"]).long_name' | head -n1
        #jq -r '.["results"][] | .address_components[] | select(.types[] | select(.=="postal_code")) | .long_name'
        #jq -r '.results[0].address_components[7].long_name'
}

