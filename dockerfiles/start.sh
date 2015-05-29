#!/bin/bash

volumePath=/opt/oictest/etc/

# if volume is empty, use the example files
if ! [ "$(ls -A ${volumePath})" ]; then
    echo "Using example files"
    volumePath=/opt/oictest/example/
else
    echo "Using volume files"
fi

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

copyFiles() {

    ALL_FILES=$(ls -1 ${volumePath}${1})

    for file in ${ALL_FILES}
    do
        if [ ${2} ]; then
            rm -fr /opt/oictest/src/oictest/test/oic_op/${1}/${file} > /dev/null 2> /dev/null
        fi
        cp -fr ${volumePath}${1}/${file} /opt/oictest/src/oictest/test/oic_op/${1}/${file}
    done

}

overWriteHOST() {

    filePath=${volumePath}${1}
    lineNumber=$(grep -in "^HOST[ =]" ${filePath} | awk -F: '{print $1}')
    string="${lineNumber}s/.*/HOST=\"${2}\"/"
    sed -i ${string} ${filePath}
}

if [ $HOST_IP ]; then
    overWriteHOST config_server/config.py $HOST_IP
fi

linkFiles config_server 0
linkFiles keys 1
linkFiles rp 0

if [ ! -d "/opt/oictest/src/oictest/test/oic_op/rp/server_log" ]; then
    mkdir /opt/oictest/src/oictest/test/oic_op/rp/server_log
fi


cd /opt/oictest/src/oictest/test/oic_op/config_server/
./start.sh

