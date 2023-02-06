# vim: ft=sls

{#-
    Removes the Rust toolchain for the ``electrs`` user.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as electrs with context %}
{%- set home = salt["user.info"](electrs.lookup.user).home %}

Rust toolchain is removed for user '{{ electrs.lookup.user }}':
  cmd.run:
    - name: rustup self uninstall -y
    - runas: {{ electrs.lookup.user }}
    - onlyif:
      - test -d '{{ home | path_join(".rustup") }}'
