#!/bin/bash
# rmWGClient.sh
# This script removes a WireGuard user's tunnel based on the provided extension.

sExtension=

function badusage() {
    echo "ERROR: Incorrect arguments provided."
    usage
    echo "Terminating without processing."
    exit 1
}

function usage() {
    echo "rmWGClient: A tool to remove WireGuard clients."
    echo ""
    echo "Usage: $0 extension"
    echo "  extension: a 3-6 digit number that represents the user's tunnel extension."
}

function getParams() {
    sExtension=$1

    if [[ ${#sExtension} -lt 3 || ${#sExtension} -gt 6 ]]; then
        echo "Bad extension number. It should be 3-6 digits."
        badusage
    fi
}

function removeClient() {
    # If wg is not running, abort
    ip a | grep -Eq ': wg0' || {
        echo "Error: wg is not running. Please ensure WireGuard is running before removing the client tunnel."
        exit 1
    }

    sFile="client.configs/client.$sExtension.conf"

    if [ -f "$sFile" ]; then
        sKeyPrivateKey=`cat $sFile | grep PrivateKey | cut -f2 -d"=" | sed 's/ //g'`=
        sKeyPublic=$(echo "$sKeyPrivateKey" | wg pubkey)
        echo "PrivateKey: $sKeyPrivateKey"
        echo "Public: $sKeyPublic"
        wg set wg0 peer "$sKeyPublic" remove

        # get the current date -- oj
        currentDateTime=$(date "+%F-%H-%M")

        # Concatenate variable with date -- oj
        sFileWDate="${currentDateTime}.client.${sExtension}.conf"

        # move file to a delete config folder and remanme the file adding the date --oj
        mv "$sFile" /home/ravpn/removed.client.configs/$sFileWDate

        echo "WireGuard client tunnel with extension $sExtension has been removed."
    else
        echo "WireGuard client tunnel with extension $sExtension does not exist."
    fi
}

function start() {
    getParams "$@"
    removeClient
}

start "$@"
echo "# Done with Script"