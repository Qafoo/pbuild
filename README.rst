======
pBuild 
======

.. contents:: Table of Contents
    :depth: 2

What's it all about
===================

**pBuild** is a utillity written in `bash`__-Script, which helps you to compile,
install and manage multiple `PHP`__-Versions from source.

__ http://www.gnu.org/software/bash/
__ http://php.net

In conjunction to the automation of compiling and download of arbitrary
PHP-Sources, **pBuild** furthermore allows to manage multiple installed
PHP-Versions on one system. Switching between versions is as easy, as building
different incarnations, like for the commandline, fcgi and the fpm interface.

Motivation
==========

**pBuild** has been created to satisfy the need for multiple PHP-Versions, with
different configurations on a development system. For testing compatibility as
well as playing around with the rc-releases or the current trunk.

Using default system packages was no solution, either to development on MacOs,
or different build-flags needed in contrast to the distributed packages.

Name and basic idea
===================

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
========================

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
    does nothing. All of those methods are documented in detail, with all
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
===========

The easiest way to understand how **pBuild** works is by following this step by
step guide to installing a PHP version:

Step 1: Installing **pBuild**
-----------------------------

To install **pBuild** simply checkout it's github repository::

    git clone https://github.com/Qafoo/pbuild

Either link the ``bin/pbuild`` file to a directory inside your ``PATH`` or
simply add ``bin/`` to your ``PATH`` variable.

If you are using BASH as your primary shell link
``Documentation/bash_completion/pbuild`` to your `bash_completion.d` directory.
Usually this is stored at ``/etc/bash_completion.d``.

Now you should be able to call ``pbuild`` as well as having TAB-completion for
it.

Step 2: Creating a simple ``.pbuild``-File
-------------------------------------------

For each PHP-Version you want to install/compile a ``.pbuild`` files needs to
be created. This file needs to contain all necessary configuration for your
custom php build. A ``.pbuild`` file consists of bash-functions, with defined
names, which represent different steps of the build process. Each function has
a reasonable default implementation. Therefore only specialized parts of
certain build need to be overwritten.

The following build step functions are executed in the given order:

- ``pkg_fetch``: Fetch the possibly compressed source of the configured
  version.
- ``pkg_unpack``: Unpack the fetched archive.
- ``src_prepare``: Prepare the unpacked source (Applying patches, Running
  autoconf, ...).
- ``src_configure``: Running the ``./configure`` step with appropriate flags
  and configuration in order to define how to build the defined version.
- ``src_compile``: Compile the configured source tree.
- ``src_install``: Take all steps necessary to install the compiled version
  into the system.
- ``src_post_install``: Execute further operations after php has been
  installed. This step may install additional packages using pear and/or pecl,
  for the just build version.
- ``php_enable``: Executed once the installed php version should be enabled
  (linked into the path)


Installing vs. Enabling
^^^^^^^^^^^^^^^^^^^^^^^

**pbuild** differentiates between the *install* action of a build php version
and an *enable* action. **pbuild** installs each compiled php version initially
to an internal directory, which lives inside the ``Library`` folder. Utilizing
this technique multiple php version can easily be installed in parallel.
**pbuild** takes care of managing all the installed versions, directories and
downloaded packages.

Once the tool is ordered to ``enable`` a certain version it links all necessary
parts of the corresponding php installation into the ``PATH`` of your system.
After *enabling* a call to ``php`` from your commandline for example will
execute the correct version.

.. note:: The target path for the ``enable`` action may of course be
    configured. See `Overwriting Default Configuration`_ for details.

``./configure`` your PHP
^^^^^^^^^^^^^^^^^^^^^^^^

A custom build php-version often needs certain specialized configure flags.
Those are usually provided during a call to the autotools ``./configure``
script. In order to provide customized configure-flags to the php version build
by **pbuild**, the ``src_configure`` is overridden, to provide user based flags
to the ``pconfigure`` macro.

``pconfigure`` may be used exactly like the usual ``./configure``. Internally
however this function adds certain configure flags related to the currently
build incarnation (cli, fcgi, fpm, ...), as well as certain paths, like config
path, install path and so on. Furthermore ``pconfigure`` knows about the
directory structure used by **pbuild**. Therefore it is capable of correctly
switching directories and executing everything in the right place without
further user interaction.

