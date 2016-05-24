#!/bin/bash
set -ex

MONGO_LOG="/var/log/mongodb/mongod.log"
MONGO="/usr/bin/mongo"
MONGOD="/usr/bin/mongod"
MONGOS="/usr/bin/mongos"

#Construct the nodes array
declare -a NODES=($NODE1 $NODE2 $NODE3)

function replicaInitiate() {

  configsvr_status=false
  if [ $REPL_NAME == "configsvr" ]
  then
    configsvr_status=true
  fi

  local config="{\"_id\":\"$REPL_NAME\",\
                 \"members\": \
                   [{\"_id\": 0, \"host\": \"$NODE1:$PORT\"},\
                   {\"_id\": 1, \"host\": \"$NODE2:$PORT\"},],\
                 \"configsvr\": $configsvr_status
                }"

  config=`echo -e ${config} | tr -d '[:space:]'`

  $MONGO --host localhost:$PORT --eval "rs.initiate($config)"
}

case "$1" in
  (replicate)
    replicaInitiate
    exit 0
    ;;
  (*)
esac

mongodConfigJson="{\"log_path\":\"$MONGO_LOG\",\
                  \"port\":$PORT,\
                  \"dbPath\":\"$DBPATH\",
                  \"replSetName\":\"$REPL_NAME\"}"

mongosConfigJson="{\"log_path\":\"$MONGO_LOG\",\
                  \"port\":$PORT,\
                  \"configDB\":\"$CONFIG_REPL_NAME/$CONF_SVR1,$CONF_SVR2,$CONF_SVR3\"}"

config=$1"ConfigJson"
declare $1ConfigJson=`echo -e ${!config} | tr -d '[[:space:]]'`

source /root/configGenerator.sh
generate_$1_config ${!config} $REPL_NAME

if [ $1 == "mongod" ]
then
  service atd restart
  echo "/root/startUp.sh replicate" | at now + 2 minutes
fi

$1 --config /etc/$1.conf
