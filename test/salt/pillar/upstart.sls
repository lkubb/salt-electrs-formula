# vim: ft=yaml
---
electrs:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    config: '/etc/electrs/config.toml'
    group: electrs
    paths:
      bin: /opt/electrs
      build: /opt/electrs/src
      data: /var/lib/electrs
    pkg:
      source: https://github.com/Blockstream/electrs.git
    requirements:
      base:
        - build-essential
        - clang
        - cmake
        - git
    rustup_init:
      source: https://sh.rustup.rs
      source_hash: a3cb081f88a6789d104518b30d4aa410009cd08c3822a1226991d6cf0442a0f8
    service:
      name: electrs
      unit: /etc/systemd/system/{name}.service
    user: electrs
    user_extra_groups: []
  config:
    address_search: true
    daemon_dir: /var/lib/bitcoind
    daemon_rpc_addr: 127.0.0.1:8332
    jsonrpc_import: false
    network: mainnet
  features:
    - rocksdb
  rust_setup: true
  service:
    requires_mount: []
    wants: []
  version: latest

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://electrs/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   electrs-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      electrs-config-file-file-managed:
        - 'example.tmpl.jinja'

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