A simple ``.pbuild`` example
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following ``.pbuild`` is stored as ``Library/pbuilds/php-5.4.16``. It
creates a mostly default php build of the according version::

    ##
    # Configure the php version before the compile phase
    #
    # The directory containing the possible patched source tree from the
    # 'src_prepare' phase is accessible using ${S} as well as ${D}.
    #
    # Instead of calling configure directly the 'pconfigure' function needs to be
    # used, as the configure call is slightly modified to contain the correct
    # install prefix, as well as configuration directories and buildtype
    # configuration (cgi, cli, …)
    ##
    src_configure() {
        cd "${S}/${PB}"
        
        pconfigure \
            --disable-debug \
            --enable-pcntl \
            --enable-mbstring \
            --enable-bcmath \
            --with-openssl \
            --with-zlib=/usr \
            --with-bz2=/usr \
    }

Step 3: Letting **pBuild** work its magic
-----------------------------------------

After a ``.pbuild`` has been defined actions can be called upon it, using the
``pbuild`` executable::

    $ pbuild install php-5.4.16

If no action is specified ``enable`` is chosen as default. Calling ``pbuild``
with the ``-h`` option provides a detailed description of how the utillity can
be used::

    pbuild 1.0 (c) Jakob Westhoff
    Usage: pbuild [-h][-v] [<action>] [<pbuild-template>]

    The following actions are available:

    list:      Show a list of php version for which pbuilds exist
    download:  Download the needed archive for the given pbuild
    compile:   Compile the given pbuild and store it's build result inside the
               packages directory
    install:   Install the given pbuild to the specified php directory
    enable:    Enable the given pbuild to be available to the system
    disable:   Disable the given pbuild again, removing all linked entries inside
               the system
    clean:     Remove all previously created data for this pbuild (archive,
               build, install, link)

    Default: enable
    If no action is specified the enable action is automatically assumed.

    Most of those actions depend on each other and are therefore executed in
    a given order. (e.g. the enable action will automatically trigger download,
    compile and install as a prerequisite if necessary.) The pbuild system is
    capable of determining if certain steps need to be executed again or if all
    relevant information are available from a previous run.

    pbuild-templates can either be addressed by their canonical path or simply
    by there name. A quite inteligent lookup system will try to find the one you
    have been looking for.

    If neither an action nor a pbuild-template is specified a list of all
    available pbuilds from the pbuild directory is printed.

The tool automatically determines which steps/dependencies need to be
fullfilled in order to acomplish the selected action.

For example if a ``.pbuild`` has never been build before and is supposed to be
``enabled`` the following actions will be automatically executed in the correct
order:

1. ``download``
2. ``compile``
3. ``install``
4. ``enable``

No worries **pbuild** will tell you exactly what is going to happen before
actually doing anything::

    pbuild 1.0 (c) Jakob Westhoff
    [>] Using pbuild '/Users/jakob/devel/shell/pbuild/Library/pbuilds/php-5.4.16.pbuild'.
    [>] The following build steps will be executed in order: download compile install enable
    [>] The following incarnations will be build: cli fpm.
    [?] Should I commence the operation? [Y/n]

Once you acknowledge the operation the magic starts to happen. In the example
above **pbuild** will automatically download, configure, compile, install and
link the defined php version into your system. It will be build in a variety of
different incarnations. In this example a CLI as well as an FPM version will be
build. You can learn more about the build incarnation capabilities in the
chapter `Build Incarnations`_

By default all necessary executables and files will be linked to
``/usr/local``. For information about changeing this path prefix see the
section `Overwriting Default Configuration`.

After the **pbuild** has completed its work you should be able to simply
execute ``php``, ``pear``, ``pecl`` and everything else related to your build
php version. Of course this only works if ``/usr/local`` is in your current
``PATH``.

Step 4: Changing the ``php.ini`` of a certain Version
------------------------------------------------------

After having installed a pbp version using ``pbuild`` you most likely want to
supply it with a specialized ``php.ini``. Something like for example a valid
timezone should always be configured.

