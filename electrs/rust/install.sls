# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as electrs with context %}
{%- set rustup_init = salt["temp.file"]() %}

Rustup-init is available:
  file.managed:
    - name: {{ rustup_init }}
    - source: {{ electrs.lookup.rustup_init.source }}
    - source_hash: {{ electrs.lookup.rustup_init.source_hash }}
    - unless:
      - sudo -iu '{{ electrs.lookup.user }}' command -v rustup
    - require:
      - Esplora-Electrs user/group are present

Rustup is installed for user '{{ electrs.lookup.user }}':
  cmd.script:
    - name: {{ rustup_init }}
    - args: -y
    - runas: {{ electrs.lookup.user }}
    - require:
      - Rustup-init is available
    - prereq:
      - Rustup-init is absent
    - onchanges:
      - Rustup-init is available

Rustup-init is absent:
  file.absent:
    - name: {{ rustup_init }}
