# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as electrs with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- set sls_require_rust = "" %}

{%- if electrs.rust_setup %}
include:
{%-   if electrs.rust_setup is boolean %}
{%-     set sls_require_rust = tplroot ~ ".rust.install" %}
{%-   else %}
{%-     set sls_require_rust = electrs.rust_setup %}
{%-   endif %}
  - {{ sls_require_rust }}
{%- endif %}

Esplora-Electrs user/group are present:
  user.present:
    - name: {{ electrs.lookup.user }}
    - fullname: Electrs Esplora API Server
    - createhome: true
    - system: true
    - usergroup: {{ electrs.lookup.group == electrs.lookup.user }}
{%- if electrs.lookup.group != electrs.lookup.user %}
    - gid: {{ electrs.lookup.group }}
    - require:
      - group: {{ electrs.lookup.group }}
  group.present:
    - name: {{ electrs.lookup.group }}
    - system: true
{%- endif %}

Esplora-Electrs paths are setup:
  file.directory:
    - names:
      - {{ electrs.lookup.paths.bin }}:
        - user: root
      - {{ electrs.lookup.paths.build }}
      - {{ electrs.lookup.paths.data }}:
        - unless:
          # Check if path is somewhere on network share, might not be able to ensure ownership.
          # @TODO proper check/config
          - >-
              test -d '{{ electrs.lookup.paths.data }}' &&
              df -P '{{ electrs.lookup.paths.data }}' |
              awk 'BEGIN {e=1} $NF ~ /^\/.+/ { e=0 ; print $1 ; exit } END { exit e }'
    - user: {{ electrs.lookup.user }}
    - group: {{ electrs.lookup.group }}
    - mode: '0755'
    - makedirs: true
    - require:
      - Esplora-Electrs user/group are present

Requirements for compiling Esplora-Electrs are installed:
  pkg.installed:
    - pkgs: {{ electrs._deps }}
{%- if sls_require_rust %}
    - require:
      - sls: {{ sls_require_rust }}
{%- endif %}

Esplora-Electrs repository is up to date:
  git.latest:
    - name: {{ electrs.lookup.pkg.source }}
    - target: {{ electrs.lookup.paths.build }}
    - rev: {{ "HEAD" if "latest" == electrs.version else electrs.version }}
    - force_reset: true
    - user: {{ electrs.lookup.user }}
    - require:
      - Esplora-Electrs paths are setup

Esplora-Electrs is compiled from source:
  cmd.run:
    - name: cargo build --locked --release --no-default-features --features {{ electrs.features | join(',') }}
    - cwd: {{ electrs.lookup.paths.build }}
    - runas: {{ electrs.lookup.user }}
    - require:
      - Requirements for compiling Esplora-Electrs are installed
    - onchanges:
      - Esplora-Electrs repository is up to date

Esplora-Electrs binary is installed:
  file.copy:
    - name: {{ electrs.lookup.paths.bin | path_join("electrs") }}
    - source: {{ electrs.lookup.paths.build | path_join("target", "release", "electrs") }}
    - user: root
    - group: {{ electrs.lookup.group }}
    - onchanges:
      - Esplora-Electrs is compiled from source

Esplora-Electrs service unit is installed:
  file.managed:
    - name: {{ electrs.lookup.service.unit.format(name=electrs.lookup.service.name) }}
    - source: {{ files_switch(
                    ["electrs.service", "electrs.service.j2"],
                    lookup="Esplora-Electrs service unit is installed",
                  ) }}
    - template: jinja
    - mode: '0644'
    - user: root
    - group: {{ electrs.lookup.rootgroup }}
    - makedirs: true
    - context: {{ {"electrs": electrs} | json }}
    - require:
      - Esplora-Electrs binary is installed
{%- if "systemctl" | which %}
  # this executes systemctl daemon-reload
  module.run:
    - service.systemctl_reload: []
    - onchanges:
      - file: {{ electrs.lookup.service.unit.format(name=electrs.lookup.service.name) }}
{%- endif %}
