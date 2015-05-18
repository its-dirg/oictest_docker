.. _configuration:

*******************
Configuration
*******************

To set custom configurations on the oictest you need to bind a volume. The content in the volume will overwrite the
default configuration. Because of this it is important to have a valid structure on the volume.

The easiest way to get started with custom configuration is to download the oictest docker project and look at
the example. The project can be found at: https://github.com/its-dirg/oictest_docker

Volume structure
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

The script **config_server/start.sh** is responsible of starting the **config_server.py** server.

Volume path
===========

The volume need to be bound to **/opt/oictest/etc**
