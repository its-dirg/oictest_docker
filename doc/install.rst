.. _install:

*******************
Quick install guide
*******************

Install Docker
==============

To install docker on your specific OS, follow the instruction on the docker page: http://docs.docker.com/installation/

Install oictest using docker
==============================

Default configuration
---------------------
Download and run the script found at: https://raw.githubusercontent.com/its-dirg/oictest_docker/master/example/run.sh

The script will download the oictest docker image from docker hub and start the oictest container.

Custom configuration
--------------------
If you want an example of how to use volume binding to set custom configuration, or want to build the docker image manually, download the docker project from: https://github.com/its-dirg/oictest_docker

All files necessary to build the oictest image are located in the **dockerfiles** directory. To build the image run the script::

    dockerfiles/build.sh

The volume binding example files are located in the **example** directory. To start oictest with the custom configurations, run the script::

    example/run.sh

For more information about the custom configuration see
:ref:`configuration`