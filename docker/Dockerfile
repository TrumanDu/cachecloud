#################################
#version: 1.2
#desc: cachecloud 镜像
#################################
FROM maven:3.3.9-jdk-8-alpine

MAINTAINER truman

ENV CACHECLOUD_VERSION 1.2
ENV base_dir /opt/cachecloud-web
WORKDIR ${base_dir}
RUN apk  --update add curl tar bash
RUN    curl -fsSL -o /tmp/cachecloud.tar.gz https://github.com/sohutv/cachecloud/archive/${CACHECLOUD_VERSION}.tar.gz && \
       tar -C /tmp -xzf /tmp/cachecloud.tar.gz
RUN    rm -rf /tmp/cachecloud.tar.gz
RUN    cd /tmp/cachecloud-${CACHECLOUD_VERSION}
RUN    mvn clean compile install -Plocal 
RUN    mkdir -p ${base_dir}/logs && \
    cp /tmp/cachecloud-${CACHECLOUD_VERSION}/script/start.sh ${base_dir} && \
    cp /tmp/cachecloud-${CACHECLOUD_VERSION}/cachecloud-open-web/target/cachecloud-open-web-1.0-SNAPSHOT.war ${base_dir} && \
    cp /tmp/cachecloud-${CACHECLOUD_VERSION}/cachecloud-open-web/src/main/resources/cachecloud-web.conf  ${base_dir}/cachecloud-open-web-1.0-SNAPSHOT.conf

VOLUME ${base_dir}
COPY start-container.sh ${base_dir}
ENTRYPOINT  ["bash","start-container.sh"]
EXPOSE 9999 8585