**pbuild**  automatically configures your build php version with a custome
``php.ini`` directory. Using this technique each version as well as each build
incarnation can be given its own dedicated configuration.

The ``php.ini`` configurations will be stored in ``/usr/local/php/etc``. The
path is followed by the build php version postfixed with the incarnation it
belongs to. With regards to the example above the following two ``php.ini``
would be available to configure the installed php version:

- ``/usr/local/etc/php/php-5.4.16_cli/php.ini``
- ``/usr/local/etc/php/php-5.4.16_fpm/php.ini``

Upon the first installed the distributed example configuration will
automatically be stored there. Once you made your changes reinstalling an
already configured php version will just utilize the ``php.ini`` already there.

For selecting another configuration directory base path see `Overwriting
Default Configuration`_


Switching between different PHP-Versions
========================================

Once you have compiled and installed multiple php versions you may easily
switch between those versions, by simply calling ``pbuild <desired php
version``. (alternatively: ``pbuild enable <desired php version>``). **pbuild**
will automatically detect that you already build and installed the selected
version and simply switch over all symlinks in your path to the desired
executables.

Therefore having multiple versions, or even differently configured builds of the
same version on your system, as well as switching between them is easy as pie.

Same version, different Configuration
-------------------------------------

To build multiple configurations of the same php version, you may simply attach
a buildname to the pbuild filename:
``php-5.4.16-some_arbitrary_build_name.pbuild``


Build Incarnations
==================

PHP comes in different flavors, as it may be used in different environments.
Every php version may be build for different use cases supporting different
connectivity features. Some of those may be combined in one executable. For
most of them this is however not possible. **pbuild** calls this different
builds *incarnations*.

Currently **pbuild** knows about the following incarnations:

- ``cli``
- ``fpm``
- ``fcgi``
- ``apxs``
- ``apxs2``

One or more of those incarnations may be selected to be build. **pbuild** will
automatically inject the correct configuration flags into its call to
``./configure`` in order to build the appropriate incarnations. As described in
the chapter `Step 4: Changing the php.ini of a certain Version`_ each
incarnation has it's own ``php.ini`` folder, which allows very specific
configuration of the installed environment. Unfortunately this means, that the
compile step is repeated once for every build incarnation.

By default the incarnations ``cli`` as well as ``fpm`` will be build, as those
the most commonly used environments these days. Of course it is possible to
overwrite this configuration. It is possible to either configure this setting
on a call by call basis to ``pbuild`` by simply prepending the
``BUILD_INCARNATIONS`` variable, followed by a space separated list of
incarnations to build, or in a more persistent manner using a static
configuration file. See ``Overwriting Default Configuration`` for details about
the second way.

An example for a dynamic selection of incarnations during a call to ``pbuild``
looks something like this::

    BUILD_INCARNATIONS="fcgi cli apxs2" pbbuild enable php-5.4.16-my_build_name

The exampe above would build the ``.pbuild`` file
``php-5.4.16-my_build_name.pbuild`` to be used with *fcgi*, *apache2* as well
as on the commandline (*cli*). Furthermore after building the version will
directly be enabled by linking the appropriate files.


More sophisticated `.pbuild` files
==================================

As described before ``.pbuild`` are a quite sophisticated way of configuring
a build. Those of you who have used Gentoo linux at some time should already be
familiar with the basic concept of this ebuild inspired system. The possibility
to overwrite each step of the build process, allows to create even the most
complex processing templates.

The ``Documentation`` folder houses detailed examples of all build steps, which
may be overwritten. Inside each function certain special variables, like
``${S}`` and ``${D}`` are available. The meaning and usage of those
variables is documented in each docblock of each of the build step functions.

- ``PBUILD``: full build path
- ``PB``: name of the pbuild (without extension and path)
- ``PN``: name of the "product" (usually php)
- ``PV``: version string of the pbuild
- ``PP``: product name plus version string (without the buildname)
- ``PE``: extra buildname of the pbuild (everything that comes after a minus
  behind the version string)

Convinience Functions
---------------------

