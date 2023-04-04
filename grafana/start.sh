#! /bin/bash

#### Fill up all the variable below
PD_INTEGRATION_KEY="<ur_pd_integration_key>"
ADMIN_USER="admin" #change if you want
ADMIN_PASSWORD="useyourownpassword"

# port with celestia DA node metrics exposed by otel
OTEL_PROMETHEUS_EXPORTER=8889
OTEL_GRPC_PORT=4317
OTEL_HTTP_PORT=4318

#### no more variable to change/set

cp conf/prometheus/prometheus.yml.tpl conf/prometheus/prometheus.yml
sed -i "s/PUBLIC_IP/$(curl -s ifconfig.me)/g" conf/prometheus/prometheus.yml
sed -i "s/OTEL_PROMETHEUS_EXPORTER/${OTEL_PROMETHEUS_EXPORTER}/g" conf/prometheus/prometheus.yml

cp conf/alertmanager.yaml.tpl conf/alertmanager.yaml
sed -i "s/PD_SERVICE_KEY/${PD_INTEGRATION_KEY}/g" conf/alertmanager.yaml

cp conf/otel-collector-config.yaml.tpl conf/otel-collector-config.yaml
sed -i "s/OTEL_PROMETHEUS_EXPORTER/${OTEL_PROMETHEUS_EXPORTER}/g" conf/otel-collector-config.yaml

OTEL_GRPC_PORT=${OTEL_GRPC_PORT} \
OTEL_HTTP_PORT=${OTEL_HTTP_PORT} \
USERID=$(id -u $USER) \
USERGP=$(id -g $USER) \
ADMIN_USER=${ADMIN_USER} \
ADMIN_PASSWORD=${ADMIN_PASSWORD} \
GF_USERS_ALLOW_SIGN_UP=false \
PROMETHEUS_CONFIG="./data/prometheus.yml" \
GRAFANA_CONFIG="./data/grafana.ini" \
OTEL_PROMETHEUS_EXPORTER=${OTEL_PROMETHEUS_EXPORTER} \
docker-compose up -d --remove-orphans --build "$@"

sudo chown -R $USER:$USER data