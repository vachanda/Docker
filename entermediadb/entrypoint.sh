#!/bin/bash

SITE=$1
NODENUMBER=$2
USERID=$3
GROUPID=$4

INSTANCE=$SITE$NODENUMBER

ENDPOINT=/media/emsites/$SITE

# Create entermedia user if needed
if [[ ! $(id -u entermedia 2> /dev/null) ]]; then
  groupadd entermedia > /dev/null
  useradd -g entermedia entermedia > /dev/null
fi

# Initialize site root
mkdir -p ${ENDPOINT}/{webapp,data,$NODENUMBER,elastic,services}
chown entermedia. ${ENDPOINT}
chown entermedia. ${ENDPOINT}/{webapp,data,$NODENUMBER,elastic,services}

# Create custom scripts
SCRIPTROOT=${ENDPOINT}/$NODENUMBER
echo "sudo bash $SCRIPTROOT/entermedia-docker.sh $SITE $NODENUMBER" > ${SCRIPTROOT}/update.sh
echo "sudo docker exec -it -u 0 $INSTANCE entermediadb-update.sh" > ${SCRIPTROOT}/updatedev.sh
cp  $0  ${SCRIPTROOT}/entermedia-docker.sh 2>/dev/null
chmod 755 ${SCRIPTROOT}/*.sh

# Fix permissions
chown -R entermedia. "${ENDPOINT}/$NODENUMBER"
rm -rf "/tmp/$NODENUMBER"  2>/dev/null
mkdir -p "/tmp/$NODENUMBER"
chown entermedia. "/tmp/$NODENUMBER"

/usr/bin/entermediadb-deploy.sh $USERID $GROUPID
