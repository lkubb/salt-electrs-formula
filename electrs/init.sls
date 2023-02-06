# vim: ft=sls

{#-
    *Meta-state*.

    This installs the electrs package,
    [manages the electrs configuration file]
    and then starts the associated electrs service.
#}

include:
  - .package
  # - .config
  - .service
