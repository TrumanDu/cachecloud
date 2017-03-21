#!/bin/bash

###########################################################################
# @author: truman
# @desc: start cachecloud container
# @time: 2017-03-11
###########################################################################

SERVER_NAME=cachecloud
DEPLOY_DIR=/opt/cachecloud-web
STDOUT_FILE=${DEPLOY_DIR}/logs/cachecloud-web.log
WAR_FILE=${DEPLOY_DIR}/cachecloud-open-web-1.0-SNAPSHOT.war
cd /tmp/cachecloud-${CACHECLOUD_VERSION}/cachecloud-open-web/target/cachecloud-open-web-1.0-SNAPSHOT/WEB-INF/classes
if [[ -n "$cachecloud-db-url" ]]; then
sed -i "s/^.*cachecloud.db.url.*$/cachecloud.db.url = $cachecloud-db-url/" application.properties
fi
if [[ -n "$cachecloud-db-user" ]]; then
sed -i "s/^.*cachecloud.db.user.*$/cachecloud.db.user = $cachecloud-db-user/" application.properties
fi
if [[ -n "$cachecloud-db-password" ]]; then
sed -i "s/^.*cachecloud.db.password.*$/cachecloud.db.password = $cachecloud-db-password/" application.properties
fi
cd /tmp/cachecloud-${CACHECLOUD_VERSION}/cachecloud-open-web/target/
jar cf cachecloud-open-web-1.0-SNAPSHOT.war -C cachecloud-open-web-1.0-SNAPSHOT/ .
cp /tmp/cachecloud-${CACHECLOUD_VERSION}/cachecloud-open-web/target/cachecloud-open-web-1.0-SNAPSHOT.war ${base_dir}
JAVA_OPTS="-server -Xmx4g -Xms1g -Xss256k -XX:MaxDirectMemorySize=1G -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:G1ReservePercent=25 -XX:InitiatingHeapOccupancyPercent=40 -XX:+PrintGCDateStamps -Xloggc:/opt/cachecloud-web/logs/gc.log -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=100M -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/opt/cachecloud-web/logs/java.hprof -XX:+DisableExplicitGC -XX:-OmitStackTraceInFastThrow -XX:+PrintCommandLineFlags -XX:+UnlockCommercialFeatures -XX:+FlightRecorder -Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -Djava.util.Arrays.useLegacyMergeSort=true -Dfile.encoding=UTF-8"
echo -e "Starting the ${SERVER_NAME} ...\c"

 java $JAVA_OPTS -jar ${WAR_FILE}  > $STDOUT_FILE 2>&1
