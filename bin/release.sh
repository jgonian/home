#!/bin/bash

NUMBER_OF_ARGS=$#
if [ $NUMBER_OF_ARGS -ne 2 ]; then
	echo -e "\nUsage: $0 <RELEASE VERSION> <DEVELOPMENT VERSION>"
	echo -e "\nFor example,  $0 1.23 1.24\n"
	exit 1
fi

RELEASE_VERSION="$1"
DEVELOPMENT_VERSION="$2"-SNAPSHOT
#DATE=`date +%Y%m%d`
#TAG=RELEASE-$RELEASE_VERSION-$DATE
TAG=$RELEASE_VERSION

echo -e "SCM Tag:\t\t$TAG"
echo -e "New release version:\t$RELEASE_VERSION"
echo -e "Development version:\t$DEVELOPMENT_VERSION"

read -p "Perform the release (y/n)? "
[[ $REPLY = [yY] ]] && mvn release:prepare --batch-mode \
						-Dtag=$TAG \
						-DreleaseVersion=$RELEASE_VERSION \
						-DdevelopmentVersion=$DEVELOPMENT_VERSION \
						-DpreparationGoals="clean install" \
						-DupdateDependencies=false \
						-DautoVersionSubmodules=true

RETVAL=$?
[ $RETVAL -eq 0 ] && mvn release:perform -Dgoals="deploy"
[ $RETVAL -ne 0 ] && echo -e "\nFailed to release, you might need to clean up with mvn release:rollback and/or mvn release:clean\n"

