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

cd /tmp/cachecloud-${CACHECLOUD_VERSION}/cachecloud-open-web/target/
if [ ! -d 'newtmp' ]; then
 mkdir newtmp
unzip cachecloud-open-web-1.0-SNAPSHOT.war -d newtmp
rm -f cachecloud-open-web-1.0-SNAPSHOT.war
cd /tmp/cachecloud-${CACHECLOUD_VERSION}/cachecloud-open-web/target/cachecloud-open-web-1.0-SNAPSHOT/WEB-INF/classes
if [[ -n "$cachecloud-db-url" ]]; then
sed -i "s/^.*cachecloud.db.url.*$/cachecloud.db.url = $cachecloud_db_url/" application.properties
fi
if [[ -n "$cachecloud-db-user" ]]; then
sed -i "s/^.*cachecloud.db.user.*$/cachecloud.db.user = $cachecloud_db_user/" application.properties
fi
if [[ -n "$cachecloud-db-password" ]]; then
sed -i "s/^.*cachecloud.db.password.*$/cachecloud.db.password = $cachecloud_db_password/" application.properties
fi
cp application.properties /tmp/cachecloud-${CACHECLOUD_VERSION}/cachecloud-open-web/target/newtmp/WEB-INF/classes/
cd /tmp/cachecloud-${CACHECLOUD_VERSION}/cachecloud-open-web/target/
jar cvfm0 cachecloud-open-web-1.0-SNAPSHOT.war ./newtmp/META-INF/MANIFEST.MF  -C newtmp/ .
cp /tmp/cachecloud-${CACHECLOUD_VERSION}/cachecloud-open-web/target/cachecloud-open-web-1.0-SNAPSHOT.war ${base_dir}
fi

JAVA_OPTS="-server -Xmx4g -Xms256g -Xss256k -XX:MaxDirectMemorySize=1G -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:G1ReservePercent=25 -XX:InitiatingHeapOccupancyPercent=40 -XX:+PrintGCDateStamps -Xloggc:/opt/cachecloud-web/logs/gc.log -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=100M -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/opt/cachecloud-web/logs/java.hprof -XX:+DisableExplicitGC -XX:-OmitStackTraceInFastThrow -XX:+PrintCommandLineFlags  -Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -Djava.util.Arrays.useLegacyMergeSort=true -Dfile.encoding=UTF-8"
echo -e "Starting the ${SERVER_NAME} ...\c"
cd ${base_dir}
 java $JAVA_OPTS -jar ${WAR_FILE}  > $STDOUT_FILE 2>&1
