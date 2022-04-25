# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{#%- set sls_config_file = tplroot ~ '.config.file' %#}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as electrs with context %}

include:
  - {{ sls_package_install }}
  # - {# sls_config_file #}

electrs-service-running-service-running:
  service.running:
    - name: {{ electrs.lookup.service.name }}
    - enable: True
    - watch:
      - sls: {{ sls_package_install }}
      # - sls: {# sls_config_file #}
