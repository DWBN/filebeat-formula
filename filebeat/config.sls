{% from "filebeat/map.jinja" import conf with context %}

{% if salt['pillar.get']('filebeat:logstash:tls:enabled', False)  %}
{{ salt['pillar.get']('filebeat:logstash:tls:ssl_cert_path', '/etc/pki/tls/certs/logstash-forwarder.crt') }}:
  file.managed:
    - source: {{ salt['pillar.get']('filebeat:logstash:tls:ssl_cert', 'salt://filebeat/files/ca.pem') }}
    - template: jinja
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - filebeat.config
{% endif %}

filebeat.config:
  file.managed:
    - name: {{ conf.config_path }}
    - source: {{ conf.config_source }}
    - template: jinja
    - user: root
    - group: root
    - mode: 644

{% if conf.runlevels_install %}
filebeat.runlevels_install:
  cmd.run:
    - name: update-rc.d filebeat defaults 95 10
    - onchanges:
      - file: {{ conf.config_path }}

filebeats.systemdreload:
  cmd.run:
    - name: systemctl daemon-reload
    - onlyif:
      - test -f /bin/systemctl
    - onchanges:
      - file: {{ conf.config_path }}

filebeat:
  service.running:
    - enable: true
    - watch:
      - file: {{ conf.config_path }}

{% endif %}
