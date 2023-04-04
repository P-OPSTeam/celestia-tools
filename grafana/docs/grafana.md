# Grafana

## What it is ?

Grafana open source software enables you to query, visualize, alert on, and explore your metrics, logs, and traces wherever they are stored. Extracted from and feel free to read https://grafana.com/docs/grafana/latest/introduction/ for more information

## Login to the grafana page

Obtain the IP of your grafana stack (usually your validator ip), basically the one you used to install the stack and access grafana by browsing http://grafana_stack_ip:3000

Grafana will then load and will present you with the login page

![Grafana login screen](img/grafana-login.png?raw=true "Grafana login screen")

Enter the username and password as defined entered in start.sh

You will then be on the Grafana welcome page

![Grafana welcome](img/grafana-welcome.png?raw=true "Grafana welcome")

## Open a dashboard

Click on for the `4 squares` on the left menu, then `browse`, then `General`, and `Cosmos/Tendermint Network dashboard`

You will then be able to see your validator dashboard :

![Validator dashboard](img/grafana-dashboard.png?raw=true "Validator dashboard")

Feel free to explore the other dashboard and ask us any questions. You can reach out to us on discord https://discord.gg/jRAmy7uS8v or telegram https://t.me/POPS_Team_Validator


## Accessing your validator logs (loki)

Click on the `compass` on the left menu, then `Explorer`, on top click `Prometheus` and change it to `Loki`

![Grafana explore](img/grafana-explore.png?raw=true "Grafana explore")

You should now be able to use the `builder` to select a label (ie `unit`) and the value ie `celestia-appd` then click on the `Run Query` to see the logs

![Grafana celestia-appd logs](img/grafana-logs-celestia-appd.png?raw=true "Grafana celestia-appd logs")

Below an example with the logs of the loki container

![Grafana logs](img/grafana-logs.png?raw=true "Grafana logs")

> Note that logs rely on another component of the stack called promtail and is used to send the logs to loki. Freel free to checkout `conf/promtail.yaml` configuration file

## What about the alerts ?

Click on the bell on the left menu then click on `Alert rules`. You'll see the loki and prometheus rules

![Grafana Alert](img/grafana-alerts.png?raw=true "Grafana Alert")

> Free to navigate into all the defined rules which you can find the same under the `conf/prometheus/rules` and `conf/loki/rules` folder
