# vim: ft=sls

{#-
    Installs the Rust toolchain using ``rustup-init`` for the
    ``electrs`` user.

    Included automatically if ``rust_setup`` is set to ``true``.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as warden with context %}

include:
  - .install
