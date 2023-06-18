#!/bin/bash
#getClient.sh  Extension.
# This script generates public/private key combinations for WireGuard and adds them to the wg server config.
# pass extension as a 3 or 4 digit number.  It will become the suffix of the Client IP address.

sExtension=
sUsername=
sIPsfx=
force=false

function badusage()
{
        echo "ERROR, called with incorrect arguments."
        usage
        echo "Terminating without processing."
        exit
}

function usage()
{
        echo "genWGClient: A tool that generates WireGuard clients."
        echo ""
        echo "Usage: $0 extension username [-f]"
        echo "  extension: a 3-6 digit number that will become two octets of an ip address10.4.x.x"
        echo "  username: any value, no spaces.  Stored only for administrative purposes."
        echo "  -f (optional): forces the recreation of this record (by default an existing record will not be recreated)"
}

function getParams()
{
        sExtension=$1
        sUsername=$2
        #echo's out the Client file

        sFile=client.configs/client.$sExtension.conf

        #echo $keyPrivate $CLpublilc
        if [ ${#sExtension} -eq 3 ]; then
                sIP3=${sExtension:0:1}
                sIP4=${sExtension:1:2}
        elif [ ${#sExtension} -eq 4 ]; then
                sIP3=${sExtension:0:2}
                sIP4=${sExtension:2:2}
        elif [ ${#sExtension} -eq 5 ]; then
                sIP3=${sExtension:0:2}
                if [[ ${sIP3:0:1} == "1" ]] || [[ $(sIP3:0:1) == "2" ]]; then
                        sIP3=${sExtension:0:3}
                        sIP4=${sExtension:3:2};
                else
                        sIP4=${sExtension:2:3};
                fi
        elif [ ${#sExtension} -eq 6 ]; then
                sIP3=${sExtension:0:3}
                sIP4=${sExtension:3:3}
        else
                echo "Bad extension number, needs to be be 3-6 digits"
                badusage
        fi

        sIP3=$((10#$sIP3))
        sIP4=$((10#$sIP4))
        sIPsfx=$sIP3.$sIP4
        while [ "$1" != "" ]; do
                case $1 in
                        -f | --file )           shift
                                force=true
                                ;;
                        -i | --interactive )    interactive=1
                                ;;
                        -h | --help )           usage
                                exit
                                ;;
                esac
                shift
        done

        if [ -z "$sUsername" ]; then
                echo "Username missing"
                badusage
        fi
}
function getClient()
{
        #If wg not on, abort
        abortNow=0
        ip a | grep -Eq ': wg0' || abortNow=1

        if [ $abortNow -eq 1 ]; then
                echo "Error: wg is not running, perhaps run it with command: wg-quick up wg0 "
                exit
        fi

        #Gen keys
        sKeyPrivate=`wg genkey`
        sKeyPublic=`echo $sKeyPrivate | wg pubkey`

        getWG
}

function getWG()
{
        echo "IP"
        echo $sIPsfx
        sKeyPublic=`echo $sKeyPrivate | wg pubkey`
        cat clienttemplate.conf | sed 's,%varIP,'"$sIPsfx"',' | sed 's,%varPrivateKey,'"$sKeyPrivate"',' | sed 's,%varUsername,'"$sUsername"',' > $sFile

        wg set wg0 peer $sKeyPublic allowed-ips 10.4.$sIPsfx/32
        #This modifis /etc/wireguard/wg0.conf
}

function readExistingFile()
{
        sKeyPrivate=`cat $sFile | grep PrivateKey | cut -f2 -d "=" | sed 's/ //g'`=
        sExistingUsername=`cat $sFile | grep Client | cut -f2 -d":"`

        charLen=${#sKeyPrivate}
        if [ "$charLen" -lt 10 ]; then
               echo "NO key found in file $sFile"
                exit;
        else
                echo "#Client already exists with existing Private key"
                echo "#Existing username was: "$sExistingUsername
        fi;

        if [ "${sExistingUsername,,}" = "${sUsername,,}" ]; then
                echo "#username match"
        else
                echo "#Username dont match!  If this is intended, then use -f"
                if [ "$force" = false ]; then badusage; fi
        fi
}

function processCreateWG()
{
        if [ -f "$sFile" ]; then
                readExistingFile
                getWG
                echo "#Displaying file $sFile"
                cat $sFile
        else    ## normal case
                getClient
                cat $sFile
        fi
}

function start()
{
        getParams $*
        processCreateWG
}

start $*
echo "#Done with Script"


./rmWGClient.sh: line 40: oAOFRliaCHETW5PKzyFKIwEcoCJWG0NXKZ74mj4CIGM=: command not found
wg: Key is not the correct length or format
sKeyPrivateKey

client.configs/client.1144.conf
WireGuard client tunnel with extension 1144 has been removed.
#Done with Script

        sKeyPublic=`echo $sKeyPrivateKey | wg pubkey`
        echo "sKeyPrivateKey"