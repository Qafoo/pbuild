pBuild 
======

What's it all about
-------------------

**pBuild** is a utillity written in `bash`__-Script, which helps you to compile,
install and manage multiple `PHP`__-Versions from source.

__ http://www.gnu.org/software/bash/
__ http://php.net

In conjunction to the automation of compiling and download of arbitrary
PHP-Sources, **pBuild** furthermore allows to manage multiple installed
PHP-Versions on one system. Switching between versions is as easy, as building
different incarnations, like for the commandline, fcgi and the fpm interface.

Motivation
----------

**pBuild** has been created to satisfy the need for multiple PHP-Versions, with
different configurations on a development system. For testing compatibility as
well as playing around with the rc-releases or the current trunk.

Using default system packages was no solution, either to development on MacOs,
or different build-flags needed in contrast to the distributed packages.

Name and basic idea
-------------------

The name **pBuild** is based on `Gentoo`__'s Portage package manager, which
uses so called *ebuilds* to manage the compilation and installation of software
from source.

__ http://www.gentoo.org/

**pBuild** does not only have it's name in common with *ebuilds*, but the basic
idea as well. Each PHP-Version to be installed provides a `.pbuild` file, which
defines certain specialized shell functions, for different steps of the build,
like *download*, *unpack*, *configure*, *compile*, *install*, ….

A basic template for all of those steps exists, which is sufficient for most of
your default needs. The only step which most likely needs an overwrite for your
use case is the *configure* step, which configures with which features PHP
should be build.

Directory/File-Structure
------------------------

**pBuild** uses a predefined file and directory structure, with looks like
this::

    .
    ├── Documentation
    │   ├── bash_completion
    │   └── examples
    ├── Library
    │   ├── build
    │   ├── packages
    │   ├── pbuilds
    │   └── php
    ├── bin
    ├── share
    └── vendor

Documentation:
    The *documentation* folder contains different documentation related
    ressources.

Documentation/bash_completion:
    A bash completion script to be used in order to allow for TAB-completion
    when using ``pbuild`` on the commandline

Documentation/examples:
    An empty `.pbuild` file with all posible build-step functions, which simply
    do nothing. All of those methods are documented in detail, with all
    available variables and informations under which conditions the
    corresponding function will be called.

Library:
    The *Library* folder contains everything related to available and installed
    PHP-Versions. This does include ``.pbuild`` files for building certain
    versions, corresponding downloaded archives, unpacked build trees, as well
    as installed PHP-Versions

bin:
    The ``pbuild`` binary, which is called to download, compile, install or
    manage PHP-Versions

share:
    Different application relevant shared files, like modules and functions
    used by the **pBuild** application

vendor:
    Certain third-party scripts used by **pBuild**

First steps
-----------

The easiest way to understand how **pBuild** works is by following this step by
step guide to installing a PHP version:

Step 1: Installing **pBuild**
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To install **pBuild** simply checkout it's github repository::

    git clone @TODO: INSERT URL

Either link the ``bin/pbuild`` file to a directory inside your ``PATH`` or
simply add ``bin/`` to your ``PATH`` variable.

If you are using BASH as your primary shell link
``Documentation/bash_completion/pbuild`` to your `bash_completion.d` directory.
Usually this is stored at ``/etc/bash_completion.d``.

Now you should be able to call ``pbuild`` as well as having TAB-completion for
it.

Step 2: Creating a simple ``.pbuild``-File
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Step 3: Letting **pBuild** work its magic
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Step 4: Changing the ``php.ini`` of a certain Version
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Switching between different PHP-Versions
----------------------------------------

More sophisticated `.pbuild` files
----------------------------------
