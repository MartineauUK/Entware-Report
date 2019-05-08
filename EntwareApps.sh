#!/bin/sh

#===================================================================================================
#
#   https://github.com/Entware-ng/Entware-ng/wiki
#
#   http://pkg.entware.net/binaries/armv7/Packages.html
#
#   Entware-ng commands:
#
#       opkg find xxxxx*                Find packages e.g. any packages that begin with 'pixelserv'* or '*pdf*' will find any it anywhere case-insensitive
#                                       or old-skool "opkg list | grep transmission"
#
#       opkg list-installed
#       opkg files package_name         List files associated with package e.g. opkg files bind-dig
#
#       opkg update
#       opkg upgrade
#       opkg install    xxxxx
#       opkg remove     xxxxx
#
#       opkg list
#
# Useful packages: Usually installed in /opt/bin
#       htop
#       iftop                       # Hit t for display type; p to toggle port display
#       lsof
#       find        findutils
#           xargs
#       fuser       psmisc
#           peekfd
#           prtstat
#           killall
#           pstree
#       diff        diffutils
#           diff3
#           sdiff
#           cmp
#       xxd         Hex dump
#
#       tcpdump     Installed in /opt/sbin!!
#       column
#       dig         bind-dig
#       drill                               Alternative to dig
#       hostip                              Included as part of DNSCrypt-proxy ?
#       openssh-sftp-server
#       paste       coreutils-paste
#       coreutils-sort
#       coreutils-split
#
#       base64      coreutils-base64        v384.xx uses base64 encoding for the vpn_xxxx_custom2 fields!
#       bash
#       grep
#
#       mosquitto-client                    Used to send 'MQTT' topic messages to the 'MQTT Broker' Mosquitto on RaspberryPi/Windows etc.
#                                           e.g.    Install mosquitto on RaspberryPi : https://pastebin.com/Etn59ppp
#                                                   Subscribe to topic:     mosquitto_sub -d -u admin -P xxxxxxxxxx -t /RT-AC86U/Test
#                                                   Test from router:       mosquitto_pub -h 10.88.8.148 -t /RT-AC86U/Test -m "Myrouter is sending a test message"


# Print between line beginning with'#==' to first blank line inclusive
ShowHelp() {
    awk '/^#==/{f=1} f{print; if (!NF) exit}' $0
}
# shellcheck disable=SC2034
ANSIColours () {
    cRESET="\e[0m";cBLA="\e[30m";cRED="\e[31m";cGRE="\e[32m";cYEL="\e[33m";cBLU="\e[34m";cMAG="\e[35m";cCYA="\e[36m";cGRA="\e[37m"
    cBGRA="\e[90m";cBRED="\e[91m";cBGRE="\e[92m";cBYEL="\e[93m";cBBLU="\e[94m";cBMAG="\e[95m";cBCYA="\e[96m";cBWHT="\e[97m"
    aBOLD="\e[1m";aDIM="\e[2m";aUNDER="\e[4m";aBLINK="\e[5m";aREVERSE="\e[7m"
    cWRED="\e[41m";cWGRE="\e[42m";cWYEL="\e[43m";cWBLU="\e[44m";cWMAG="\e[45m";cWCYA="\e[46m";cWGRA="\e[47m"
}


ANSIColours

# Help request ?
if [ "$1" == "help" ] || [ "$1" == "-h" ];then      # Show help
   ShowHelp
   exit 0
fi

echo -e $cBYEL

opkg update

#opkg upgrade

echo -en $cRESET

# To refresh 'zlib' and 'lib*' except 'libc '......
# if [ "$1" == "ForceRefreshlib" ];then
    # opkg list-installed | grep -v "libc " | sed 's/ - .*$//' | grep lib | grep -v libpthread |grep -v libgcc | xargs -n 5 opkg --force-reinstall install
# fi

# Is the Entware 'column' utility installed?
if [ ! -f /opt/bin/column ];then                        # Untidy multi-columns! ;-)
    ls /opt/bin  | grep -v "opkg" | grep -v "\." | awk -v GREEN="$cBGRE" -v BLACK="$cRESET" -v WHITE_ON_RED="$cWRED" 'BEGIN {print WHITE_ON_RED"\nEntware Apps installed /opt/bin:"BLACK"\n"} {printf GREEN"%10s\t"$0} END {print BLACK}'
    ls /opt/sbin | grep -v "opkg" | grep -v "\." | awk -v GREEN="$cBGRE" -v BLACK="$cRESET" -v WHITE_ON_RED="$cWRED" 'BEGIN {print WHITE_ON_RED"\nEntware Apps installed /opt/sbin:"BLACK"\n"} {printf GREEN"%10s\t"$0} END {print BLACK}'
else

    echo -e $cRESET"\n"$cWRED"List of Installed packages:"$cRESET"\n"$cBMAG
    opkg list-installed >/tmp/column.txt
    column -or /tmp/column.txt

    echo -e $cRESET"\n"$cWRED"Entware Apps/Scripts installed /opt/bin:"$cRESET"\n"$cBGRE
    #ls /opt/bin | grep -v "opkg" | grep -v "\." >/tmp/column.txt
    ls -l /opt/bin | grep -v "opkg" | grep -v /jffs/scripts | awk '{print $9}' >/tmp/column.txt
    column -or /tmp/column.txt
    echo -e $cBCYA
    rm /tmp/column.txt
    [ -f /opt/bin/diversion ] && echo "diversion" >/tmp/column.txt      # Spoof 'diversion' as a script
    ls -l /opt/bin | awk '/scripts/ {print $9}' >>/tmp/column.txt
    sort /tmp/column.txt -o /tmp/column.txt
    column -or /tmp/column.txt

    echo -e $cRESET"\n"$cWRED"Entware Apps installed /opt/sbin:"$cRESET"\n"$cBGRE
    ls -l /opt/sbin | grep -v "opkg" | grep -v /jffs/scripts | awk '{print $9}' >/tmp/column.txt
    column -or /tmp/column.txt
    echo -e $cBCYA
    ls -l /opt/sbin | awk '/scripts/ {print $9}' >/tmp/column.txt
    column -or /tmp/column.txt
    echo -e $cRESET
    #rm /tmp/column.txt
fi

# To refresh 'zlib' and 'lib*' except 'libc '......
if [ "$1" == "ForceRefresh" ];then
    opkg --force-reinstall install $2
fi

echo -en $cRESET"\n"
