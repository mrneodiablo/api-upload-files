#!/usr/bin/env bash

set -e

# ======config for app=====
PROJECT_DIR=`pwd`/..
DAEMON=`which python2.7`

cd ${PROJECT_DIR}
# generate file init table
$DAEMON manage.py makemigrations main


# apply file config to create table
$DAEMON manage.py migrate