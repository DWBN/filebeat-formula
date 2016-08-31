{% from "filebeat/map.jinja" import conf with context %}
filebeat.service:
  service.running:
    - name: filebeat
    - enable: true
    - restart: true
    - watch:
      - file: {{ conf.config_path }}
