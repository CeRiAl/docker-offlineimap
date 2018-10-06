FROM lsiobase/alpine:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Cryptopath.org version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="CeRiAl"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
	offlineimap \
	ca-certificates

# copy local files
COPY root/ /

# environment
ENV CRON_SCHEDULE '0 3 * * *'

# volumes
VOLUME /config /mail /secrets
