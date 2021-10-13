#!/bin/bash -l
set -eo pipefail

export TERRASCAN_VERSION=${TERRASCAN_VERSION:="1.11.0"}

print_title(){
    echo "#####################################################"
    echo "$1"
    echo "#####################################################"
}

get_terrascan() {
    cd /tmp
    curl -Lo ./terrascan.tar.gz "https://github.com/accurics/terrascan/releases/download/v${TERRASCAN_VERSION}/terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz"
    tar -xzf terrascan.tar.gz
    chmod +x terrascan
    mv -f terrascan /usr/local/bin/terrascan
    terrascan version
}

install_terrascan() {
    print_title "Installing terrascan: ${TERRASCAN_VERSION}"
    if ! command -v terrascan; then
        echo "terrascan is missing"
        get_terrascan
    elif ! [[ $(terrascan version | cut -d' ' -f2) == *${TERRASCAN_VERSION}* ]]; then
        echo "terrascan $(terrascan version | cut -d' ' -f2) is not desired version"
        get_terrascan
    fi
}

remove_terrascan(){
    print_title "Removing terrascan: ${TERRASCAN_VERSION}"
    sudo rm -rf /usr/local/bin/terrascan
}
