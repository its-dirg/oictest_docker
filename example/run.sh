#!/bin/bash
#
# To debug your container:
#
#   DOCKERARGS="--entrypoint /bin/bash" bash -x ./run.sh
#

# Name of config file
conf=config_server/config.py

# Image name
image=itsdirg/oictest

# Name of container
name=oictest

# relative path to volume
volume=etc


c_path=$(pwd)
cddir=$(dirname `which $0`)
cd $cddir

dir=$(pwd)

docker_ports=""

checkPort() {

    for (( p=${1}; p<=${2}; p++))
    do
        port_check=$(netstat -an | grep ${p} | wc -l)
        port_b2d=$(VBoxManage showvminfo "boot2docker-vm" --details | grep ${p} | wc -l)

        if [ ${port_b2d} = 1 ]; then
            echo "Port: " ${p} " is already used by virtual box! Change port in the file " ${conf}
            exit 1
        fi

        if [ ${port_check} = 1 ]; then
            echo "Port: " ${p} " is already used! Change port in the file " ${conf}
            exit 1
        fi
    done

}

openPort() {
    for (( p=${1}; p<=${2}; p++))
    do
        VBoxManage controlvm "boot2docker-vm" natpf1 "${name}_${3}_${p},tcp,127.0.0.1,${p},,${p}"
        docker_ports="${docker_ports} -p ${p}:${p}"
    done

}

closePort() {

    for (( p=${1}; p<=${2}; p++))
    do
        VBoxManage controlvm "boot2docker-vm" natpf1 delete "${name}_${3}_${p}"
    done

}


HOST_PORT=$(cat ${volume}/${conf} | grep PORT | head -1 | sed 's/[^0-9]//g')

DYN_PORT_RANGE_MIN=$(cat ${volume}/${conf} | grep DYNAMIC_CLIENT_REGISTRATION_PORT_RANGE_MIN | grep -v "#" | head -1 | sed 's/[^0-9]//g')
DYN_PORT_RANGE_MAX=$(cat ${volume}/${conf} | grep DYNAMIC_CLIENT_REGISTRATION_PORT_RANGE_MAX | grep -v "#" | head -1 | sed 's/[^0-9]//g')
STATIC_PORT_RANGE_MIN=$(cat ${volume}/${conf} | grep STATIC_CLIENT_REGISTRATION_PORT_RANGE_MIN | grep -v "#" | head -1 | sed 's/[^0-9]//g')
STATIC_PORT_RANGE_MAX=$(cat ${volume}/${conf} | grep STATIC_CLIENT_REGISTRATION_PORT_RANGE_MAX | grep -v "#" | head -1 | sed 's/[^0-9]//g')

if ! [ $HOST_PORT ]; then
    HOST_PORT=8000
    DYN_PORT_RANGE_MIN=8001
    DYN_PORT_RANGE_MAX=8010
    STATIC_PORT_RANGE_MIN=8501
    STATIC_PORT_RANGE_MAX=8510
fi

centos_or_redhat=$(cat /etc/centos-release 2>/dev/null | wc -l)

DOCKERARGS=${DOCKERARGS}" -e BUILD_CONF=1 -e BUILD_METADATA=1 -e UPDATE_METADATA=1"

if [ ${centos_or_redhat} = 1 ]; then
    $(chcon -Rt svirt_sandbox_file_t ${dir}/${volume})
fi

# Check if running on mac
if [ $(uname) = "Darwin" ]; then

    # Check so the boot2docker vm is running
    if [ $(boot2docker status) != "running" ]; then
        boot2docker start
    fi
    $(boot2docker shellinit)

    checkPort $DYN_PORT_RANGE_MIN $DYN_PORT_RANGE_MAX
    checkPort $STATIC_PORT_RANGE_MIN $STATIC_PORT_RANGE_MAX
    checkPort $HOST_PORT $HOST_PORT

    openPort $DYN_PORT_RANGE_MIN $DYN_PORT_RANGE_MAX "DYN_PORT"
    openPort $STATIC_PORT_RANGE_MIN $STATIC_PORT_RANGE_MAX "STATIC_PORT"
    openPort $HOST_PORT $HOST_PORT "HOST_PORT"
    port_b2d=1

    echo "When using boot2docker "
    DOCKERENV="-e HOST_IP=$(boot2docker ip)"
else

    docker_ports=$(-p ${HOST_PORT}:${HOST_PORT})
    # if running on linux
    if [ $(id -u) -ne 0 ] && [ $(grep docker /etc/group | grep $USER | wc -l) = 0 ]; then
        sudo="sudo"
    fi
fi

if ${sudo} docker ps | awk '{print $NF}' | grep -qx ${name}; then
    echo "$0: Docker container with name $name already running. Press enter to restart it, or ctrl+c to abort."
    read foo
    ${sudo} docker kill ${name}
fi

mkdir log > /dev/null 2> /dev/null
mkdir server_logs > /dev/null 2> /dev/null

$sudo docker rm ${name} > /dev/null 2> /dev/null

${sudo} docker run --rm=true \
    --name ${name} \
    --hostname localhost \
    -v ${dir}/${volume}:/opt/oictest/etc \
    -v ${dir}/server_logs:/opt/oictest/src/oictest/test/oic_op/rp/server_log \
    -v ${dir}/log:/opt/oictest/src/oictest/test/oic_op/rp/log \
    ${docker_ports} \
    ${DOCKERENV} \
    $DOCKERARGS \
    -i -t \
    ${image}

# delete port forwarding
if [ $(uname) = "Darwin" ] && [ ${port_b2d} = 1 ]; then
    closePort $HOST_PORT $HOST_PORT "HOST_PORT"
    closePort $DYN_PORT_RANGE_MIN $DYN_PORT_RANGE_MAX "DYN_PORT"
    closePort $STATIC_PORT_RANGE_MIN $STATIC_PORT_RANGE_MAX "STATIC_PORT"
fi

cd $c_path
