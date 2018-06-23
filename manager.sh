#!/bin/bash

set -e

prj_dir=$(cd $(dirname $0); pwd -P)

image_version='1.0.3'
image_name="liaohuqiu/cube-box:$image_version"

env='prod'
app_name='cube-box'
container_name='cube-box'

function link_node_modules() {
    if [ -d "$1/node_modules" ]; then
        run_cmd "rm $1/node_modules"
    fi
    run_cmd "ln -sf /opt/node_npm_data/node_modules $1"
}

function build_image() {
    docker build -t $image_name $prj_dir/docker
}

function run() {
    local projects_dir_in_host="$prj_dir/projects"
    link_node_modules $projects_dir_in_host
    local uid=`id -u`
    local args=$(base_docker_args $env $container_name)
    args="$args -v $projects_dir_in_host:/opt/src"
    args="$args -p 3000:3000"
    args="$args -p 8545:8545"
    args="$args -w /opt/src"
    local cmd_args='tail -f /dev/null'
    local cmd="docker run -d $args $image_name $cmd_args"
    run_cmd "$cmd"
}

function stop() {
    stop_container $container_name
}

function restart() {
    stop
    run
}

function attach() {
    local cmd="docker exec $docker_run_fg_mode $container_name bash"
    run_cmd "$cmd"
}

function run_tests() {
    restart
    local cmd='ganache-cli -a 20 -e 1000 > /dev/null'
    cmd="$cmd & sleep 2; cd /opt/src/lesson-2"
    cmd="$cmd; truffle test"
    local cmd="docker exec $docker_run_fg_mode $container_name bash -c '$cmd'"
    run_cmd "$cmd"
    stop
}

function help() {
	cat <<-EOF
        Valid options are:

            build_image

            run
            stop
            restart

            attach

            run_tests

            help                      show this help message and exit

EOF
}

source "$prj_dir/apuppy/bash-files/base.sh"
action=${1:-help}
$action "$@"
