#!/bin/bash

DEFAULT_CLIENTS=$(cat /proc/cpuinfo |grep processor |wc -l)

if [ ! -z $KAFKA_DNS ]; then
	KAFKA_BROKERS=$(drill ${KAFKA_DNS} | grep "^${KAFKA_DNS}." | awk '{ print $5 }' | xargs -I {} echo {}:9092 | paste -s -d',')${ZK_PATH}
fi

MISSING_VAR_MESSAGE="must be set"
: ${TOPIC:?$MISSING_VAR_MESSAGE}
: ${KAFKA_BROKERS:?$MISSING_VAR_MESSAGE}

COMPRESSION="${COMPRESSION:-none}"
BATCH_SIZE="${BATCH_SIZE:-1000}"
MSG_SIZE="${MSG_SIZE:-1000}"
CLIENTS="${CLIENTS:-$DEFAULT_CLIENTS}"
PRODUCERS="${PRODUCERS:-5}"
NOOP="${NOOP:-false}"

CMD="/go/bin/sangrenel -batch=${BATCH_SIZE} -brokers="${KAFKA_BROKERS}" -clients=${CLIENTS} -compression="${COMPRESSION}" -noop=${NOOP} -producers=${PRODUCERS} -size=${MSG_SIZE} -topic="${TOPIC}""
echo $CMD
$CMD
