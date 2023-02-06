# vim: ft=sls

{#-
    Removes the configuration of the electrs service and has a
    dependency on `electrs.service.clean`_.

    Does not work for the Blockstream fork of ``electrs``.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as electrs with context %}

include:
  - {{ sls_service_clean }}

Electrs Esplora API Backend configuration is absent:
  file.absent:
    - name: {{ electrs.lookup.config }}
    - require:
      - sls: {{ sls_service_clean }}
