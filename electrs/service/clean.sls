# vim: ft=sls

{#-
    Stops the electrs service and disables it at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as electrs with context %}

Electrs Esplora API Backend is dead:
  service.dead:
    - name: {{ electrs.lookup.service.name }}
    - enable: false
