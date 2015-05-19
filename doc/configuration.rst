.. _configuration:

*******************
Configuration
*******************

To set custom configurations on the oictest you need to bind a volume to **/opt/oictest/etc**. The content in the volume will overwrite the
default configuration. Because of this it is important to have a valid structure on the volume.

The easiest way to get started with custom configuration is to download the oictest docker project and look at
the example. The project can be found at: https://github.com/its-dirg/oictest_docker

Config volume structure
================

The volume need to have the following structure::

    config_server
        - {certificates: specified in config.py}
            - {crt: specified in config.py}
            - {key: specified in config.py}
        - config.py
        - start.sh
    keys
        - second_enc.key
        - second_sig.key
    rp
        - {certificates: specified in sslconf.py}
            - {crt: specified in sslconf.py}
            - {key: specified in sslconf.py}
        - sslconf.py

The start.sh script
-------------------

In the volume root, a file **config_server/start.sh** must exist. This file is the starting point of the application and is
responsible of starting the oictest server.

An example of a start script::

    #!/bin/bash

    python config_server.py config

This starts an oictest server with a config file **config.py**


Log files
=========

To get log files from the container you need to volume bind both **/opt/oictest/src/oictest/test/oic_op/rp/server_logs**
and **/opt/oictest/src/oictest/test/oic_op/rp/log**
