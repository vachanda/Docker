#!/bin/bash
set -x
MONGO_LOG="/var/log/mongodb/mongod.log"
MONGO="/usr/bin/mongo"
MONGOD="/usr/bin/mongod"
$MONGOD --fork --replSet $REPL_NAME --logpath $MONGO_LOG
$MONGO --eval "rs.slaveOk()"

checkSlaveStatus(){
SLAVE=$1
$MONGO --host $SLAVE:$PORT --eval db
while [ "$?" -ne 0 ]
do
echo "Waiting for slave to come up..."
sleep 15
$MONGO --host $SLAVE:$PORT --eval db
done
}

if [ "$ROLE" == "master" ]
then
$MONGO --eval "rs.initiate({_id: \"${REPL_NAME}\", members:[{\"_id\":1, \"host\":\"${MASTER}:${PORT}\"}]})"
checkSlaveStatus $SLAVE1
$MONGO --eval "rs.add(\"${SLAVE1}:${PORT}\")"
checkSlaveStatus $SLAVE2
$MONGO --eval "rs.add(\"${SLAVE2}:${PORT}\")"
fi

tail -f /dev/null
