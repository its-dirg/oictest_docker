#!/bin/sh
USAGE_STRING="usage: install.sh install_path"

#basePath=${1%/} # Strip any trailing slash
homePath=~
basePath=$homePath/projects
mkdir $basePath

if [ "$(uname)" = "Darwin" ]; then
    os="mac"
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
    os="debian"
fi

if [ "$os" != "debian" ] && [ "$os" != "mac" ]; then
    echo "Operating system could not be automatically detected: this script only works on Debian-based systems and Mac OS X."
    exit
fi
echo "Detected ${os} and installing in ${basePath}"

installFromGitHub() {
    if [ "$#" -ne 2 ]; then
        echo "usage: installFromGit repo-name repo-address"
        exit
    fi

    echo "Installing $1..."
    path="${basePath}/${1}"
    sudo rm -fr ${path}
    git clone ${2} ${path}
    echo "Running setup.py (this can take a while)."
    sudo pip install ${path} > /dev/null 2>&1
    echo "$1 installed"
}

# necessary programs before any installation
if [ "${os}" = "debian" ]; then
        sudo apt-get -y install git gcc wget python-setuptools python-dev python-ldap python-pip
        sudo apt-get install libffi-dev libssl-dev
    elif [ "${os}" = "mac" ]; then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        brew doctor
        brew install wget
    fi

installFromGitHub "oictest" "https://github.com/rohe/oictest"
installFromGitHub "dirg-util" "https://github.com/its-dirg/dirg-util"

sudo pip install cherrypy
sudo pip install urllib3
sudo pip install pyopenssl
sudo pip install ndg-httpsclient
sudo pip install pyasn1
sudo pip install dataset
sudo pip install prettytable

cp $basePath/oictest/test/oic_op/rp/sslconf.py.example $basePath/oictest/test/oic_op/rp/sslconf.py

