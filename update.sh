#!/bin/bash -x

UPDATEDIR='~/debrpm/update'
BACKUPDIR='~/history'

/bin/mkdir -p $UPDATEDIR
/bin/mkdir -p $BACKUPDIR

for i in 'nova python-novaclient'
do
    if [ ! -d ${UPDATEDIR}/$i ]
    then
        cd $UPDATEDIR
        git clone https://gerrit.mirantis.com/openstack/$i
    fi
    cd ${UPDATEDIR}/$i
    echo "
    ######################
    date +"%a, %d %b %Y %H:%M:%S %z
    " >> ${BACKUPDIR}/$i.log
    git fetch >> ${BACKUPDIR}/$i.log
    git diff master origin/master >> ${BACKUPDIR}/$i.log
    git merge origin/master
done

unset UPDATEDIR BACKUPDIR
