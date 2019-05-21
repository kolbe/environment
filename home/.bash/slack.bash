# https://api.slack.com/custom-integrations/legacy-tokens
# TiDB Community (kolbe)
tidb_slack_user_count(){
    num=$( slack_fetch_list users | grep -Ev 'pingcap.com|slackbot' | wc -l )
    box 5 "TiDB Community Slack has $(( num )) users!"
}
