# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as electrs with context %}

electrs-service-clean-service-dead:
  service.dead:
    - name: {{ electrs.lookup.service.name }}
    - enable: False
