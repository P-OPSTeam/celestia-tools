# Monitoring stack for Celestia Validator

## Description
This Monitoring stack is made of :
- grafana for the viewing of the graph
- node_exporter to monitor your host
- prometheus to capture the metrics and make it available for Grafana
- process-exporter to monitor celestia-appd
- loki to display logs
- promtail to send logs to loki
- alertmanager integrated with pagerduty to receive alert
- local otel collector configured to forward the DA node metrics to CELESTIA_OTEL and expose the DA node prometheus metrics (:25660)

## Prereq

- celestia-appd and celestia needs to be installed with systemd so logs are available in journalctl. Name of the unit file must match the official doc : https://docs.celestia.org/nodes/systemd/ 
- celestia-appd needs to be configured to allow prometheus telemetry
- celestia node needs to be configured with metrics : `-metrics.tls=false --metrics --metrics.endpoint 127.0.0.1:4318`
- install docker - sudo/root privilege

```bash
# install docker / docker-compose
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER #you need to logout and login back after that
```

## Installing the stack

### Clone the repo

```bash
git clone https://github.com/P-OPSTeam/celestia-tools
cd celestia-tools/grafana
```

### Update start.sh

- update the admin/password of your grafana
- Next, If you wanna be alerted, you will need to create an account on pagerduty and get your integration key https://support.pagerduty.com/docs/services-and-integrations

> alertmanager will fail to start if the PD integration key is not filled up 


### Start the stack

```bash
bash start.sh
```

### Check the documentation

- [Grafana documentation](docs/grafana.md)

## TODO

- [ ] TBD


