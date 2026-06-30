ARG UPSTREAM_TAG=latest
FROM docker.io/ghostchu/peerbanhelper:${UPSTREAM_TAG} AS upstream

FROM wushuo894/openj9:open-25-jre
USER 0
EXPOSE 9898
ENV TZ=UTC
WORKDIR /app
VOLUME /tmp
COPY --from=upstream /app/libraries /app/libraries
COPY --from=upstream /app/PeerBanHelper.jar /app/PeerBanHelper.jar
ENTRYPOINT ["sh", "-c", "java -Xtune:virtualized -Xsoftmx386M -Xmx512m -Xmaxf0.15 -Xminf0.05 -XX:IdleTuningMinIdleWaitTime=30 -XX:IdleTuningGcOnIdle -Xss256k --enable-native-access=ALL-UNNAMED -Djdk.attach.allowAttachSelf=true -Dsun.net.useExclusiveBind=false -Dpbh.release=docker -Djava.awt.headless=true -jar PeerBanHelper.jar"]