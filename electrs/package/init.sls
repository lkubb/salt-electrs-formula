# vim: ft=sls

{#-
    Installs the electrs package only.

    Since ``electrs`` is built from source, needs
    a functional Rust toolchain for the ``electrs`` user.
    By default, includes `electrs.rust`_, but this can be
    configured in ``rust_setup``.
#}

include:
  - .install
