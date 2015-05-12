#!/bin/bash

repository="itsdirg/oictest"

# Check if running on mac
if [ $(uname) = "Darwin" ]; then

    #Get ip of dns
    dnsip=$(ipconfig getifaddr en0)

    # Check so the boot2docker vm is running
    if [ $(boot2docker status) != "running" ]; then
        boot2docker start
    fi
    $(boot2docker shellinit)
else
    # if running on linux
    if [ $(id -u) -ne 0 ]; then
        sudo="sudo"
    fi
fi
${sudo} docker rmi -f ${repository}
${sudo} docker build --no-cache -t=${repository} .
