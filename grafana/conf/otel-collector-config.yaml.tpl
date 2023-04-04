receivers:
  otlp:
    protocols:
      grpc: 
      http:
  prometheus:
    config:
      scrape_configs:
      - job_name: 'otel-collector'
        scrape_interval: 10s
        static_configs:
        - targets: ['127.0.0.1:8888']
exporters:
  otlphttp:
    endpoint: http://otel.celestia.tools:4318
  prometheus:
    endpoint: "0.0.0.0:OTEL_PROMETHEUS_EXPORTER"
    namespace: celestia
    send_timestamps: true
    metric_expiration: 180m
    enable_open_metrics: true
    resource_to_telemetry_conversion:
      enabled: true
processors:
  batch:
  memory_limiter:
    # 80% of maximum memory up to 2G
    limit_mib: 1500
    # 25% of limit up to 2G
    spike_limit_mib: 512
    check_interval: 5s
service:
  pipelines:
    metrics:
      receivers: [otlp]
      exporters: [otlphttp, prometheus]