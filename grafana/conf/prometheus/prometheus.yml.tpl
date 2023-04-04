global:
  scrape_interval: 10s
  scrape_timeout: 3s
  evaluation_interval: 5s

# Rules and alerts are read from the specified file(s)
rule_files:
  - rules/*.rules.yaml

# Alerting specifies settings related to the Alertmanager
alerting:
  alertmanagers:
    - static_configs:
      - targets:
        # Alertmanager's default port is 9093
        - alertmanager:9093

scrape_configs:
  - job_name: celestia-appd
    static_configs:
      - targets: ['PUBLIC_IP:26660', 'process-exporter:9256']

  - job_name: prometheus
    static_configs:
      - targets: ['localhost:9090','cadvisor:8080','node-exporter:9100']

  - job_name: otel-collector
    static_configs:
      - targets: ['otel-collector:8888']

  - job_name: celestia-da-node-metrics
    static_configs:
      - targets: ['otel-collector:OTEL_PROMETHEUS_EXPORTER']

