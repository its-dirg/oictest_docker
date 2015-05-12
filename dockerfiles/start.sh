#!/bin/bash

ALL_FILES=$(ls -1 /opt/oictest/etc)

for file in ${ALL_FILES}
do
    ln -s /opt/oictest/etc/${file} /opt/oictest/src/oictest/${file}
done

./start.sh

