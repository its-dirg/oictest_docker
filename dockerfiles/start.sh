#!/bin/bash

volumePath=/opt/oictest/etc/

linkFiles() {

    ALL_FILES=$(ls -1 ${volumePath}${1})

    for file in ${ALL_FILES}
    do
        if [ ${2} ]; then
            rm -fr /opt/oictest/src/oictest/test/oic_op/${1}/${file} > /dev/null 2> /dev/null
        fi
        ln -s ${volumePath}${1}/${file} /opt/oictest/src/oictest/test/oic_op/${1}/${file}
    done

}

linkFiles config_server 0
linkFiles keys 1
linkFiles rp 0

cd /opt/oictest/src/oictest/test/oic_op/config_server/
./start.sh

