#!/bin/bash

TFS_PATH=/apps/dpp01/label-tool/models_serving

MODELS_PATH=$TFS_PATH/models
CACHE_PATH=$TFS_PATH/cache
CONFIG_FILE=$TFS_PATH/models.config
DOCKER_FILE_PATH=~/git/label-tool/docker

function get_updated_models(){
    test -d $CACHE_PATH || mkdir -p $CACHE_PATH

    if [ $(ls -1 $CACHE_PATH | wc -l) -eq 0 ]
    then
        ls -1 $MODELS_PATH |sort > $CACHE_PATH/$(date +%s).txt
        cat $CACHE_PATH/$(date +%s).txt
        return
    fi

    ls -1 $MODELS_PATH |sort > $CACHE_PATH/$(date +%s).txt
    this=$(ls -1 $CACHE_PATH |sort |tail -1)
    last=$(ls -1 $CACHE_PATH |sort |tail -2 |head -1)

    if [ -z "$(comm -3 $CACHE_PATH/$this $CACHE_PATH/$last |xargs)" ]
    then
        rm $CACHE_PATH/$this
    elif [ -n "$(cat $CACHE_PATH/$this)" ]
    then
        cat $CACHE_PATH/$this
    else
        echo "EMPTY_FILE"
    fi
}

function create_new_conf_file(){
    local models="$@"
    echo "model_config_list: {" > $CONFIG_FILE
    for model in $(echo $models)
    do
        if [ $model != "EMPTY_FILE" ]
        then
            echo "  config: {" >> $CONFIG_FILE
            echo "    name: \"$model\","  >> $CONFIG_FILE
            echo "    base_path: \"/models/models/$model\"," >> $CONFIG_FILE
            echo "    model_platform: \"tensorflow\"" >> $CONFIG_FILE
            echo "  }," >> $CONFIG_FILE
        fi
    done
    echo "}" >> $CONFIG_FILE
}

function shutdown_tfs(){
    cd $DOCKER_FILE_PATH
    container=$(docker ps -a --filter "ancestor=tensorflow/serving:2.2.0" --format "{{.ID}}")
    if [ "$container" != "" ]
    then
        /usr/local/bin/docker-compose -f docker-compose.serving.yml down;
    fi
}

function makesure_tfs(){
    cd $DOCKER_FILE_PATH
    container=$(docker ps --filter "ancestor=tensorflow/serving:2.2.0" --format "{{.ID}}")
    if [ "$container" = "" ]
    then
        /usr/local/bin/docker-compose -f docker-compose.serving.yml up -d;
    fi
}

models=$(get_updated_models)
if [ "$models" != "" ]
then
    create_new_conf_file $models
    shutdown_tfs
fi
makesure_tfs


#*/2 * * * * /bin/bash ~/git/label-tool/docker/tfs_deploy.sh
