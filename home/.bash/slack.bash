# https://api.slack.com/custom-integrations/legacy-tokens
# TiDB Community (kolbe)
export SLACK_API_TOKEN=xoxp-587052434166-585611750738-599936438643-d7195166bf2d297ca3f99bc28d273e11
tidb_slack_user_count(){
    slack_fetch_list users | grep -Ev 'pingcap.com|slackbot' | wc -l
}
