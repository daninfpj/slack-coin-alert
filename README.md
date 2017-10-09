# Slack Coin Alert

- Edit `settings.json` to set notification treshold

```json
{
  "BTC": [min, max],
  "ETH": [min, max]
}
```

- Create an Incoming WebHooks entry on Slack 

- Add `SLACK_COIN_URL` to your environment with the webhook URL from the previous step

```bash
export SLACK_COIN_URL='https://hooks.slack.com/services/XXXXXXXXX/XXXXXXXXX/xxxxxxxxxxxxxxxxxxxxxxxx'
```

- Add a cron script

```bash
# cron.sh
#!/usr/bin/env bash

# load rvm ruby
source /home/user/.rvm/environments/ruby-2.4.1 # if using RVM
export SLACK_COIN_URL='https://hooks.slack.com/services/XXXXXXXXX/XXXXXXXXX/xxxxxxxxxxxxxxxxxxxxxxxx'

cd /home/user/slack-coin-alert
ruby /home/user/slack-coin-alert/alert.rb
```

- Add a cron entry (e.g. `crontab -e`)

```bash
# Runs the cron script every 10 minutes
*/10 * * * * /home/user/slack-coin-alert/cron.sh
```
