#!/bin/bash -x

UPDATEDIR='~/debrpm/update'
BACKUPDIR='~/history'

for i in 'nova python-novaclient'
do
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
