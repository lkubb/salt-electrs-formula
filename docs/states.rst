Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``electrs``
^^^^^^^^^^^
*Meta-state*.

This installs the electrs package,
[manages the electrs configuration file]
and then starts the associated electrs service.


``electrs.package``
^^^^^^^^^^^^^^^^^^^
Installs the electrs package only.

Since ``electrs`` is built from source, needs
a functional Rust toolchain for the ``electrs`` user.
By default, includes `electrs.rust`_, but this can be
configured in ``rust_setup``.


``electrs.service``
^^^^^^^^^^^^^^^^^^^
Starts the electrs service and enables it at boot time.
[Has a dependency on `electrs.config`_.]


``electrs.config``
^^^^^^^^^^^^^^^^^^
Manages the electrs service configuration.
This does not work for the Blockstream fork of ``electrs``.
Has a dependency on `electrs.package`_.


``electrs.rust``
^^^^^^^^^^^^^^^^
Installs the Rust toolchain using ``rustup-init`` for the
``electrs`` user.

Included automatically if ``rust_setup`` is set to ``true``.


``electrs.clean``
^^^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``electrs`` meta-state
in reverse order, i.e.
stops the service,
[removes the configuration file and then]
uninstalls the package.


``electrs.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the electrs package.
Has a dependency on `electrs.rust.clean`_ if
``rust_setup`` is ``true``.


``electrs.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Stops the electrs service and disables it at boot time.


``electrs.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the electrs service and has a
dependency on `electrs.service.clean`_.

Does not work for the Blockstream fork of ``electrs``.


``electrs.rust.clean``
^^^^^^^^^^^^^^^^^^^^^^
Removes the Rust toolchain for the ``electrs`` user.


