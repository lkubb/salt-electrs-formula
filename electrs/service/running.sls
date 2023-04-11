# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{#- set sls_config_file = tplroot ~ ".config.file" #}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as electrs with context %}

include:
  - {{ sls_package_install }}
  # - {# sls_config_file #}

Electrs is running:
  service.running:
    - name: {{ electrs.lookup.service.name }}
    - enable: true
    - watch:
      - sls: {{ sls_package_install }}
      # - sls: {# sls_config_file #}
