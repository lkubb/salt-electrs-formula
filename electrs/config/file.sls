# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as electrs with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

{#-
    The Blockstream fork does not use the configuration file. In case
    I adapt this formula for romanz/electrs, this is how it would be done.
-#}

Electrs configuration is managed:
  file.serialize:
    - name: {{ electrs.lookup.config | path_join("config.toml") }}
    - serializer: toml
    - mode: '0640'
    - user: root
    - group: {{ electrs.lookup.group }}
    - makedirs: true
    - require:
      - sls: {{ sls_package_install }}
    - context:
        electrs: {{ electrs | json }}
