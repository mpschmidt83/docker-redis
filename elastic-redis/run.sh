#!/bin/bash


function log(){
    format=$1
    shift
    printf "%s # %s \n" "$(date +'%d %b %H:%M:%S.%N')" "$(printf "${format}" "$@")"
}

function loadRedisConfig(){
    REDIS_CONFIG_FILE=redis.conf
    echo "" > ${REDIS_CONFIG_FILE}

    if [ -n "${REDIS_CONFIG}" ]; then
        log "|------------ Applying redis configuration from REDIS_CONFIG ------------|"

        while read -r line; do
            log "REDIS_CONFIG: %s" "$(eval echo ${line})"
            echo $(eval echo ${line}) >> ${REDIS_CONFIG_FILE}
        done <<< "${REDIS_CONFIG}"

        log "|-------------------------------------------------------------------------|"
    fi
}


function loadSentinelConfig(){
    SENTINEL_CONFIG_FILE=sentinel.conf
    echo "" > ${SENTINEL_CONFIG_FILE}

    if [ -n "${SENTINEL_CONFIG}" ]; then
        log "|---------- Applying redis configuration from SENTINEL_CONFIG ------------|"

        while read -r line; do
            log "SENTINEL_CONFIG: %s" "$(eval echo ${line})"
            echo $(eval echo ${line}) >> ${SENTINEL_CONFIG_FILE}
        done <<< "${SENTINEL_CONFIG}"

        log "|-------------------------------------------------------------------------|"
    fi
}


function loadClusterConfig(){
    CLUSTER_CONFIG_FILE=nodes.conf
    echo "" > ${CLUSTER_CONFIG_FILE}

    if [ -n "${CLUSTER_CONFIG}" ]; then
        log "|----------- Applying redis configuration from CLUSTER_CONFIG ------------|"

        while read -r line; do
            log "CLUSTER_CONFIG: %s" "$(eval echo ${line})"
            echo $(eval echo ${line}) >> ${CLUSTER_CONFIG_FILE}
        done <<< "${CLUSTER_CONFIG}"

        log "|-------------------------------------------------------------------------|"
    fi
}

function launchSentinelMaster() {

    master_addr=$(timeout 5 redis-cli -h ${SENTINEL_SERVICE_HOST} -p ${SENTINEL_SERVICE_PORT} --csv SENTINEL get-master-addr-by-name ${SENTINEL_MASTER_ID} | tr ',' ' ' | tr -d '"')
    if [[ -n ${master_addr} ]]; then
        log "MASTER address from sentinel=%s" "${master_addr}"
        launchSentinelSlave
     else
        pong=$(timeout 5 redis-cli -h ${SENTINEL_INIT_MASTER_HOST} -p ${SENTINEL_INIT_MASTER_PORT} PING)
        if [[ ${pong} == "PONG" ]]; then
            log "Failed launch as master, INIT MASTER is running on SENTINEL_INIT_MASTER_HOST=%s SENTINEL_INIT_MASTER_PORT=%s" ${SENTINEL_INIT_MASTER_HOST} ${SENTINEL_INIT_MASTER_PORT}
            sleep 5
            exit 1
         else
            log "MASTER doesn't exist, run node as SENTINEL MASTER"

            loadRedisConfig
            exec redis-server ${REDIS_CONFIG_FILE} "$@"
        fi
    fi

}

function launchRedisSentinel() {

    master_addr=$(timeout 5 redis-cli -h ${SENTINEL_SERVICE_HOST} -p ${SENTINEL_SERVICE_PORT} --csv SENTINEL get-master-addr-by-name ${SENTINEL_MASTER_ID} | tr ',' ' ' | tr -d '"')
    if [[ -n ${master_addr} ]]; then
        log "MASTER address from sentinel=%s" "${master_addr}"
    else
        master_addr="${SENTINEL_INIT_MASTER_HOST} ${SENTINEL_INIT_MASTER_PORT}"
        log "Set master_addr from initial service %s" "${master_addr}"
    fi

    MASTER_IP=$(echo ${master_addr} | cut -d' ' -f1 )
    MASTER_PORT=$(echo ${master_addr} | cut -d' ' -f2 )

    pong=$(timeout 5 redis-cli -h ${MASTER_IP} -p ${MASTER_PORT} PING)
    if [[ ${pong} != "PONG" ]]; then
        log "Connecting to MASTER failed, master_addr=%s" "${master_addr}"
        sleep 10
        exit 1
    fi

    log "MASTER is running on %s, run node as SENTINEL" "${master_addr}"

    loadSentinelConfig
    exec redis-sentinel ${SENTINEL_CONFIG_FILE} "$@" --sentinel

}

