# https://api.slack.com/custom-integrations/legacy-tokens
# TiDB Community (kolbe)
tidb_slack_user_count(){
    num=$( slack_fetch_list users | grep -Ev 'pingcap.com|slackbot' | wc -l )
    if [[ -t 1 ]]; then
        cmd=(box 5)
    else
        cmd=(echo)
    fi
    "${cmd[@]}" "TiDB Community Slack has $(( num )) users!"
}