In order to automatically handle often used tasks within those different build
steps a lot of convinience functions are available. Those functions are always
prefixed with the lower case letter ``p``. In most situations they are named
after their shell counterpart, like ``ppear``, ``pphp``, ``pconfigure``,
``pmkdir`` and ``pmake``. As those functions take into account the special
nature of the build environment the steps are executed in, they can easy your
life tremendously. Everytime an operation may be executed either manually, or
using those convinience functions, the convinience functions should be used, as
they might incorparate a certain amount of magic regarding the build process.

There are functions, which MUST be used instead of their counterparts, as their
special handling is essential to the build process. Those functions currently are:

- ``pconfigure``
- ``pmake``

A detailed documentation of all of those functions can be found in the
``Documents/Functions`` folder in form of generated API documentation.


Including other templates
-------------------------

If you want to *inherit* from other templates utilize the ``pinclude``
function. It will try to locate the selected ``.pbuild`` file exactly the same
way the ``pbuild`` executable does. A call to ``pinclude`` needs to be the
first call inside your template. It is issued outside of any other function.
After including another ``.pbuild`` as a basis you may overwrite all the
relevant parts of it as already described.

.. note:: A call to a *parent* implementation from within an overwritten
    function is currently not possible. If enough people have a use case for
    this I might implement a feature like this in the future.

A structural example of using ``pinclude`` does look like this::

    pinclude "some/folder/below/pbuilds/some_template.pbuild"

    src_configure() {
        ...
    }

    ...

Overwriting Default Configuration
=================================

**pbuild** assumes a lot of different configuration settings. Eventhough these
are mostly sane settings, there are a lot of environments and situations in
which you might want to override those settings.

The following settings may be overriden:

- ``PBUILD_DIR``: Directory containing the ``.pbuild`` files. (**Default**: ``Library/pbuilds``)
- ``PACKAGE_DIR``: Directory to store downloaded packages. (**Default**: ``Library/packages``)
- ``BUILD_DIR``: Directory used to utilize as temporary build folder for each
  php version. (**Default**: ``Library/build``)
- ``PHP_DIR``: Directory containing build and installed php versions, before
  they are activated. (**Default**: ``Library/php``)
- ``PHP_CONFIG_DIR``: Prefix for all stored ``php.ini`` config files.
  (**Default**: ``/usr/local/etc/php``)
- ``PHP_INSTALL_PREFIX``: Prefix used to link enabled php versions to.
  (**Default**: ``/usr/local``)
- ``BUILD_INCARNATIONS``: Incarnations to build by default. (**Default**: ``cli fpm``)

All of those options (mind the all uppercase names) may be overwritten on
a global, as well as a user level.

Globally an ``/etc/pbuild`` file may be created, which simply contains one or
more of the before mentioned options followed by an equalsign and the desired
value::

    # Comment lines may be created starting with a hash sign
    # Empty lines and stuff are of cause valid as well
    PBUILD_DIR="/some/other/absolute/path/to/a/build/directory"
    
    # Expansion of environment variables may be utilized using a dollar and
    # curly braces
    PHP_INSTALL_PREFIX="${HOME}/php"

    # Multiple build incarnations are specified using a space separated list
    BUILD_INCARNATIONS="fpm fcgi apxs2 cli"
    
    ...

If the configuration should not be global, but specific to the current user,
just store the file inside the corresponding homedir as ``.pbuildrc``. If both
files exist, both configurations will be automatically merged. The user
configuration has a higher priority then the global configuration and is
therefore capable of overwriting each of the global settings again.

Call-by-Call Configuration
--------------------------

A small subset of the available configuration options may be overwritten
dynamically during the calltime of the ``pbuild`` executable:

- ``BUILD_INCARNATIONS``
- ``PHP_INSTALL_PREFIX``
- ``PHP_CONFIG_DIR``

Those config options can be set as an evironment variable before or during
execution::

    BUILD_INCARNATIONS="fgi cli"
    pbuild install php-5.4.16

Alternative (one call)::

    BUILD_INCARNATIONS="fgi cli" pbuild install php-5.4.16

.. note:: This environment variables overwrite the global as well as the user
    configuration
