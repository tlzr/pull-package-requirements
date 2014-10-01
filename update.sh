#!/bin/bash

function help {
    echo '
Usage:
       ./update.sh [username]
'
    exit 1
}

function current_directory {
    echo "Current directory is: `pwd`"
}

if [ $# -eq 0 ]
then
    WHOAMI=`whoami`
    echo "Press [ENTER] if you want to use this name: $WHOAMI"
    read USERNAME
    if [ -z $USERNAME ]
    then
        USERNAME=$WHOAMI
    fi
elif [ $# -gt 1 ]
then
    help
fi

HOMEDIR="/home"
UPDATEDIR="${HOMEDIR}/${USERNAME}/debrpm/update"
LOGDIR="${HOMEDIR}/${USERNAME}/history"
URL='https://gerrit.mirantis.com/openstack'

/bin/mkdir -p $UPDATEDIR
/bin/mkdir -p $LOGDIR

echo "Sources are in ${UPDATEDIR} folder"
echo "Logs are in ${LOGDIR} folder"

for i in nova python-novaclient
do
    if [ ! -d "${UPDATEDIR}/$i" ]
    then
        cd $UPDATEDIR
        current_directory
        git clone ${URL}/$i
        echo "Cloning ${URL}/$i"
    else
        cd ${UPDATEDIR}/$i
        current_directory
        echo "
######################
`date +'%a, %d %b %Y %H:%M:%S %z'`
######################
" >> ${LOGDIR}/$i.log
        git fetch >> ${LOGDIR}/$i.log
        git diff master origin/master >> ${LOGDIR}/$i.log
        git merge origin/master
    fi
done

unset BACKUPDIR HOMEDIR UPDATEDIR USERNAME URL
