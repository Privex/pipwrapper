[![PyPi Version](https://img.shields.io/pypi/v/pipwrapper.svg)](https://pypi.org/project/pipwrapper/)
![License Button](https://img.shields.io/pypi/l/pipwrapper) ![PyPI - Downloads](https://img.shields.io/pypi/dm/pipwrapper)
![PyPI - Python Version](https://img.shields.io/pypi/pyversions/pipwrapper) 
![GitHub last commit](https://img.shields.io/github/last-commit/Privex/pipwrapper)

# Python PIP Wrapper (for `pip` - the Python package manager which uses PyPi)

A small dependency-free and single file library for easily using `pip` within a Python app or script.

Includes the `auto_install` helper method, which detects which specified packages are missing, and auto-installs them.

The codebase is purposely restrained to the single file `pipwrapper.py` for these usecases:

- It makes it easy for developers to simply copy and paste the contents of the file 
  into **self-contained single file Python scripts** for automatic dependency installation prior to the 
  end user having any Python packages installed.
- For projects where multiple files/folders can be used, it allows the `pipwrapper.py` script to be downloaded and
  stored in any file/module in the project, without having to correct any references 

**Official Repo:** https://github.com/Privex/pipwrapper


## Minified Version

As this library is self-contained in a single file, and is free of external dependencies (other than the obvious Python and Pip),
it's possible to minify `pipwrapper.py` into a much smaller file / amount of characters/lines.

The minified version can either be copy pasted into an existing script, or saved to a `.py` file and imported from.

Please be aware: the minified version of the script uses TABS instead of SPACES, as one of the many space conserving
methods. You may need to convert the tabs into spaces for it to be compatible with your project.

Additionally - please make sure that our license notice is kept visible as a docstring on the `Pip` class, and/or
at the top of the file if you use it as an independent file. Our `./minify.sh` script automatically injects a small, 
basic license notice at the top of the file, and under the Pip class as a docstring after minification.

You can generate your own minified version of `pipwrapper.py` by running `./minify.sh` after setting up
a development environment ( `git clone; cd pipwrapper; pip3 install -r requirements.txt;`).

We also occasionally publish a minified file on [the Releases Page](https://github.com/Privex/pipwrapper),
which can either be copy pasted into an existing script, or saved to a `.py` file and imported from.

If something is wrong with our minification script that results in the license notice not being added, or you manually
trim `pipwrapper.py` down to an appropriate size for your project - please make sure to add our license notice as a 
docstring under `class Pip`, or at the top of the file. 

Here is our small and simple license notice for minified versions:

```py
"""
(C) Copyright 2021 - Privex Inc.   https://www.privex.io
PIPWrapper is released under the X11 / MIT License
Official Repo: https://github.com/Privex/pipwrapper
"""
```



## Quick Install / Usage

### Install from PyPi using pip

```sh
pip3 install -U pipwrapper
```

### Basic usage

```python
from pipwrapper import Pip, ProcResult

########
# It's not required to initialise an instance of Pip() - however, it's recommended, as it
# will allow you to make use of functionality that's not available on bare classes, such
# as dynamically generated command wrapper methods for methods that haven't yet been defined,
# using the '.__getattr__' instance method.
#
# If you only need the basics - i.e. 'install', 'uninstall', 'auto_install', 'call', and
# any of the other pre-defined classmethod's - then you should be able to call them directly
# via the class, e.g. Pip.auto_install('privex-helpers', 'Quart', 'dnspython')
#
pip = Pip()

########
# Automatically install any of these specified packages if they aren't already installed
res = pip.auto_install('privex-helpers', 'Django', 'requests', 'httpx')

if res.retcode != 0:
   print("Something went wrong while installing packages using auto_install.")
   print("Output from Pip was:")
   print("\n", res.stdout.decode(), "\n\n")
########
# Directly run 'pip install -U' for one or more packages
pip.install("psycopg2", "mysqlclient")

########
# Uninstall one or more packages
pip.uninstall("requests")

########
# Let's install 'requests' again, but this time, using 'output=True' to pipe pip's stdout/stderr
# directly to the console of this script, instead of capturing the output into a variable.
pip.install('requests', output=True)

########
# You can also call .freeze() to run 'pip freeze', which will capture the output, and will parse the lines of package==version
# into a standard Python list() for you to be able to process easily.
frz = pip.freeze()

print(frz)
# [
#     "asgiref==3.3.1", "async-property==0.2.1", "attrs==20.3.0",
#     "Django==3.1.7", "httpx==0.17.1",
#     "privex-helpers==3.2.1", "privex-loghelper==1.0.6",
#     "python-dateutil==2.8.1", "pytz==2021.1",
#     "requests==2.25.1", "sniffio==1.2.0",
#     "urllib3==1.26.4"
# ]

########
# Alternatively, instead of using .freeze(), you can use .installed_packages() (a wrapper around .freeze()) to generate a 
# list of plain package names that are currently installed :)
pkgs = pip.installed_pkgs()

print(pkgs)
# [
#     'asgiref', 'async-property', 'attrs', 'certifi', 'chardet', 'Django', 'h11', 
#     'httpcore', 'httpx', 'idna', 'privex-helpers', 'privex-loghelper', 'python-dateutil',
#     'pytz', 'requests', 'rfc3986', 'six', 'sniffio', 'sqlparse', 'urllib3'
# ]


########
# While only a handful of pip sub-commands have wrapper method available, you can call any arbitrary undefined attribute
# like a command method, then it will dynamically generate and return a function that will call the sub-command with that name,
# and it'll pass any positional arguments directly to the sub-command.
# 
# For example, as of v0.5.0 (27 Mar 2021), the '.show()' method does not exist on the Pip class, however, if you call .show()
# with the name of an installed package like below, it will dynamically generate a function that will run 'pip show ARGS...'
# and return a ProcResult just like the defined command wrapper methods :)
res_show: ProcResult = pip.show('privex-helpers')
print(res_show.stdout.decode())
# Name: privex-helpers
# Version: 3.2.1
# Summary: A variety of helper functions and classes, useful for many different projects
# Home-page: https://github.com/Privex/python-helpers
# Author: Chris (Someguy123) @ Privex
# License: MIT
# Location: /Library/Frameworks/Python.framework/Versions/3.9/lib/python3.9/site-packages
# Requires: python-dateutil, async-property, sniffio, privex-loghelper, attrs
# Required-by: privex-db

```

# Information

This Python PIP library has been developed at [Privex Inc.](https://www.privex.io) by @someguy123 to make it easy to work with
`pip` within a Python script - especially in self-contained single file scripts which need to be able to auto-install their
dependencies.

    
    +===================================================+
    |                 © 2021 Privex Inc.                |
    |               https://www.privex.io               |
    +===================================================+
    |                                                   |
    |     Python PIP Wrapper Library                    |
    |     License: X11/MIT                              |
    |     Repo: https://github.com/Privex/pipwrapper    |
    |                                                   |
    |     Core Developer(s):                            |
    |                                                   |
    |       (+)  Chris (@someguy123) [Privex]           |
    |                                                   |
    +===================================================+
    
    Python PIP Wrapper (PyPi Wrapper) - A simple, dependency-free library for using PIP via wrapping 
    the CLI utility (python3.x -m pip ARGS)
    Copyright (c) 2021    Privex Inc. ( https://www.privex.io )


# Install

We recommend that you use at least Python 3.6+ due to the usage of parameter and return type hinting.

### Install from PyPi using `pip`

You can install this package via pip:

```sh
pip3 install -U pipwrapper
```

### (Alternative) Manual install from Git

If you don't want to PyPi (e.g. for development versions not on PyPi yet), you can install the 
project directly from our Git repo.

Unless you have a specific reason to manually install it, you **should install it using pip3 normally**
as shown above.

**Option 1 - Use pip to install straight from Github**

```sh
pip3 install git+https://github.com/Privex/pipwrapper
```

**Option 2 - Clone and install manually**

```bash
# Clone the repository from Github
git clone https://github.com/Privex/pipwrapper.git
cd pipwrapper

# RECOMMENDED MANUAL INSTALL METHOD
# Use pip to install the source code
pip3 install .

# ALTERNATIVE INSTALL METHOD
# If you don't have pip, or have issues with installing using it, then you can use setuptools instead.
python3 setup.py install
```


# Contributing

We're very happy to accept pull requests, and work on any issues reported to us. 

Here's some important information:

**Reporting Issues:**

 - For bug reports, you should include the following information:
     - Version of `pipwrapper` - use `pip3 freeze`
        - If not installed via a PyPi release, git revision number that the issue was tested on - `git log -n1`
     - Your python3 version - `python3 -V`
     - Your operating system and OS version (e.g. Ubuntu 20.04, Debian 10)
 - For feature requests / changes
     - Please avoid suggestions that require third party dependencies. This tool is designed to be lightweight, not filled with
       external dependencies.
     - Clearly explain the feature/change that you would like to be added
     - Explain why the feature/change would be useful to us, or other users of the tool
     - Be aware that features/changes that are complicated to add, or we simply find un-necessary for our use of the tool 
       may not be added (but we may accept PRs)
    
**Pull Requests:**

 - We'll happily accept PRs that only add code comments or README changes
 - Use 4 spaces, not tabs when contributing to the code
 - You can use features from Python 3.4+ (we run Python 3.7+ for our projects)
    - Features that require a Python version that has not yet been released for the latest stable release
      of Ubuntu Server LTS (at this time, Ubuntu 18.04 Bionic) will not be accepted. 
 - Clearly explain the purpose of your pull request in the title and description
     - What changes have you made?
     - Why have you made these changes?
 - Please make sure that code contributions are appropriately commented - we won't accept changes that involve 
   uncommented, highly terse one-liners.

**Legal Disclaimer for Contributions**

Nobody wants to read a long document filled with legal text, so we've summed up the important parts here.

If you contribute content that you've created/own to projects that are created/owned by Privex, such as code or 
documentation, then you might automatically grant us unrestricted usage of your content, regardless of the open 
source license that applies to our project.

If you don't want to grant us unlimited usage of your content, you should make sure to place your content
in a separate file, making sure that the license of your content is clearly displayed at the start of the 
file (e.g. code comments), or inside of it's containing folder (e.g. a file named LICENSE). 

You should let us know in your pull request or issue that you've included files which are licensed
separately, so that we can make sure there's no license conflicts that might stop us being able
to accept your contribution.

If you'd rather read the whole legal text, it should be included as `privex_contribution_agreement.txt`.

# License

This project is licensed under the **X11 / MIT** license. See the file **LICENSE** for full details.

Here's the important bits:

 - You must include/display the license & copyright notice (`LICENSE`) if you modify/distribute/copy
   some or all of this project.
 - You can't use our name to promote / endorse your product without asking us for permission.
   You can however, state that your product uses some/all of this project.



# Thanks for reading!

**If this project has helped you, consider [grabbing a VPS or Dedicated Server from Privex](https://www.privex.io)** - 
**prices start at as little as US$0.99/mo (we take cryptocurrency!)**
