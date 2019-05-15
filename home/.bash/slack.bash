# https://api.slack.com/custom-integrations/legacy-tokens
# TiDB Community (kolbe)
tidb_slack_user_count(){
    slack_fetch_list users | grep -Ev 'pingcap.com|slackbot' | wc -l
}
