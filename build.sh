#!/bin/bash
TODAY=`date +%Y%m%d`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
NAME="$(cut -d- -f2- <<< ${PWD##*/})"
echo "Building $NAME:$TODAY"

docker build . --no-cache=true -t shakataganai/$NAME:$TODAY
docker tag shakataganai/$NAME:$TODAY  shakataganai/$NAME:latest
#docker push shakataganai/$NAME:$TODAY
#docker push shakataganai/$NAME:latest