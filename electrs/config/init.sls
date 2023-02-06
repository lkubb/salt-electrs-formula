# vim: ft=sls

{#-
    Manages the electrs service configuration.
    This does not work for the Blockstream fork of ``electrs``.
    Has a dependency on `electrs.package`_.
#}

include:
  - .file
