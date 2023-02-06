# vim: ft=sls

{#-
    Starts the electrs service and enables it at boot time.
    [Has a dependency on `electrs.config`_.]
#}

include:
  - .running
