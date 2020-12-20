#!/bin/bash


# Build docker image for flask project
function build_flask(){
    if [ "$1" != "proxy" ]
    then
        local ROOT_DIR="flask"
    else
        local ROOT_DIR="flask_proxy"
    fi

    # prepare
    mkdir -p build
    cp -r $ROOT_DIR build/flask
    
    # build docker image for flask
    docker build build/flask

    # cleanup
    rm -rf build
}


# Comment the line which you do not need to run.

########################
# Build docker image when there is no proxy
########################
build_flask
# build_train proxy