function launchSentinelSlave() {

    master_addr=$(timeout 5 redis-cli -h ${SENTINEL_SERVICE_HOST} -p ${SENTINEL_SERVICE_PORT} --csv SENTINEL get-master-addr-by-name ${SENTINEL_MASTER_ID} | tr ',' ' ' | tr -d '"')
    if [[ -n ${master_addr} ]]; then
        log "MASTER address from sentinel=%s" "${master_addr}"
    else
        log " Failed to find MASTER."
        sleep 30
        exit 1
    fi

    MASTER_IP=$(echo ${master_addr} | cut -d' ' -f1 )
    MASTER_PORT=$(echo ${master_addr} | cut -d' ' -f2 )

    pong=$(timeout 5 redis-cli -h ${MASTER_IP} -p ${MASTER_PORT} PING)
    if [[ ${pong} != "PONG" ]]; then
        log "Connecting to MASTER failed, master_addr=%s" "${master_addr}"
        sleep 10
        exit 1
    fi

    log "MASTER is running on %s, run node as SENTINEL SLAVE" "${master_addr}"

    loadRedisConfig
    exec redis-server ${REDIS_CONFIG_FILE} "$@" --slaveof ${MASTER_IP} ${MASTER_PORT}

}

function launchRedisClusterNode() {

    log "Run node as CLUSTER NODE"

    loadRedisConfig
    loadClusterConfig
    exec redis-server ${REDIS_CONFIG_FILE} "$@" --cluster-enabled yes

}

function launchRedisStandalone() {

    log "Run node as REDIS STANDALONE"

    loadRedisConfig
    exec redis-server ${REDIS_CONFIG_FILE} "$@"

}


function validateSentinelParams(){

    valid="true"

    SENTINEL_MASTER_ID=$(eval echo ${SENTINEL_MASTER_ID})
    if [ -n "${SENTINEL_MASTER_ID}" ]; then
         log "SENTINEL_MASTER_ID=%s" ${SENTINEL_MASTER_ID}
    else
        valid="false"
        log "SENTINEL_MASTER_ID is mandatory"
    fi

    SENTINEL_SERVICE_HOST=$(eval echo ${SENTINEL_SERVICE_HOST})
    if [ -n "${SENTINEL_SERVICE_HOST}" ]; then
         log "SENTINEL_SERVICE_HOST=%s" ${SENTINEL_SERVICE_HOST}
    else
        valid="false"
        log "SENTINEL_SERVICE_HOST is mandatory"
    fi

    SENTINEL_SERVICE_PORT=$(eval echo ${SENTINEL_SERVICE_PORT})
    if [ -n "${SENTINEL_SERVICE_PORT}" ]; then
         log "SENTINEL_SERVICE_PORT=%s" ${SENTINEL_SERVICE_PORT}
    else
        valid="false"
        log "SENTINEL_SERVICE_PORT is mandatory"
    fi

    if [ "${REDIS_NODE_TYPE}" == "SENTINEL_INIT_MASTER" ] || [ "${REDIS_NODE_TYPE}" == "SENTINEL" ]; then

        SENTINEL_INIT_MASTER_HOST=$(eval echo ${SENTINEL_INIT_MASTER_HOST})
        if [ -n "${SENTINEL_INIT_MASTER_HOST}" ]; then
             log "SENTINEL_INIT_MASTER_HOST=%s" ${SENTINEL_INIT_MASTER_HOST}
        else
            valid="false"
            log "SENTINEL_INIT_MASTER_HOST is mandatory"
        fi

        SENTINEL_INIT_MASTER_PORT=$(eval echo ${SENTINEL_INIT_MASTER_PORT})
        if [ -n "${SENTINEL_INIT_MASTER_PORT}" ]; then
             log "SENTINEL_INIT_MASTER_PORT=%s" ${SENTINEL_INIT_MASTER_PORT}
        else
            valid="false"
            log "SENTINEL_INIT_MASTER_PORT is mandatory"
        fi

    fi

    if [ "${valid}" == "false" ]; then
        sleep 15
        exit 1
    fi

}

log "|-------------------------------- Run Redis Node ---------------------------------|"

REDIS_NODE_TYPE=$(eval echo ${REDIS_NODE_TYPE})
log "REDIS_NODE_TYPE=%s" ${REDIS_NODE_TYPE}

log "Command line arguments [%s]" "$*"

if [[ "${REDIS_NODE_TYPE}" == "CLUSTER_NODE" ]]; then
    launchRedisClusterNode "$@"
elif [[ "${REDIS_NODE_TYPE}" == "SENTINEL_INIT_MASTER" ]]; then
    validateSentinelParams
    launchSentinelMaster "$@"
elif [[ "${REDIS_NODE_TYPE}" == "SENTINEL" ]]; then
    validateSentinelParams
    launchRedisSentinel "$@"
elif [[ "${REDIS_NODE_TYPE}" == "SENTINEL_SLAVE" ]]; then
    validateSentinelParams
    launchSentinelSlave "$@"
elif [[ "${REDIS_NODE_TYPE}" == "STANDALONE" ]]; then
    launchRedisStandalone "$@"
else
    log "Not supported REDIS_NODE_TYPE=%s" "${REDIS_NODE_TYPE}"
    sleep 15
    exit 1
fi

