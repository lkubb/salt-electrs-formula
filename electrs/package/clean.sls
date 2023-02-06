# vim: ft=sls

{#-
    Removes the electrs package.
    Has a depency on `electrs.rust.clean`_ if
    ``rust_setup`` is ``true``.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_rust_clean = tplroot ~ ".rust.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as electrs with context %}

{%- if electrs.rust_setup is sameas true %}

include:
  - {{ sls_rust_clean }}
{%- endif %}

# This does not clean the data dir.
Esplora-Electrs is absent:
  file.absent:
    - names:
      - {{ electrs.lookup.service.unit.format(name=electrs.lookup.service.name) }}
      - {{ electrs.lookup.paths.bin | path_join("electrs") }}
      - {{ electrs.lookup.paths.build }}
{%- if electrs.rust_setup is sameas true %}
    - require:
      - sls: {{ sls_rust_clean }}
{%- endif %}

Esplora-Electrs user/group are absent:
  user.absent:
    - name: {{ electrs.lookup.user }}
    - require:
      - Esplora-Electrs is absent
  group.absent:
    - name: {{ electrs.lookup.group }}
    - require:
      - Esplora-Electrs is absent
