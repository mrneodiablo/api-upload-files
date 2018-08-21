#!/bin/bash


DIR_PROJECT_TOOL="/data/uploadfile/"
WEB_APP="uwsgi"


# start web app
cd ${DIR_PROJECT_TOOL}/tool/
chmod +x *

bash generate_database_table.sh

bash init_web_app.sh start


while sleep 60; do

  ps aux |grep ${web_app} |grep -q -v grep
  PROCESS_STATUS=$?

  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
done
