.. _readme:

Electrs Esplora API Backend Formula
===================================

|img_sr| |img_pc|

.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release
.. |img_pc| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :alt: pre-commit
   :scale: 100%
   :target: https://github.com/pre-commit/pre-commit

Manage Electrs Esplora API Backend with Salt. This formula is (currently) targeted at the Blockstream fork that is necessary to run the Esplora Block Explorer.

This formula manages the backend. For the frontend, see `esplora-formula <https://github.com/lkubb/salt-esplora-formula>`_ (and `bitcoin-formula <https://github.com/lkubb/salt-bitcoin-formula>`_).

The interaction between the three components needs to be configured properly. The formulae do not influence each other. Please refer to the `official docs <https://github.com/Blockstream/electrs>`_ as well, although they are sparse.

Mind that the tests are currently not implemented.

.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please refer to:

- `how to configure the formula with map.jinja <map.jinja.rst>`_
- the ``pillar.example`` file
- the `Special notes`_ section

Special notes
-------------
* The Blockstream fork of ``electrs`` does not support configuration through means other than CLI parameters, while upstream does. There is a state, ``electrs.config.file``, which would work for upstream, for future reference.

Configuration
-------------
An example pillar is provided, please see `pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in `map.jinja`.


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



Contributing to this repo
-------------------------

Commit messages
^^^^^^^^^^^^^^^

**Commit message formatting is significant!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``. ::

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.

Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``electrs`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.
