#!/bin/bash

function generate_mongod_config() {

touch /etc/mongod.conf

cat > /etc/mongod.conf << EOL
---
systemLog:
  verbosity: 2
  path: `echo $1 | jq '.log_path'`
  logAppend: true
  logRotate: reopen
  destination: file
net:
  port: `echo $1 | jq '.port'`
security:
  authorization: disabled
storage:
  dbPath: `echo $1 | jq '.dbPath'`
  journal:
    enabled: true
  engine: wiredTiger
replication:
  replSetName: `echo $1 | jq '.replSetName'`
EOL

if [ $2 == "configsvr" ]
then
cat >> /etc/mongod.conf << EOL
sharding:
  clusterRole: configsvr
EOL
fi

}

function generate_mongos_config() {

touch /etc/mongos.conf;

cat > /etc/mongos.conf << EOL
---
net:
  port: `echo $1 | jq '.port'`
systemLog:
  path: `echo $1 | jq '.log_path'`
  logAppend: true
  logRotate: reopen
  destination: file
sharding:
  autoSplit: true
  configDB: `echo $1 | jq '.configDB'`
  chunkSize: 64
EOL
}
