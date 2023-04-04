#see here for a more detail config file :
# https://github.com/prometheus/alertmanager/blob/main/doc/examples/simple.yml
global:
  # The smarthost and SMTP sender used for mail notifications.
  smtp_smarthost: 'smtp.example.com:8825'
  smtp_from: 'no-reply@example.com'
  smtp_require_tls: false
# The root route on which each incoming alert enters.
route:
  # The labels by which incoming alerts are grouped together. For example,
  # multiple alerts coming in for cluster=A and alertname=LatencyHigh would
  # be batched into a single group.
  #
  # To aggregate by all possible labels use '...' as the sole label name.
  # This effectively disables aggregation entirely, passing through all
  # alerts as-is. This is unlikely to be what you want, unless you have
  # a very low alert volume or your upstream notification system performs
  # its own grouping. Example: group_by: [...]
  receiver: 'PagerDuty'
  group_by: [...]
  repeat_interval: 4h

  routes:
  - receiver: "PagerDuty"

receivers:
- name: 'PagerDuty'
  pagerduty_configs:
  - service_key: 'PD_SERVICE_KEY'