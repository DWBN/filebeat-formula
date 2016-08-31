
filebeat.service:
  service.running:
    - name: filebeat
    - enable: true
    - restart: true
    - watch:
      - pkg: filebeat
